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
    '$scope', '$timeout', function($scope, $timeout) {
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
        var data;
        data = $scope.projectData;
        return prePages(data);
      };
      $scope.nextPages = function() {
        var data;
        data = $scope.projectData;
        return nextPages(data);
      };
      $scope.goPage = function(page) {
        return $scope.projectData.curPage = page;
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
      $scope.save = function(event, project, field) {
        var param;
        $(event.target).parent().parent().find('.view').show();
        $(event.target).parent().parent().find('.edit').hide();
        param = {};
        param[field] = project[field];
        if ($scope.oldProject[field] !== project[field]) {
          return console.log('save', param);
        }
      };
      return $timeout(function() {
        var data, _i, _ref, _ref1, _results;
        data = $scope.projectData = {};
        data.minPage = 1;
        data.pageNum = 5;
        data.maxPage = data.minPage + data.pageNum - 1;
        data.curPage = 1;
        data.totalPage = 11;
        data.pageArr = (function() {
          _results = [];
          for (var _i = _ref = data.minPage, _ref1 = data.maxPage; _ref <= _ref1 ? _i <= _ref1 : _i >= _ref1; _ref <= _ref1 ? _i++ : _i--){ _results.push(_i); }
          return _results;
        }).apply(this);
        return data.list = [
          {
            projectName: '1',
            projectType: '1',
            companyName: '1',
            salesName: '1',
            industry: '1',
            curStatus: '1',
            supporterName: '1',
            tags: '1',
            agent: '1',
            price: '1',
            areaName: '1',
            managerName: '1',
            buyYear: '1',
            client: '1',
            orderDate: '1',
            maeAccount: '1',
            maePwd: '1',
            maeCreatorName: '1',
            wxAccount: '1',
            wxPwd: '1',
            wxType: '1',
            ecId: '1',
            sendEcBoxDate: '1',
            onlineDate: '1',
            onlineReviewer: '1',
            memo: '1'
          }
        ];
      }, 1000);
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
    '$scope', 'User', 'Area', 'Sales', '$routeParams', '$location', '$route', function($scope, User, Area, Sales, $routeParams, $location, $route) {
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
          this.company = null;
          if (!this.area.companies) {
            return Area.get({
              parent: this.area._id,
              num: 100
            }, function(data) {
              return $tabs[3].area.companies = data.list;
            });
          }
        },
        changeCompany: function() {
          return this.salesData = Sales.query({
            company: this.company._id
          });
        },
        selectSales: function(sales) {
          return this.selectedSales = angular.copy(sales);
        },
        save: function(form) {
          if (form.$invalid) {
            return;
          }
          this.selectedSales.company = this.company;
          return Sales.save(this.selectedSales, function() {
            $('#salesModal').modal('hide');
            return tabs[3].salesData = Sales.query({
              company: this.company._id
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
        goPage: function(data, page) {
          data = Area.get({});
          return data.curPage = page;
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
      $scope.selectMenu = function(id) {
        $scope.selectedMenu = id;
        switch (id) {
          case 0:
            return console.log;
          case 1:
            if (!$tabs[1].allUsers) {
              return $tabs[1].allUsers = User.get({
                num: 100
              });
            }
            break;
          case 2:
            return console.log;
          case 3:
            if (!$tabs[3].areaData) {
              return $tabs[3].areaData = Area.get({
                num: 100
              }, function(data) {
                return initPage(data);
              });
            }
            break;
          case 4:
            if (!$tabs[4].areaData) {
              return $tabs[4].areaData = Area.get({}, function(data) {
                return initPage(data);
              });
            }
            break;
          case 5:
            return console.log;
          case 6:
            return console.log;
        }
      };
      return $scope.selectMenu(parseInt($routeParams.tab) || 0);
    }
  ]);

}).call(this);
