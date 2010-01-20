require File.dirname(__FILE__) + '/../spec_helper'

describe SearchPage do
  dataset :searched_pages
  describe "<r:truncate_and_strip>" do
    it "should truncate the contents to the given length" do
      pages(:search).should render('<r:truncate_and_strip length="10">abcde fghij klmno</r:truncate_and_strip>').as('abcde f...')
    end
  end
end
