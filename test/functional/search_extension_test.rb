require File.dirname(__FILE__) + '/../test_helper'

class SearchExtensionTest < Test::Unit::TestCase
  fixtures :pages
  
  def setup
    @controller = SiteController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
  end  
  
  def test_initialization
    assert_equal RAILS_ROOT + '/vendor/extensions/search', SearchExtension.root
    assert_equal 'Search', SearchExtension.extension_name
  end
  
end

class SearchTagsTest < Test::Unit::TestCase
  test_helper :pages, :render
  fixtures :pages
    
  def test_search_works_for_regular_page
    @page = pages(:documentation)
    form = "<form action=\"/documentation\" method=\"get\" id=\"search_form\"><p><input type=\"text\" id=\"q\" name=\"q\" value=\"\" size=\"15\" /> <input value=\"Search\" type=\"submit\" /></p></form>\n"
    assert_renders form,'<r:search:form />'
  end
  
  def test_search_with_url
    @page = pages(:search) 
    form = "<form action=\"/other_url\" method=\"get\" id=\"search_form\"><p><input type=\"text\" id=\"q\" name=\"q\" value=\"\" size=\"15\" /> <input value=\"Search\" type=\"submit\" /></p></form>\n"
    assert_renders form, '<r:search:form url="/other_url" />'
  end
  
  def test_search_with_label
    @page = pages(:search)
    form = "<form action=\"/search\" method=\"get\" id=\"search_form\"><p><label for=\"q\">Search:</label> <input type=\"text\" id=\"q\" name=\"q\" value=\"\" size=\"15\" /> <input value=\"Search\" type=\"submit\" /></p></form>\n"
    assert_renders form, '<r:search:form label="Search:" />'
  end  
  
end

