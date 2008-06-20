require File.dirname(__FILE__) + '/../test_helper'

class SearchExtensionTest < Test::Unit::TestCase
  fixtures :pages
  
  def setup
    @controller = SiteController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
  end  
  
  def test_initialization
    assert_equal RADIANT_ROOT + '/vendor/extensions/search', SearchExtension.root
    assert_equal 'Search', SearchExtension.extension_name
  end
  
end
