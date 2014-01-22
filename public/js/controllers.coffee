controller = angular.module('app.controllers', []).controller

initPage = (data)->
  return unless data
  data.curPage = 1
  data.minPage = 1
  data.pageNum = 5
  data.maxPage = data.minPage + data.pageNum - 1
  data.maxPage = data.totalPage if data.maxPage > data.totalPage
  data.maxPage = data.minPage if data.maxPage < data.minPage
  data.pageArr = [data.minPage..data.maxPage]
prePages = (data)->
  return unless data
  if data.minPage > 1
    data.minPage -= data.pageNum
    data.maxPage = data.minPage + data.pageNum - 1
    data.pageArr = [data.minPage..data.maxPage]
nextPages = (data)->
  return unless data
  if data.maxPage < data.totalPage
    data.minPage += data.pageNum
    data.maxPage = data.minPage + data.pageNum - 1
    if data.maxPage > data.totalPage then data.maxPage = data.totalPage
    data.pageArr = [data.minPage..data.maxPage]

# userCtrl
controller 'userCtrl', [
  '$scope', 'Project', 'ProjectType', 'Industry', 'Agent', 'User', 'Area', 'Sales'
  ($scope, Project, ProjectType, Industry, Agent, User, Area, Sales)->
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

    $scope.prePages = -> prePages @projectData
    $scope.nextPages = -> nextPages @projectData
    $scope.goPage = (page)->
      self = @
      if page then Project.get {page: page}, (data)-> self.projectData.list = data.list
      else self.projectData = Project.get {}, (data)-> initPage data

    $scope.showEdit = (event, project)->
      if $(event.target).parent().hasClass 'edit' then return
      $scope.oldProject = angular.copy project
      $(event.target).find('.view').hide()
      $(event.target).find('.edit').show()
      $(event.target).find('.edit').children().first().focus()
      return

    $scope.saveProject = ->
      p = JSON.parse angular.toJson @newProject
      p.company = p.sales.company
      Project.save p,
        ->
          $('#addModal').modal 'hide'
          $scope.newProject = null
          $scope.goPage()
        (err)->
          alert err.data

    $scope.update = (event, project, field)->
      $(event.target).closest('.edit').prev().show()
      $(event.target).closest('.edit').hide()
      param = {_id: project._id}
      param[field] = project[field]
      if $scope.oldProject[field] isnt project[field]
        # console.log 'update', param, project
        Project.update param

    $scope.goPage()
    $scope.projectTypes = ProjectType.query()
    $scope.industries = Industry.query()
    $scope.agents = Agent.query({_id: 'all'})
    $scope.supporters = User.getSupporters()
    $scope.areas = Area.all()

    $scope.$watch 'newProject.area', ->
      if $scope.newProject
        $scope.companies = Area.all parent: $scope.newProject.area._id
        $scope.saleses = null
    $scope.$watch 'newProject.company', ->
      if $scope.newProject then $scope.saleses = Sales.query company: $scope.newProject.company._id
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
  '$scope', 'User', 'Area', 'Sales', 'Industry', 'Agent', 'ProjectType', '$routeParams', '$location', '$route'
  ($scope, User, Area, Sales, Industry, Agent, ProjectType, $routeParams, $location, $route)->
    User.checkLogin()
    $tabs = $scope.tabs = []
    $userinfo = $scope.userinfo
    lastRoute = $route.current
    $scope.$on '$locationChangeSuccess', -> $route.current = lastRoute if $route.current.$$route.controller is 'settingCtrl'

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
            self.error = ''
            $btn.button 'reset'
          (err)->
            self.success = ''
            self.error = '修改失败'
            $btn.button 'reset'
            console.log err

    # 修改用户
    $tabs[1] =
      selectUser: ->
        _id = @user._id
        @user = angular.copy @allUsers.list.filter((u)-> u._id is _id)[0]
      updateRealname: (e)->
        self = @
        $btn = $ e.target
        $btn.button 'loading'

        User.setRealname @user,
          ->
            self.success = '操作成功'
            self.error = ''
            self.allUsers.list.filter((u)-> u._id is self.user._id)[0].realname = self.user.realname
            $btn.button 'reset'
          (err)->
            self.success = ''
            self.error = '操作失败'
            console.log err
            $btn.button 'reset'
      updateRole: (e)->
        self = @
        $btn = $ e.target
        $btn.button 'loading'

        User.setRole @user,
          ->
            self.success = '操作成功'
            self.error = ''
            self.allUsers.list.filter((u)-> u._id is self.user._id)[0].role = self.user.role
            $btn.button 'reset'
          (err)->
            self.success = ''
            self.error = '操作失败'
            console.log err
            $btn.button 'reset'
      resetPwd: (e)->
        self = @
        $btn = $ e.target

        if confirm('密码将被重置为123456')
          $btn.button 'loading'
          User.resetPwd @user,
            ->
              self.success = '操作成功'
              self.error = ''
              $btn.button 'reset'
            (err)->
              self.success = ''
              self.error = '操作失败'
              console.log err
              $btn.button 'reset'

    # 添加用户
    $tabs[2] =
      save: (e, form)->
        return if form.$invalid
        self = @
        $btn = $ e.target

        $btn.button 'loading'

        User.save @newUser,
          (data)->
            self.success = '添加成功'
            self.error = ''
            $btn.button 'reset'
          (err)->
            self.success = ''
            self.error = err.data
            $btn.button 'reset'

    # 销售管理
    $tabs[3] =
      changeArea: ->
        @selectedSales.company = null
        @salesData = null
        Area.get {parent: @selectedSales.area._id, num: 100}, (data)->
          $tabs[3].selectedSales.companies = data.list
      changeCompany: ->
        @salesData = Sales.query {company: @selectedSales.company._id}
        @selectedSales.company = @selectedSales.companies.filter((obj)-> obj._id is $tabs[3].selectedSales.company._id)[0]
      addSales: ->
        @selectedSales =
          area: angular.copy (@selectedSales and @selectedSales.area)
          company: angular.copy (@selectedSales and @selectedSales.company)
          companies: angular.copy (@selectedSales and @selectedSales.companies)
      selectSales: (sales)->
        sales.companies = @selectedSales.companies
        sales.company.managers = @selectedSales.company.managers
        sales.area = @selectedSales.area
        @selectedSales = angular.copy sales
      save: (form)->
        return if form.$invalid

        Sales.save @selectedSales,
          ->
            $('#salesModal').modal 'hide'
            $tabs[3].salesData = Sales.query {company: $tabs[3].selectedSales.company._id}
          (err)->
            console.log err
            alert 'Error'

    # 区域管理
    $tabs[4] =
      selectArea: (area)->
        @selectedArea = angular.copy area
        @companyData = Area.get parent: area._id, (data)-> initPage data
      addArea: (parent)->
        @selectedArea =
          parent: parent
          managers: []
      editArea: (area)->
        @selectedArea = angular.copy area
      addManager: ->
        return unless @newManager and @newManager._id
        @selectedArea.managers.push angular.copy(@newManager)
        @newManager = null
      prePages: prePages
      nextPages: nextPages
      goAreaPage: (data, page)->
        data.curPage = page
        Area.get {page: page}, (docs)->
          data.list = docs.list
      goCompanyPage: (data, page)->
        data.curPage = page
        Area.get {parent: @selectedArea._id, page: page}, (docs)->
          data.list = docs.list
      save: ->
        self = @
        Area.save @selectedArea,
          ->
            if self.selectedArea.parent then self.companyData = Area.get parent: self.selectedArea.parent, (data)-> initPage data
            else self.areaData = Area.get {}, (data)-> initPage data
            $('#areaModal').modal 'hide'
            self.selectedArea = null
          (err)->
            console.log err
            alert '错误'

    # 行业管理
    $tabs[5] =
      del: (i)->
        $tabs[5].error = ''
        if confirm '确定删除？'
          Industry.delete i,
            ->
              $tabs[5].industries = Industry.query()
            (err)->
              $tabs[5].error = err.data
      save: (form)->
        $tabs[5].error = ''
        return if form.$invalid
        Industry.save @newIndustry,
          ->
            $tabs[5].industries = Industry.query()
            $tabs[5].newIndustry = null
          (err)->
            $tabs[5].error = err.data

    $tabs[6] =
      prePages: prePages
      nextPages: nextPages
      goPage: (page)->
        if page then Agent.get {page: page}, (data)-> $tabs[6].agentData.list = data.list
        else @agentData = Agent.get {}, (data)-> initPage data
      add: ->
        @newAgent = null
      edit: (agent)->
        @newAgent = angular.copy agent
      save: (form)->
        return if form.$invalid
        Agent.save @newAgent,
          ->
            $('#agentModal').modal 'hide'
            $tabs[6].newAgent = null
            $tabs[6].goPage()
          (err)->
            alert err.data

    $tabs[7] =
      load: ->
        @projectTypes = ProjectType.query()
      del: (p)->
        if confirm '确定删除？'
          $tabs[7].error = ''
          ProjectType.delete p,
            ->
              $tabs[7].newType = null
              $tabs[7].load()
            (err)->
              $tabs[7].error = err.data
      save: (form)->
        return if form.$invalid
        $tabs[7].error = ''
        ProjectType.save @newType,
          ->
            $tabs[7].newType = null
            $tabs[7].load()
          (err)->
            $tabs[7].error = err.data

    $scope.selectMenu = (id)->
      $location.path '/setting/'+id
      $scope.selectedMenu = id

      switch id
        when 0
          console.log 
        when 1 #修改用户
          $tabs[1].allUsers = User.get num: 100
        when 2
          console.log 
        when 3 #销售管理
          $tabs[3].areaData = Area.get {num: 100}, (data)-> initPage data
        when 4 #区域管理
          $tabs[4].areaData = Area.get {}, (data)-> initPage data
          Area.get {num: 100}, (data)-> $tabs[4].allAreas = data.list
        when 5
          $tabs[5].industries = Industry.query()
        when 6
          $tabs[6].goPage()
        when 7
          $tabs[7].load()
    
    $scope.selectMenu parseInt($routeParams.tab) or 0
]
# settingCtrl end