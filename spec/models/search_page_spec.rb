require File.dirname(__FILE__) + '/../spec_helper'

describe SearchPage do
  dataset :searched_pages
  describe "<r:truncate_and_strip>" do
    it "should truncate the contents to the given length" do
      pages(:search).should render('<r:truncate_and_strip length="10">abcde fghij klmno</r:truncate_and_strip>').as('abcde f...')
    end
  end
  
  describe "<r:search:form />" do
    it "should add exclude_pages parameter in hidden input" do
      pages(:search).should render('<r:search:form exclude_pages="/page/" />').matching(%r{<input type="hidden" name="exclude_pages" value="/page/"})
    end
  end

  describe "render" do
    before :each do
      @page = SearchPage.new
      @page.request = ActionController::TestRequest.new
      @page.response = ActionController::TestResponse.new
    end

    it "should return pages containing search term" do
      @page.request.query_parameters = {:q => 'documentation'}
      @page.render
      @page.query_result.should include pages(:documentation)
    end
    it "should not return pages not containing search term" do
      @page.request.query_parameters = {:q => "documentation"}
      @page.render
      @page.query_result.should_not include pages(:ruby_home_page)
    end
    it "should not include pages with URL specified in exclude_page" do
      exclude_page = pages(:documentation)
      @page.request.query_parameters = {
        :q => "documentation",
        :exclude_pages => exclude_page.url
      }
      Rails::logger.info "Query_parameters set to #{@page.request.query_parameters}"
      
      @page.render
      @page.query_result.should_not include pages(:documentation)
    end

    it "accepts multiple pages in exclude_page separated by comma" do
      exclude_pages = "#{pages(:documentation).url},#{pages(:ruby_home_page).url}"
      @page.request.query_parameters = {
        :q => ".",
        :exclude_pages => exclude_pages
      }
      Rails::logger.info "Query_parameters set to #{@page.request.query_parameters}"

      @page.render
      @page.query_result.should_not include pages(:documentation)
      @page.query_result.should_not include pages(:ruby_home_page)
    end
  end
end
