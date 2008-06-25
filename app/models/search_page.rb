class SearchPage < Page
  description "Provides tags and behavior to support searching Radiant.  Based on Oliver Baltzer's search_behavior."
  attr_accessor :query_result, :query
  #### Tags ####
  desc %{    The namespace for all search tags.}
  tag 'search' do |tag|
    tag.expand
  end

  desc %{    <r:search:form [label="Search:"] />
    Renders a search form, with the optional label.}
  tag 'search:form' do |tag|
    label = tag.attr['label'].nil? ? "Search:" : tag.attr['label']
    content = %{<form action="#{self.url.chop}" method="get" id="search_form"><p><label for="q">#{label}</label> <input type="text" id="q" name="q" value="" size="15" /></p></form>}
    content << "\n"
  end
   
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
  
  desc %{    <r:truncate_and_strip [length="100"] />
    Truncates and strips all HTML tags from the content of the contained block.  
    Useful for displaying a snippet of a found page.  The optional `length' attribute
    specifies how many characters to truncate to.}
  tag 'truncate_and_strip' do |tag|
    tag.attr['length'] ||= 100
    length = tag.attr['length'].to_i
    helper = ActionView::Base.new
    helper.truncate(helper.strip_tags(tag.expand).gsub(/\s+/," "), length)
  end
  
  #### "Behavior" methods ####
  def cache?
    false
  end
  
  def render
    @query_result = []
    @query = ""
    q = @request.parameters[:q]
    unless (@query = q.to_s.strip).blank?
      tokens = query.split.collect { |c| "%#{c.downcase}%"}
      pages = Page.find(:all, :include => [ :parts ],
          :conditions => [(["((LOWER(content) LIKE ?) OR (LOWER(title) LIKE ?))"] * tokens.size).join(" AND "), 
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
  
end