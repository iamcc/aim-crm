controller = angular.module('app.controllers', []).controller

# userCtrl
controller 'userCtrl', [
  '$scope', '$timeout'
  ($scope, $timeout)->
    $scope.showCount = (item)->
      $scope.isShowFilter = false

      if item is $scope.curCountItem
        $scope.isShowCount = false
        $scope.curCountItem = null
      else
        $scope.isShowCount = true
        $scope.curCountItem = item

    $scope.showFilter = ->
      $scope.isShowCount = false
      $scope.curCountItem = null
      $scope.isShowFilter = not $scope.isShowFilter

    $scope.prePages = ->
      data = $scope.projectData
      if data.minPage > 1
        data.minPage -= data.pageNum
        data.maxPage = data.minPage + data.pageNum - 1
        data.pageArr = [data.minPage..data.maxPage]

    $scope.nextPages = ->
      data = $scope.projectData
      if data.maxPage < data.totalPage
        data.minPage += data.pageNum
        data.maxPage = data.minPage + data.pageNum - 1
        if data.maxPage > data.totalPage then data.maxPage = data.totalPage
        data.pageArr = [data.minPage..data.maxPage]

    $scope.goPage = (page)->
      $scope.projectData.curPage = page

    $scope.editField = (event, project)->
      if $(event.target).parent().hasClass 'edit' then return
      $scope.oldProject = angular.copy project
      $(event.target).find('.view, .edit').toggleClass 'hide'
      $(event.target).find('.edit').children().first().focus()
      return

    $scope.save = (event, project, field)->
      if $scope.oldProject[field] is project[field] then console.log 'unsave'
      else console.log 'save'

      $(event.target).parent().parent().find('.view, .edit').toggleClass 'hide'
      console.log project[field]


    $timeout ->
      data = $scope.projectData = {}
      data.minPage = 1
      data.pageNum = 5
      data.maxPage = data.minPage + data.pageNum - 1
      data.curPage = 1
      data.totalPage = 11
      data.pageArr = [data.minPage..data.maxPage]
      data.list = [
        {
          projectName: '1'
          projectType: '1'
          companyName: '1'
          salesName: '1'
          industry: '1'
          curStatus: '1'
          supporterName: '1'
          tags: '1'
          agent: '1'
          price: '1'
          areaName: '1'
          managerName: '1'
          buyYear: '1'
          client: '1'
          orderDate: '1'
          maeAccount: '1'
          maePwd: '1'
          maeCreatorName: '1'
          wxAccount: '1'
          wxPwd: '1'
          wxType: '1'
          ecId: '1'
          sendEcBoxDate: '1'
          onlineDate: '1'
          onlineReviewer: '1'
          memo: '1'
        }
      ]
    , 3000
]
# userCtrl end