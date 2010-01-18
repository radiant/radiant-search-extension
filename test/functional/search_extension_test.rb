require File.dirname(__FILE__) + '/../test_helper'

class SearchExtensionTest < ActiveSupport::TestCase
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

class SearchTagsTest < ActiveSupport::TestCase
  test_helper :pages, :render
  fixtures :pages
    
  def test_search_form_works_for_regular_page
    @page = pages(:documentation)
    form = "<form action=\"/documentation\" method=\"get\" id=\"search_form\"><p><input type=\"text\" id=\"q\" name=\"q\" value=\"\" size=\"15\" alt=\"search\"/> <input value=\"Search\" type=\"submit\" /></p></form>\n"
    assert_renders form,'<r:search:form />'
  end
  
  def test_search_form_with_query
    @page = pages(:search)
    @page.query = 'test'
    form = "<form action=\"/search\" method=\"get\" id=\"search_form\"><p><input type=\"text\" id=\"q\" name=\"q\" value=\"test\" size=\"15\" alt=\"search\"/> <input value=\"Search\" type=\"submit\" /></p></form>\n"
    assert_renders form, '<r:search:form />'
  end  
  
  def test_search_form_with_url
    @page = pages(:search)
    form = "<form action=\"/other_url\" method=\"get\" id=\"search_form\"><p><input type=\"text\" id=\"q\" name=\"q\" value=\"\" size=\"15\" alt=\"search\"/> <input value=\"Search\" type=\"submit\" /></p></form>\n"
    assert_renders form, '<r:search:form url="/other_url" />'
  end
  
  def test_search_form_with_label
    @page = pages(:search)
    form = "<form action=\"/search\" method=\"get\" id=\"search_form\"><p><label for=\"q\">Search:</label> <input type=\"text\" id=\"q\" name=\"q\" value=\"\" size=\"15\" alt=\"search\"/> <input value=\"Search\" type=\"submit\" /></p></form>\n"
    assert_renders form, '<r:search:form label="Search:" />'
  end  
  
  def test_search_form_with_submit
    @page = pages(:search)
    form = "<form action=\"/search\" method=\"get\" id=\"search_form\"><p><input type=\"text\" id=\"q\" name=\"q\" value=\"\" size=\"15\" alt=\"search\"/> <input value=\"Go!\" type=\"submit\" /></p></form>\n"
    assert_renders form, '<r:search:form submit="Go!" />'
  end  
  
  def test_truncate_and_strip
    @page = pages(:search)
    assert_renders 'abcde f...', '<r:truncate_and_strip length="10">abcde fghij klmno</r:truncate_and_strip>'
  end  
  
  def test_highlight
    @page = pages(:search)
    @page.query = 'abc'
    assert_renders '<strong class="highlight">abc</strong>de fghij klmno', '<r:search:highlight>abcde fghij klmno</r:search:highlight>'
  end
  
  def test_highlight_only_highlights_first_word
    @page = pages(:search)
    @page.query = 'cde fgh'
    assert_renders 'ab<strong class="highlight">cde</strong> <strong class="highlight">fgh</strong>ij klmno', '<r:search:highlight>abcde fghij klmno</r:search:highlight>'
  end
  
  def test_highlight_renders_truncated_content_if_content_does_not_match_query
    @page = pages(:search)
    @page.query = 'X'
    assert_renders 'abcde f...', '<r:search:highlight length="10">abcde fghij klmno</r:search:highlight>'
  end
  
  def test_highlight_with_uneven_length
    @page = pages(:search)
    @page.query = 'X'
    assert_renders 'abcde ...', '<r:search:highlight length="9">abcde fghij klmno</r:search:highlight>'
  end
  
  def test_highlight_with_small_length
    @page = pages(:search)
    @page.query = 'abc'
    assert_renders '<strong class="highlight">abc</strong>de fgh...', '<r:search:highlight length="9">abcde fghij klmno</r:search:highlight>'
  end    
end

