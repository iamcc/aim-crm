angular.module('app.directives', [])
  .directive(
    'typeahead'
    ->
      {
        restrict: 'E'
        transclude: 'element'
        replace: true
        scope:
          name: '@'
          valueKey: '@'
          remote: '@'
          model: '='
          datum: '='
        template: '<input type="text" ng-model="model">'
        link: (scope, elem, attrs)->
          $el = $(elem)
          $el.typeahead
            name: scope.name
            valueKey: scope.valueKey
            remote: scope.remote
          $el.on 'typeahead:selected', (obj, datum)->
            scope.$apply -> scope.datum = datum
      }
  )