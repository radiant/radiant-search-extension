class SearchedPagesDataset < Dataset::Base
  uses :home_page
  
  def load
    create_page "Ruby Home Page" do
      create_page_part :ruby_home_page_body, :content => 'This is the body portion of the Ruby home page.'
      create_page_part :ruby_home_page_extended, :content => 'This is an extended portion of the Ruby home page.'
      create_page_part :ruby_home_page_summary, :content => 'This is a summary.'
      create_page_part :ruby_home_page_sidebar, :content => '<r:title /> sidebar.'
    end
    create_page "Documentation", :body => 'This is the documentation section.'
    create_page "Search", :body => "This is the search section.", :class_name => 'SearchPage'
  end
end
