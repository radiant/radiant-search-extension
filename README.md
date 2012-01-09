# Radiant Search Extension

[![Build Status](https://secure.travis-ci.org/radiant/radiant-search-extension.png)](http://travis-ci.org/radiant/radiant-search-extension)

Version: 1.0
Description: A simple search extension for Radiant CMS

## Installation

Add `gem "radiant-search-extension", "~> 1.0"` to your Gemfile and run `bundle install`

## Example

```
<r:search:form submit="Search"/>

<r:search:initial>
  <strong>Enter a phrase above to search this website.</strong>
</r:search:initial>

<r:search:empty>
  <strong>I couldn't find anything named "<r:search:query/>".</strong>
</r:search:empty>

<r:search:results>
  Found the following pages that contain "<r:search:query/>".
  <ul>
    <r:search:results:each>
    <li>
      <r:link/><br/>
      <r:search:highlight><r:content/></r:search:highlight>
    </li>
    </r:search:results:each>
  </ul>
</r:search:results>
```
