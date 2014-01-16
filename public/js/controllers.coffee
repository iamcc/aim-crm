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

    $scope.showEdit = (event, project)->
      if $(event.target).parent().hasClass 'edit' then return
      $scope.oldProject = angular.copy project
      # $('.edit').hide()
      $(event.target).find('.view').hide()
      $(event.target).find('.edit').show()
      $(event.target).find('.edit').children().first().focus()
      return

    $scope.save = (event, project, field)->
      $(event.target).parent().parent().find('.view').show()
      $(event.target).parent().parent().find('.edit').hide()
      param = {}
      param[field] = project[field]
      if $scope.oldProject[field] isnt project[field] then console.log 'save', param


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
    , 1000
]
# userCtrl end

# loginCtrl
controller 'loginCtrl', [
  '$scope', '$http', '$rootScope', '$location', 'User'
  ($scope, $http, $rootScope, $location, User)->
    $scope.login = (e, form)->
      return if form.$invalid
      $scope.isError = false
      $btn = $ e.target
      $btn.button 'loading'

      User.login {uname: $scope.uname, pwd: $scope.pwd},
        (data)->
          $rootScope.userinfo = data
          $location.path '/'
        (err)->
          $btn.button 'reset'
          $scope.isError = true
]
# loginCtrl end

# settingCtrl
controller 'settingCtrl', [
  '$scope', 'User'
  ($scope, User)->
    $tabs = $scope.tabs = []
    $userinfo = $scope.userinfo

    # 修改密码
    $tabs[0] =
      save: (e, form)->
        return if form.$invalid
        return @error = '两次密码不一样' if @pwd isnt @pwd2
        @error = ''
        self = @
        $btn = $ e.target
        $btn.button 'loading'

        User.setPwd {_id: $userinfo._id, pwd: @pwd},
          (data)->
            self.success = '修改成功'
            $btn.button 'reset'
          (err)->
            self.error = '修改失败'
            $btn.button 'reset'
            console.log err

    $scope.selectMenu = (id)->
      $scope.selectedMenu = id
      switch id
        when 0
          console.log 
        when 1
          console.log 
        when 2
          console.log 
        when 3
          console.log 
        when 4
          console.log 
        when 5
          console.log 
        when 6
          console.log 
]
# settingCtrl end