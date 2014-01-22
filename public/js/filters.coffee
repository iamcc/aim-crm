angular
  .module('app.filters', ['ngSanitize'])
  .filter(
    'wrap', 
    [
      ->
        (text)->
          return '' unless text
          String(text).replace /\n/ig, '<br>'
    ]
  )