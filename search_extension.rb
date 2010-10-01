class SearchExtension < Radiant::Extension
  version "0.1"
  description %{Provides a page type that allows you to search for pages in 
                Radiant.  Based on Oliver Baltzer's search_behavior.}
  url "http://github.com/radiant/radiant-search-extension"
 
  def activate
    SearchPage
  end
  
  def deactivate
  end
    
end
