// Generated by CoffeeScript 1.6.3
(function() {
  angular.module('app.directives', []).directive('typeahead', function() {
    return {
      restrict: 'E',
      transclude: 'element',
      replace: true,
      scope: {
        name: '@',
        valueKey: '@',
        remote: '@',
        model: '=',
        datum: '='
      },
      template: '<input type="text" ng-model="model">',
      link: function(scope, elem, attrs) {
        var $el;
        $el = $(elem);
        $el.typeahead({
          name: scope.name,
          valueKey: scope.valueKey,
          remote: scope.remote
        });
        return $el.on('typeahead:selected', function(obj, datum) {
          return scope.$apply(function() {
            return scope.datum = datum;
          });
        });
      }
    };
  });

}).call(this);