controller = angular.module('app.controllers', []).controller

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
  '$scope', 'Project', 'ProjectType', 'Industry', 'Agent', 'User', 'Area', 'Sales', '$routeParams', '$location'
  ($scope, Project, ProjectType, Industry, Agent, User, Area, Sales, $routeParams, $location)->
    getStatusLabel = (status)->
      switch status
        when '初始资料', '首次催单', '二次催单' then 'label-info'
        when '搁置', '毁约' then 'label-danger'
        when '录入' then 'label-warning'
        when '完成' then 'label-primary'
        when '上线' then 'label-success'
        else 'label-default'

    $scope.showCount = (item)->
      $scope.isShowFilter = false

      if item is $scope.curCountItem
        $scope.isShowCount = false
        $scope.curCountItem = null
      else
        $scope.isShowCount = true
        $scope.curCountItem = item
        switch item
          when 'area' then $scope.counts = $scope.areas
          when 'company' then $scope.counts = $scope.companies
          when 'industry' then $scope.counts = $scope.industries
          when 'type' then $scope.counts = $scope.projectTypes

    $scope.goUrl = (url)->
      $location.path url

    $scope.showFilter = ->
      $scope.isShowCount = false
      $scope.curCountItem = null
      $scope.isShowFilter = not $scope.isShowFilter

    $scope.condition = {}

    $scope.prePages = -> prePages @projectData

    $scope.nextPages = -> nextPages @projectData

    $scope.goPage = (page)->
      self = @
      for k, v of $scope.condition
        delete $scope.condition[k] unless v
      param = {condition: $scope.condition or {}}
      if $routeParams.area then param.condition['area._id'] = $routeParams.area
      if $routeParams.company then param.condition['company._id'] = $routeParams.company
      if $routeParams.industry then param.condition['industry._id'] = $routeParams.industry
      if $routeParams.type then param.condition['type._id'] = $routeParams.type
      if page
        param.page = page
        Project.get param, (data)->
          self.projectData.curPage = page
          self.projectData.list = data.list
          for p in data.list
            p.statusLabel = getStatusLabel p.status
      else self.projectData = Project.get param, (data)->
        initPage data
        for p in data.list
          p.statusLabel = getStatusLabel p.status

    $scope.showEdit = (event, project)->
      return if $scope.userinfo.role is 'finance'

      if $(event.target).parent().hasClass 'edit' then return
      $scope.oldProject = angular.copy project
      $(event.target).find('.view').hide()
      $(event.target).find('.edit').show()
      $(event.target).find('.edit').children().focus()
      return

    $scope.addComment = (project)->
      $scope.comments = project.comments
      $scope.newComment =
        _id: project._id, status: project.status, comment: 1

    $scope.saveComment = (form)->
      return if form.$invalid or not $scope.newComment.content.trim()
      Project.update $scope.newComment, (data)->
        $scope.comments.push data
        $scope.newComment.content = ''

    $scope.saveProject = ->
      p = JSON.parse angular.toJson @newProject
      return alert '请选择销售' if not p.sales or not p.sales._id
      return alert '请填写客户全称' if not p.client or not p.client._id

      p.company = p.sales.company
      p.area = $scope.areas.filter((a)->
        a._id is p.company.parent)[0]
      Project.save p,
      ->
        $('#addModal').modal 'hide'
        $scope.newProject = null
        $scope.goPage()
      , (err)->
        alert err.data

    $scope.updateStatus = (p, status)->
      Project.update {_id: p._id, status: status}, ->
        p.comments.push {
          content: status
          creator: $scope.userinfo.realname
          date: new Date()
          status: p.status
        }
        p.status = status
        p.statusLabel = getStatusLabel status
        if status is '上线'
          p.online =
            date: new Date()
            reviewer: $scope.userinfo

    $scope.update = (event, project, field)->
      $(event.target).closest('.edit').prev().show()
      $(event.target).closest('.edit').hide()
      param = {_id: project._id}
      param[field] = project[field]
      if project[field] and project[field].hasOwnProperty('_id')
        if not $scope.oldProject[field] or $scope.oldProject[field]._id isnt project[field]._id
          if field is 'sales'
            param.company = project[field].company
            param.area = $scope.areas.filter((a)->
              a._id is param.company.parent)[0]
          Project.update param
      else if $scope.oldProject[field] isnt project[field]
        Project.update param

    $scope.export = ->
      self = @
      for k, v of $scope.condition
        delete $scope.condition[k] unless v
      param = {condition: $scope.condition or {}}
      if $routeParams.area then param.condition['area._id'] = $routeParams.area
      if $routeParams.company then param.condition['company._id'] = $routeParams.company
      if $routeParams.industry then param.condition['industry._id'] = $routeParams.industry
      if $routeParams.type then param.condition['type._id'] = $routeParams.type

      window.open '/api/export?condition=' + JSON.stringify(param.condition)
      return

    $scope.goPage()

#    if $scope.userinfo.role in ['supporter', 'leader', 'admin']
#      $scope.projectTypes = ProjectType.query({}, -> t.url = '/type/' + t._id for t in $scope.projectTypes)
#      $scope.industries = Industry.query({}, -> i.url = '/industry/' + i._id for i in $scope.industries)
#      $scope.agents = Agent.query({_id: 'all'})
#      $scope.supporters = User.getSupporters() if $scope.userinfo.role isnt 'supporter'
#      $scope.areas = Area.all({}, -> a.url = '/area/' + a._id for a in $scope.areas)
#      $scope.companies = Area.allCompanies({}, -> c.url = '/company/' + c._id for c in $scope.companies)
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
      , (err)->
        $btn.button 'reset'
        $scope.isError = true
]
# loginCtrl end

# settingCtrl
controller 'settingCtrl', [
  '$rootScope', '$scope', 'User', 'Area', 'Sales', 'Industry', 'Agent', 'ProjectType', 'Client', '$routeParams', '$location', '$route'
  ($rootScope, $scope, User, Area, Sales, Industry, Agent, ProjectType, Client, $routeParams, $location, $route)->
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
        , (err)->
          self.success = ''
          self.error = '修改失败'
          $btn.button 'reset'
          console.log err

    # 修改用户
    $tabs[1] =
      selectUser: ->
        _id = @user._id
        @user = angular.copy @allUsers.list.filter((u)->
          u._id is _id)[0]

      updateRealname: (e)->
        self = @
        $btn = $ e.target
        $btn.button 'loading'

        User.setRealname @user,
        ->
          self.success = '操作成功'
          self.error = ''
          self.allUsers.list.filter((u)->
            u._id is self.user._id)[0].realname = self.user.realname
          $btn.button 'reset'
        , (err)->
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
          self.allUsers.list.filter((u)->
            u._id is self.user._id)[0].role = self.user.role
          $btn.button 'reset'
        , (err)->
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
          , (err)->
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
        , (err)->
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
        @selectedSales.company = angular.copy @selectedSales.companies.filter((obj)->
          obj._id is $tabs[3].selectedSales.company._id)[0]

      changeManager: ->
        self = @
        @selectedSales.company.manager = angular.copy @selectedSales.company.managers.filter((m)->
          m._id is self.selectedSales.company.manager._id)[0]

      addSales: ->
        @selectedSales =
          area: angular.copy (@selectedSales and @selectedSales.area)
          company: angular.copy (@selectedSales and @selectedSales.company)
          companies: angular.copy (@selectedSales and @selectedSales.companies)

      selectSales: (sales)->
        sales.area = @selectedSales.area
        sales.companies = @selectedSales.companies
        mid = sales.company.manager and sales.company.manager._id
        sales.company = sales.companies.filter((c)->
          c._id is sales.company._id)[0]
        sales.company.manager = sales.company.managers.filter((m)->
          m._id is mid)[0] if mid
        @selectedSales = angular.copy sales

      save: (form)->
        return if form.$invalid

        Sales.save @selectedSales,
        ->
          $('#salesModal').modal 'hide'
          $tabs[3].salesData = Sales.query {company: $tabs[3].selectedSales.company._id}
        , (err)->
          console.log err
          alert 'Error'

    # 区域管理
    $tabs[4] =
      selectArea: (area)->
        @selectedArea = angular.copy area
        @companyData = Area.get parent: area._id, (data)->
          initPage data

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
          # if self.selectedArea.parent then self.companyData = Area.get parent: self.selectedArea.parent, (data)-> initPage data
          # else self.areaData = Area.get {}, (data)-> initPage data
          # Area.get {num: 100}, (data)-> $tabs[4].allAreas = data.list
          $scope.selectMenu 4

          $('#areaModal').modal 'hide'
          self.selectedArea = null
        , (err)->
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
          , (err)->
            $tabs[5].error = err.data

      save: (form)->
        $tabs[5].error = ''
        return if form.$invalid
        Industry.save @newIndustry,
        ->
          $tabs[5].industries = Industry.query()
          $tabs[5].newIndustry = null
        , (err)->
          $tabs[5].error = err.data

    $tabs[6] =
      prePages: prePages

      nextPages: nextPages

      goPage: (page)->
        if page then Agent.get {page: page}, (data)->
          $tabs[6].agentData.list = data.list
        else @agentData = Agent.get {}, (data)->
          initPage data

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
        , (err)->
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
          , (err)->
            $tabs[7].error = err.data

      save: (form)->
        return if form.$invalid
        $tabs[7].error = ''
        ProjectType.save @newType,
        ->
          $tabs[7].newType = null
          $tabs[7].load()
        , (err)->
          $tabs[7].error = err.data

    $tabs[8] =
      model: Client
      load: ->
        @clientData = Client.get ->
          setTimeout(
            -> $rootScope.$broadcast 'page:init'
            500
          )
      add: ->
        @newClient = {}
      edit: (c) ->
        @newClient = angular.copy c
      save: (e, form) ->
        return if form.$invalid

        Client.save @newClient, ->
          $tabs[8].load()

        $(e).modal 'hide'
        return

    $scope.selectMenu = (id)->
      $location.path '/setting/' + id
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
        when 8
          $tabs[8].load()

    $scope.selectMenu parseInt($routeParams.tab) or 0
]
# settingCtrl end

# financeCtrl
controller 'financeCtrl', [
  '$scope', '$timeout', '$filter', '$http', 'Finance', 'Project'
  ($scope, $timeout, $filter, $http, Finance, Project) ->
    getPanelTitle = (tab) ->
      switch tab
        when 'all' then '全部'
        when 'unpay' then '未付款'
        when 'paied' then '已付款'

    sumPrice = (contract) ->
      contract.contract.price = 0
      angular.forEach contract.projects, (p) ->
        contract.contract.price += p.price
      contract.balance = contract.contract.price
      angular.forEach contract.payments, (p) ->
        contract.balance -= p.money

    $scope.add = ->
      @contract =
        contract: {}
        projects: []
        attachments: []
        payments: []
        invoices: []
      @modalTitle = '新增合同'

    $scope.edit = (id) ->
      $scope.contract = Finance.get _id: id, (data)->
        data.contract.date = $filter('date') data.contract.date, 'yyyy-MM-dd'
        data.contract.recvDate = $filter('date') data.contract.recvDate, 'yyyy-MM-dd'
      $scope.modalTitle = '修改合同'

    $scope.save = ->
      angular.forEach @contract.projects, (p, i) ->
        $scope.contract.projects[i] = p._id
      Finance.save @contract,
      (data) ->
        $('#addModal').modal 'hide'
        $scope.goPage()
      , (err) ->
        console.log err
        $scope.error = err.data

    $scope.showTab = (tab)->
      @panelTitle = getPanelTitle tab
      @tab = tab
      @goPage()

    $scope.addImg = ->
      $('#file').click()
      return
#      @contract.attachments.push 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIwAAACMCAYAAACuwEE+AAAEoElEQVR4Xu3YzStsARyH8d+Q940FUnaykfJSyks25M/2UojI+4aFspLyrrwLt3PqiLl3mIeZK9NjdW/3e+fwnM+cOUfu7OzsJfyyQJEFcoIpspSztIBghIAKCAblciwYDaACgkG5HAtGA6iAYFAux4LRACogGJTLsWA0gAoIBuVyLBgNoAKCQbkcC0YDqIBgUC7HgtEAKiAYlMuxYDSACggG5XIsGA2gAoJBuRwLRgOogGBQLseC0QAqIBiUy7FgNIAKCAblciwYDaACgkG5HAtGA6iAYFAux4LRACogGJTLsWA0gAoIBuVyLBgNoAKCQbkcC0YDqIBgUC7HgtEAKiAYlMuxYDSACggG5XIsGA2gAoJBuRwLRgOogGBQLseC0QAqIBiUy7FgNIAKCAblciwYDaACgkG5HAtGA6iAYFAux4LRACogGJTLsWA0gAoIBuVyLBgNoAKCQbkcC0YDqIBgUC7HgtEAKvDrwExNTb37AScnJ//5Az8/P8fKykpcXV2l//52d3h4GPv7+3F3dxf19fXR2dkZ7e3tn4b7yWN/+s39p8GvA5N1yU5eITB7e3txfX0dx8fH78Ccn5/H2tpadHR0RFdXVyS7g4ODGBwcjObm5qKy/+Sxi/oGyziqSDCXl5exvb0dQ0NDMTc39w7M5uZmnJycxMjISDQ1NaWolpaWorW1NXK5XBwdHUV/f3+0tLTE6elpbGxsRFtbW/T29r6eho/AfPXYfX19ZTzNpXvpigPz9PQUy8vL6dUjOdH5J3d+fj7u7+9jfHw8qqurI9nPzs6mH00JsARPAmdgYCDW19fTPw8PD0dNTc2nYL5z7LGxsdKd1TK+UsWB2d3dTRH09PSk2fLBzMzMRHJ/k32Uvby8xPT0dFRVVcXExET6Eba1tZX+Pdkl7/zk6vP2q9AV5rvHLuN5LtlLVxyYhYWF9EqRXRHIFSZ7ly8uLsbNzU00NjbG6OjoX7ELgSnFsUt2Zsv0QhUHJv9J5m235Kry0T1McjVJboB3dnaitrY2Hh4eoru7O71BLuYK891jl+kcl/RlKw5Mfp38q8FHT0kNDQ3pPUxydUqemlZXV+Px8TG9Qa6rq/v0HuY7xy72Ca2kZ/8LL/brwBR6Fxd6vP7Xx0f2e5jb29tIkGS/h0merJKnpOwR++LiIkWTPSWV89hfOHc/8l9+HZgfqeRBXwsIRgyogGBQLseC0QAqIBiUy7FgNIAKCAblciwYDaACgkG5HAtGA6iAYFAux4LRACogGJTLsWA0gAoIBuVyLBgNoAKCQbkcC0YDqIBgUC7HgtEAKiAYlMuxYDSACggG5XIsGA2gAoJBuRwLRgOogGBQLseC0QAqIBiUy7FgNIAKCAblciwYDaACgkG5HAtGA6iAYFAux4LRACogGJTLsWA0gAoIBuVyLBgNoAKCQbkcC0YDqIBgUC7HgtEAKiAYlMuxYDSACggG5XIsGA2gAoJBuRwLRgOogGBQLseC0QAqIBiUy7FgNIAKCAblciwYDaACgkG5HAtGA6iAYFAux4LRACogGJTLsWA0gAoIBuVyLBgNoAKCQbkcC0YDqMAfSIzIppFTizQAAAAASUVORK5CYII='

    $scope.selectImg = (files) ->
      formData = new FormData
      formData.append('file', files[0])

      $http.post("/api/finance/#{@contract._id}?act=upload", formData, {
        headers: 'Content-Type': undefined
        transformRequest: angular.identity
      }).success((resp) ->
        $scope.contract.contract.attachments.push resp
      )

    $scope.prePages = -> prePages @financeData

    $scope.nextPages = -> nextPages @financeData

    $scope.goPage = (page) ->
      params =
        page: page or ($scope.financeData and  $scope.financeData.curPage) or 1
        type: $scope.tab
      $scope.financeData = Finance.get params, (data) -> initPage data

    $scope.getProjects = ->
      return if not $scope.contract.contract.client or not $scope.contract.contract.client._id
      Project.query {type: 'client', kw: $scope.contract.contract.client._id}, (data) ->
        for p in data
          $scope.addProject p

    $scope.addProject = (project) ->
#      return alert '项目不属于同一个客户' if @contract.contract.client and @contract.contract.client isnt project.client
#      return alert '项目已经存在' if @contract.projects.filter((p)-> p._id is project._id).length > 0

#      @contract.contract.client = project.client unless @contract.contract.client
      @contract.projects.push angular.copy project
#      $('#projectModal').modal 'hide'
      sumPrice $scope.contract

    $scope.delProject = (i) ->
      @contract.projects.splice i, 1
      @contract.contract.client = '' if @contract.projects.length is 0
      sumPrice @contract

    $scope.addPayment = ->
      @payment.date = @payment.date or new Date
      @contract.payments.push angular.copy @payment
      sumPrice @contract
      @payment = null

    $scope.delPayment = (i) ->
      @contract.payments.splice(i, 1)
      sumPrice @contract

    $scope.addInvoice = ->
      @invoice.date = @invoice.date or new Date
      @contract.invoices.push angular.copy @invoice
      @invoice = null

    $scope.delInvoice = (i) ->
      @contract.invoices.splice(i, 1)

    $scope.showTab 'all'
]
# financeCtrl end