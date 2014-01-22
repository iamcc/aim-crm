// Generated by CoffeeScript 1.6.3
(function() {
  var controller, initPage, nextPages, prePages;

  controller = angular.module('app.controllers', []).controller;

  initPage = function(data) {
    var _i, _ref, _ref1, _results;
    if (!data) {
      return;
    }
    data.curPage = 1;
    data.minPage = 1;
    data.pageNum = 5;
    data.maxPage = data.minPage + data.pageNum - 1;
    if (data.maxPage > data.totalPage) {
      data.maxPage = data.totalPage;
    }
    if (data.maxPage < data.minPage) {
      data.maxPage = data.minPage;
    }
    return data.pageArr = (function() {
      _results = [];
      for (var _i = _ref = data.minPage, _ref1 = data.maxPage; _ref <= _ref1 ? _i <= _ref1 : _i >= _ref1; _ref <= _ref1 ? _i++ : _i--){ _results.push(_i); }
      return _results;
    }).apply(this);
  };

  prePages = function(data) {
    var _i, _ref, _ref1, _results;
    if (!data) {
      return;
    }
    if (data.minPage > 1) {
      data.minPage -= data.pageNum;
      data.maxPage = data.minPage + data.pageNum - 1;
      return data.pageArr = (function() {
        _results = [];
        for (var _i = _ref = data.minPage, _ref1 = data.maxPage; _ref <= _ref1 ? _i <= _ref1 : _i >= _ref1; _ref <= _ref1 ? _i++ : _i--){ _results.push(_i); }
        return _results;
      }).apply(this);
    }
  };

  nextPages = function(data) {
    var _i, _ref, _ref1, _results;
    if (!data) {
      return;
    }
    if (data.maxPage < data.totalPage) {
      data.minPage += data.pageNum;
      data.maxPage = data.minPage + data.pageNum - 1;
      if (data.maxPage > data.totalPage) {
        data.maxPage = data.totalPage;
      }
      return data.pageArr = (function() {
        _results = [];
        for (var _i = _ref = data.minPage, _ref1 = data.maxPage; _ref <= _ref1 ? _i <= _ref1 : _i >= _ref1; _ref <= _ref1 ? _i++ : _i--){ _results.push(_i); }
        return _results;
      }).apply(this);
    }
  };

  controller('userCtrl', [
    '$scope', 'Project', 'ProjectType', 'Industry', 'Agent', 'User', 'Area', 'Sales', function($scope, Project, ProjectType, Industry, Agent, User, Area, Sales) {
      $scope.showCount = function(item) {
        $scope.isShowFilter = false;
        if (item === $scope.curCountItem) {
          $scope.isShowCount = false;
          return $scope.curCountItem = null;
        } else {
          $scope.isShowCount = true;
          return $scope.curCountItem = item;
        }
      };
      $scope.showFilter = function() {
        $scope.isShowCount = false;
        $scope.curCountItem = null;
        return $scope.isShowFilter = !$scope.isShowFilter;
      };
      $scope.prePages = function() {
        return prePages(this.projectData);
      };
      $scope.nextPages = function() {
        return nextPages(this.projectData);
      };
      $scope.goPage = function(page) {
        var self;
        self = this;
        if (page) {
          return Project.get({
            page: page
          }, function(data) {
            return self.projectData.list = data.list;
          });
        } else {
          return self.projectData = Project.get({}, function(data) {
            return initPage(data);
          });
        }
      };
      $scope.showEdit = function(event, project) {
        if ($(event.target).parent().hasClass('edit')) {
          return;
        }
        $scope.oldProject = angular.copy(project);
        $(event.target).find('.view').hide();
        $(event.target).find('.edit').show();
        $(event.target).find('.edit').children().first().focus();
      };
      $scope.saveProject = function() {
        var p;
        p = JSON.parse(angular.toJson(this.newProject));
        p.company = p.sales.company;
        return Project.save(p, function() {
          $('#addModal').modal('hide');
          $scope.newProject = null;
          return $scope.goPage();
        }, function(err) {
          return alert(err.data);
        });
      };
      $scope.update = function(event, project, field) {
        var param;
        $(event.target).closest('.edit').prev().show();
        $(event.target).closest('.edit').hide();
        param = {
          _id: project._id
        };
        param[field] = project[field];
        if ($scope.oldProject[field] !== project[field]) {
          return Project.update(param);
        }
      };
      $scope.goPage();
      $scope.projectTypes = ProjectType.query();
      $scope.industries = Industry.query();
      $scope.agents = Agent.query({
        _id: 'all'
      });
      $scope.supporters = User.getSupporters();
      $scope.areas = Area.all();
      $scope.$watch('newProject.area', function() {
        if ($scope.newProject) {
          $scope.companies = Area.all({
            parent: $scope.newProject.area._id
          });
          return $scope.saleses = null;
        }
      });
      return $scope.$watch('newProject.company', function() {
        if ($scope.newProject) {
          return $scope.saleses = Sales.query({
            company: $scope.newProject.company._id
          });
        }
      });
    }
  ]);

  controller('loginCtrl', [
    '$scope', '$http', '$rootScope', '$location', 'User', function($scope, $http, $rootScope, $location, User) {
      return $scope.login = function(e, form) {
        var $btn;
        if (form.$invalid) {
          return;
        }
        $scope.isError = false;
        $btn = $(e.target);
        $btn.button('loading');
        return User.login({
          uname: $scope.uname,
          pwd: $scope.pwd
        }, function(data) {
          $rootScope.userinfo = data;
          return $location.path('/');
        }, function(err) {
          $btn.button('reset');
          return $scope.isError = true;
        });
      };
    }
  ]);

  controller('settingCtrl', [
    '$scope', 'User', 'Area', 'Sales', 'Industry', 'Agent', 'ProjectType', '$routeParams', '$location', '$route', function($scope, User, Area, Sales, Industry, Agent, ProjectType, $routeParams, $location, $route) {
      var $tabs, $userinfo, lastRoute;
      User.checkLogin();
      $tabs = $scope.tabs = [];
      $userinfo = $scope.userinfo;
      lastRoute = $route.current;
      $scope.$on('$locationChangeSuccess', function() {
        if ($route.current.$$route.controller === 'settingCtrl') {
          return $route.current = lastRoute;
        }
      });
      $tabs[0] = {
        save: function(e, form) {
          var $btn, self;
          if (form.$invalid) {
            return;
          }
          if (this.pwd !== this.pwd2) {
            return this.error = '两次密码不一样';
          }
          this.error = '';
          self = this;
          $btn = $(e.target);
          $btn.button('loading');
          return User.setPwd({
            _id: $userinfo._id,
            pwd: this.pwd
          }, function(data) {
            self.success = '修改成功';
            self.error = '';
            return $btn.button('reset');
          }, function(err) {
            self.success = '';
            self.error = '修改失败';
            $btn.button('reset');
            return console.log(err);
          });
        }
      };
      $tabs[1] = {
        selectUser: function() {
          var _id;
          _id = this.user._id;
          return this.user = angular.copy(this.allUsers.list.filter(function(u) {
            return u._id === _id;
          })[0]);
        },
        updateRealname: function(e) {
          var $btn, self;
          self = this;
          $btn = $(e.target);
          $btn.button('loading');
          return User.setRealname(this.user, function() {
            self.success = '操作成功';
            self.error = '';
            self.allUsers.list.filter(function(u) {
              return u._id === self.user._id;
            })[0].realname = self.user.realname;
            return $btn.button('reset');
          }, function(err) {
            self.success = '';
            self.error = '操作失败';
            console.log(err);
            return $btn.button('reset');
          });
        },
        updateRole: function(e) {
          var $btn, self;
          self = this;
          $btn = $(e.target);
          $btn.button('loading');
          return User.setRole(this.user, function() {
            self.success = '操作成功';
            self.error = '';
            self.allUsers.list.filter(function(u) {
              return u._id === self.user._id;
            })[0].role = self.user.role;
            return $btn.button('reset');
          }, function(err) {
            self.success = '';
            self.error = '操作失败';
            console.log(err);
            return $btn.button('reset');
          });
        },
        resetPwd: function(e) {
          var $btn, self;
          self = this;
          $btn = $(e.target);
          if (confirm('密码将被重置为123456')) {
            $btn.button('loading');
            return User.resetPwd(this.user, function() {
              self.success = '操作成功';
              self.error = '';
              return $btn.button('reset');
            }, function(err) {
              self.success = '';
              self.error = '操作失败';
              console.log(err);
              return $btn.button('reset');
            });
          }
        }
      };
      $tabs[2] = {
        save: function(e, form) {
          var $btn, self;
          if (form.$invalid) {
            return;
          }
          self = this;
          $btn = $(e.target);
          $btn.button('loading');
          return User.save(this.newUser, function(data) {
            self.success = '添加成功';
            self.error = '';
            return $btn.button('reset');
          }, function(err) {
            self.success = '';
            self.error = err.data;
            return $btn.button('reset');
          });
        }
      };
      $tabs[3] = {
        changeArea: function() {
          this.selectedSales.company = null;
          this.salesData = null;
          return Area.get({
            parent: this.selectedSales.area._id,
            num: 100
          }, function(data) {
            return $tabs[3].selectedSales.companies = data.list;
          });
        },
        changeCompany: function() {
          this.salesData = Sales.query({
            company: this.selectedSales.company._id
          });
          return this.selectedSales.company = this.selectedSales.companies.filter(function(obj) {
            return obj._id === $tabs[3].selectedSales.company._id;
          })[0];
        },
        addSales: function() {
          return this.selectedSales = {
            area: angular.copy(this.selectedSales && this.selectedSales.area),
            company: angular.copy(this.selectedSales && this.selectedSales.company),
            companies: angular.copy(this.selectedSales && this.selectedSales.companies)
          };
        },
        selectSales: function(sales) {
          sales.companies = this.selectedSales.companies;
          sales.company.managers = this.selectedSales.company.managers;
          sales.area = this.selectedSales.area;
          return this.selectedSales = angular.copy(sales);
        },
        save: function(form) {
          if (form.$invalid) {
            return;
          }
          return Sales.save(this.selectedSales, function() {
            $('#salesModal').modal('hide');
            return $tabs[3].salesData = Sales.query({
              company: $tabs[3].selectedSales.company._id
            });
          }, function(err) {
            console.log(err);
            return alert('Error');
          });
        }
      };
      $tabs[4] = {
        selectArea: function(area) {
          this.selectedArea = angular.copy(area);
          return this.companyData = Area.get({
            parent: area._id
          }, function(data) {
            return initPage(data);
          });
        },
        addArea: function(parent) {
          return this.selectedArea = {
            parent: parent,
            managers: []
          };
        },
        editArea: function(area) {
          return this.selectedArea = angular.copy(area);
        },
        addManager: function() {
          if (!(this.newManager && this.newManager._id)) {
            return;
          }
          this.selectedArea.managers.push(angular.copy(this.newManager));
          return this.newManager = null;
        },
        prePages: prePages,
        nextPages: nextPages,
        goAreaPage: function(data, page) {
          data.curPage = page;
          return Area.get({
            page: page
          }, function(docs) {
            return data.list = docs.list;
          });
        },
        goCompanyPage: function(data, page) {
          data.curPage = page;
          return Area.get({
            parent: this.selectedArea._id,
            page: page
          }, function(docs) {
            return data.list = docs.list;
          });
        },
        save: function() {
          var self;
          self = this;
          return Area.save(this.selectedArea, function() {
            if (self.selectedArea.parent) {
              self.companyData = Area.get({
                parent: self.selectedArea.parent
              }, function(data) {
                return initPage(data);
              });
            } else {
              self.areaData = Area.get({}, function(data) {
                return initPage(data);
              });
            }
            $('#areaModal').modal('hide');
            return self.selectedArea = null;
          }, function(err) {
            console.log(err);
            return alert('错误');
          });
        }
      };
      $tabs[5] = {
        del: function(i) {
          $tabs[5].error = '';
          if (confirm('确定删除？')) {
            return Industry["delete"](i, function() {
              return $tabs[5].industries = Industry.query();
            }, function(err) {
              return $tabs[5].error = err.data;
            });
          }
        },
        save: function(form) {
          $tabs[5].error = '';
          if (form.$invalid) {
            return;
          }
          return Industry.save(this.newIndustry, function() {
            $tabs[5].industries = Industry.query();
            return $tabs[5].newIndustry = null;
          }, function(err) {
            return $tabs[5].error = err.data;
          });
        }
      };
      $tabs[6] = {
        prePages: prePages,
        nextPages: nextPages,
        goPage: function(page) {
          if (page) {
            return Agent.get({
              page: page
            }, function(data) {
              return $tabs[6].agentData.list = data.list;
            });
          } else {
            return this.agentData = Agent.get({}, function(data) {
              return initPage(data);
            });
          }
        },
        add: function() {
          return this.newAgent = null;
        },
        edit: function(agent) {
          return this.newAgent = angular.copy(agent);
        },
        save: function(form) {
          if (form.$invalid) {
            return;
          }
          return Agent.save(this.newAgent, function() {
            $('#agentModal').modal('hide');
            $tabs[6].newAgent = null;
            return $tabs[6].goPage();
          }, function(err) {
            return alert(err.data);
          });
        }
      };
      $tabs[7] = {
        load: function() {
          return this.projectTypes = ProjectType.query();
        },
        del: function(p) {
          if (confirm('确定删除？')) {
            $tabs[7].error = '';
            return ProjectType["delete"](p, function() {
              $tabs[7].newType = null;
              return $tabs[7].load();
            }, function(err) {
              return $tabs[7].error = err.data;
            });
          }
        },
        save: function(form) {
          if (form.$invalid) {
            return;
          }
          $tabs[7].error = '';
          return ProjectType.save(this.newType, function() {
            $tabs[7].newType = null;
            return $tabs[7].load();
          }, function(err) {
            return $tabs[7].error = err.data;
          });
        }
      };
      $scope.selectMenu = function(id) {
        $location.path('/setting/' + id);
        $scope.selectedMenu = id;
        switch (id) {
          case 0:
            return console.log;
          case 1:
            return $tabs[1].allUsers = User.get({
              num: 100
            });
          case 2:
            return console.log;
          case 3:
            return $tabs[3].areaData = Area.get({
              num: 100
            }, function(data) {
              return initPage(data);
            });
          case 4:
            $tabs[4].areaData = Area.get({}, function(data) {
              return initPage(data);
            });
            return Area.get({
              num: 100
            }, function(data) {
              return $tabs[4].allAreas = data.list;
            });
          case 5:
            return $tabs[5].industries = Industry.query();
          case 6:
            return $tabs[6].goPage();
          case 7:
            return $tabs[7].load();
        }
      };
      return $scope.selectMenu(parseInt($routeParams.tab) || 0);
    }
  ]);

}).call(this);
