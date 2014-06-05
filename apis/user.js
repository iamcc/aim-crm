// Generated by CoffeeScript 1.7.1
var User, async, method;

User = require('../models/userModel');

async = require('async');

method = {
  GET: function(req, res, next) {
    var condition, copyUser, num, opts, page, query, user, _id, _ref;
    user = req.user;
    if (req.params._id === 'me' || ((_ref = user.role) !== 'leader' && _ref !== 'admin')) {
      copyUser = JSON.parse(JSON.stringify(user));
      delete copyUser.pwd;
      return res.send(copyUser);
    }
    if (_id = req.params._id) {
      if (_id === 'supporters') {
        return User.find({
          role: 'supporter'
        }, '_id realname', function(err, docs) {
          return res.send(docs);
        });
      }
      return User.findById(_id, function(err, doc) {
        if (err) {
          return next(err);
        }
        if (user.role === 'leader' && doc && doc.role !== 'supporter') {
          return res.send(null);
        }
        return res.send(doc);
      });
    } else {
      condition = (query = req.query).condition || {};
      if (user.role === 'leader') {
        condition.role = 'supporter';
      }
      condition.uname = {
        $not: /admin/i
      };
      num = query.num || 10;
      page = query.page || 1;
      opts = {
        skip: (page - 1) * num,
        limit: num,
        sort: 'id'
      };
      return async.auto({
        count: function(cb) {
          return User.count(condition, cb);
        },
        list: function(cb) {
          return User.find(condition, null, opts, cb);
        }
      }, function(err, rst) {
        if (err) {
          return next(err);
        }
        return res.send({
          totalPage: Math.ceil(rst.count / num),
          list: rst.list
        });
      });
    }
  },
  PUT: function(req, res, next) {
    var act, query, realname, user, _id, _ref, _ref1;
    _id = req.params._id;
    act = (query = req.query).act;
    user = req.user;
    switch (act) {
      case 'setpwd':
        return User.findById(user._id, function(err, doc) {
          if (err) {
            return next(err);
          }
          if (!doc) {
            return res.send(404);
          }
          doc.pwd = req.body.pwd;
          return doc.save(function(err2) {
            if (err2) {
              return next(err2);
            }
            return res.send(200);
          });
        });
      case 'resetpwd':
        if (!_id) {
          return res.send(400);
        }
        if ((_ref = user.role) !== 'leader' && _ref !== 'admin') {
          return res.send(403);
        }
        return User.findById(_id, function(err, doc) {
          if (err) {
            return next(err);
          }
          if (!doc) {
            return res.send(404);
          }
          if (user.role === 'leader' && doc.role !== 'supporter') {
            return res.send(400);
          }
          doc.pwd = '123456';
          return doc.save(function(err2) {
            if (err2) {
              return next(err2);
            }
            return res.send(200);
          });
        });
      case 'setrealname':
        if (!_id || !(realname = req.body.realname)) {
          return res.send(400);
        }
        if ((_ref1 = user.role) !== 'leader' && _ref1 !== 'admin') {
          return res.send(403);
        }
        return User.findById(_id, function(err, u) {
          if (err) {
            return next(err);
          }
          if (!u) {
            return res.send(404);
          }
          if (user.role === 'leader' && u.role !== 'supporter') {
            return res.send(400);
          }
          u.realname = req.body.realname;
          return u.save(function(err2) {
            if (err2) {
              return next(err2);
            }
            return res.send(200);
          });
        });
      case 'setrole':
        if (user.role !== 'admin') {
          return res.send(403);
        }
        return User.findById(_id, function(err, doc) {
          if (err) {
            return next(err);
          }
          if (!doc) {
            return res.send(404);
          }
          doc.role = req.body.role;
          return doc.save(function(err2) {
            if (err2) {
              return next(err2);
            }
            return res.send(200);
          });
        });
      default:
        return res.send(400);
    }
  },
  POST: function(req, res, next) {
    var user, _ref;
    if ((_ref = req.user.role) !== 'leader' && _ref !== 'admin') {
      return res.send(403);
    }
    user = new User(req.body);
    if (req.user.role === 'leader') {
      user.role = 'supporter';
    }
    return async.waterfall([
      function(cb) {
        return user.exists(cb);
      }, function(existUser, cb) {
        if (existUser) {
          return res.send(400, 'username existed');
        }
        return user.save(cb);
      }
    ], function(err, rst) {
      if (err) {
        return next(err);
      }
      return res.send(200);
    });
  }
};

module.exports = function(req, res, next) {
  var e;
  try {
    return method[req.method](req, res, next);
  } catch (_error) {
    e = _error;
    console.log(e);
    return res.send(405);
  }
};

//# sourceMappingURL=user.map
