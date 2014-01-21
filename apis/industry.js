// Generated by CoffeeScript 1.6.3
(function() {
  var Industry, Project, async, method;

  Industry = require('../models/industryModel');

  Project = require('../models/projectModel');

  async = require('async');

  method = {
    GET: function(req, res, next) {
      return Industry.find({}, function(err, docs) {
        if (err) {
          console.log(err);
          return res.send(500);
        }
        return res.send(docs);
      });
    },
    POST: function(req, res, next) {
      return async.auto({
        count: function(cb) {
          return Industry.count({
            name: req.body.name
          }, cb);
        },
        data: [
          'count', function(cb, rst) {
            if (rst.count > 0) {
              return res.send(400, '行业已经存在');
            }
            return Industry.create({
              name: req.body.name
            }, cb);
          }
        ]
      }, function(err, rst) {
        if (err) {
          console.log(err);
          return res.send(500);
        }
        return res.send(200);
      });
    },
    DELETE: function(req, res, next) {
      var _id;
      if (!(_id = req.params._id)) {
        return res.send(400);
      }
      return Industry.findById(_id, function(err, doc) {
        if (err) {
          console.log(err);
          return res.send(500);
        }
        if (!doc) {
          return res.send(404);
        }
        if (doc && doc.projects > 0) {
          return res.send(500, '行业已被使用，不能删除');
        }
        doc.remove();
        return res.send(200);
      });
    }
  };

  module.exports = function(req, res, next) {
    var e, _ref;
    try {
      if ((_ref = req.user.role) !== 'leader' && _ref !== 'admin') {
        return res.send(403);
      }
      return method[req.method](req, res, next);
    } catch (_error) {
      e = _error;
      console.log(e);
      return res.send(405);
    }
  };

}).call(this);
