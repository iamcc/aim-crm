angular
  .module('app.filters', ['ngSanitize'])
  .filter(
    'wrap', 
    [
      ->
        (text)->
          String(text).replace /\n/ig, '<br>'
    ]
  )