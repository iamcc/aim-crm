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
          model: '=model'
          datum: '='
          callback: '&'
        template: '<input type="text" class="form-control" ng-model="model">'
        link: (scope, elem, attrs)->
          $el = $(elem)

          source = new Bloodhound {
            datumTokenizer: (d) -> return Bloodhound.tokenizers.whitespace(d.value)
            queryTokenizer: Bloodhound.tokenizers.whitespace
            remote: scope.remote
          }
          source.initialize()

          $el.typeahead null, {
            displayKey: scope.valueKey
            source: source.ttAdapter()
          }
          $el.on 'typeahead:selected', (obj, datum)->
            scope.$apply ->
              scope.datum = datum
              if scope.callback and scope.callback()
                scope.callback().bind(scope.$parent) datum
      }
  )
  .directive(
    'page'
    ($rootScope) ->
      {
        restrict: 'E'
        transclude: 'element'
        replace: true
        scope:
          data: '='
          model: '='
          goPage: '&'
        templateUrl: '/partials/page.html'
        link: (scope, elem, attrs) ->
          initPage = (data)->
            return unless data
            return if data.totalPage is 0
            data.curPage = 1
            data.minPage = 1
            data.pageNum = 5
            data.maxPage = data.minPage + data.pageNum - 1
            data.maxPage = data.totalPage if data.maxPage > data.totalPage
            data.maxPage = data.minPage if data.maxPage < data.minPage
            data.pageArr = [data.minPage..data.maxPage]

          scope.prePages = ->
            data = scope.data
            return unless data
            if data.minPage > 1
              data.minPage -= data.pageNum
              data.maxPage = data.minPage + data.pageNum - 1
              data.pageArr = [data.minPage..data.maxPage]

          scope.nextPages = ->
            data = scope.data
            return unless data
            if data.maxPage < data.totalPage
              data.minPage += data.pageNum
              data.maxPage = data.minPage + data.pageNum - 1
              if data.maxPage > data.totalPage then data.maxPage = data.totalPage
              data.pageArr = [data.minPage..data.maxPage]

          if not scope.goPage()
            scope.goPage = (p) ->
              scope.model.get {page: p}, (data) ->
                scope.data.curPage = p
                scope.data.list = data.list

          $rootScope.$on 'page:init', ->
            scope.$apply -> initPage scope.data
      }
  )