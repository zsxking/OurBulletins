$(document).ready ->
  # let the form be 'indextank-aware'
  $("#search_form").indextank_Ize(publicApiUrl, indexName)
  # let the query box have autocomplete
  $("#search_q").indextank_Autocomplete({fieldName: "title"})
  return