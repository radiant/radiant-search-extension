class SearchPage < Page
  description "Provides tags and behavior to support searching Radiant.  Based on Oliver Baltzer's search_behavior."
  attr_accessor :query_result, :query
  #### Tags ####
   
  desc %{    Renders the passed query.}
  tag 'search:query' do |tag|
    CGI.escapeHTML(query)
  end
  
  desc %{   Renders the contained block when query is blank.}
  tag 'search:initial' do |tag|
    if query.empty?
      tag.expand
    end
  end
 
  desc %{   Renders the contained block if no results were returned.}
  tag 'search:empty' do |tag|
    if query_result.blank? && !query.empty?
      tag.expand
    end
  end
  
  desc %{    Renders the contained block if results were returned.}
  tag 'search:results' do |tag|
    unless query_result.blank?
      tag.expand
    end
  end

  desc %{    Renders the contained block for each result page.  The context
    inside the tag refers to the found page.}
  tag 'search:results:each' do |tag|
    returning String.new do |content|
      query_result.each do |page|
        tag.locals.page = page
        content << tag.expand
      end
    end
  end

  desc %{    Quantity of search results fetched.}
  tag 'search:results:quantity' do |tag|
    query_result.blank? ? 0 : query_result.size
  end

  desc %{    <r:truncate_and_strip [length="100"] />
    Truncates and strips all HTML tags from the content of the contained block.  
    Useful for displaying a snippet of a found page.  The optional `length' attribute
    specifies how many characters to truncate to.}
  tag 'truncate_and_strip' do |tag|
    tag.attr['length'] ||= 100
    length = tag.attr['length'].to_i
    helper.truncate(helper.strip_tags(tag.expand).gsub(/\s+/," "), length)
  end
  
  desc %{    <r:search:highlight [length="100"] />
    Highlights the search keywords from the content of the contained block.
    Strips all HTML tags and truncates the relevant part.      
    Useful for displaying a snippet of a found page.  The optional `length' attribute
    specifies how many characters to truncate to.}
  tag 'highlight' do |tag|    
    length = (tag.attr['length'] ||= 100).to_i
    content = helper.strip_tags(tag.expand).gsub(/\s+/," ")
    match  = content.match(query.split(' ').first)
    if match
      start = match.begin(0)
      begining = (start - length/2)
      begining = 0 if begining < 0
      chars = content.chars
      relevant_content = chars.length > length ? (chars[(begining)...(begining + length)]).to_s + "..." : content
      helper.highlight(relevant_content, query.split)      
    else
      helper.truncate(content, length)
    end    
  end  
  
  #### "Behavior" methods ####
  def cache?
    false
  end
  
  def render
    @query_result = []
    @query = ""
    q = @request.parameters[:q]
    case Page.connection.adapter_name.downcase
    when 'postgresql'
      sql_content_check = "((lower(page_parts.content) LIKE ?) OR (lower(title) LIKE ?))"
    else
      sql_content_check = "((LOWER(page_parts.content) LIKE ?) OR (LOWER(title) LIKE ?))"
    end
    unless (@query = q.to_s.strip).blank?
      tokens = query.split.collect { |c| "%#{c.downcase}%"}
      pages = Page.find(:all, :order => 'published_at DESC', :include => [ :parts ],
          :conditions => [(["#{sql_content_check}"] * tokens.size).join(" AND "), 
                         *tokens.collect { |token| [token] * 2 }.flatten])
      @query_result = pages.delete_if { |p| !p.published? }
    end
    lazy_initialize_parser_and_context
    if layout
      parse_object(layout)
    else
      render_page_part(:body)
    end
  end
  
  def helper
    @helper ||= ActionView::Base.new
  end
  
end

class Page
  #### Tags ####
  desc %{    The namespace for all search tags.}
  tag 'search' do |tag|
    tag.expand
  end

  desc %{    <r:search:form [label=""] [boxClass="CSS class name"] [buttonClass="CSS class name"] [url="search"] [submit="Search"] />
    Renders a search form, with the optional label, submit text and url.
    Optionally allows setting the CSS class of the button and text inputs
    for formatting.}
  tag 'search:form' do |tag|
    label = tag.attr['label'].nil? ? "" : "<label for=\"q\">#{tag.attr['label']}</label> "
    buttonClass = tag.attr['buttonClass'].nil? ? "" : " class=\"#{tag.attr['buttonClass']}\""
    boxClass = tag.attr['boxClass'].nil? ? "" : " class=\"#{tag.attr['boxClass']}\""
    submit = "<input#{buttonClass} value=\"#{tag.attr['submit'] || "Search"}\" type=\"submit\" />"
    url = tag.attr['url'].nil? ? self.url.chop : tag.attr['url']
    @query ||= ""    
    content = %{<form action="#{url}" method="get" id="search_form"><p>#{label}<input#{boxClass} type="text" id="q" name="q" value="#{@query}" size="15" alt=\"search\"/> #{submit}</p></form>}
    content << "\n"
  end

end
