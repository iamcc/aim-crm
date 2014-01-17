// Generated by CoffeeScript 1.6.3
(function() {
  var Project, async, method, _;

  Project = require('../models/projectModel');

  _ = require('underscore');

  async = require('async');

  method = {
    GET: function(req, res, next) {
      var condition, num, opts, page, query, _id;
      if (_id = req.params._id) {
        return Project.findById(_id, function(err, doc) {
          if (err) {
            console.log(err);
            return res.send(500);
          }
          return res.send(doc);
        });
      } else {
        condition = (query = req.query).condition;
        num = query.num || 10;
        page = query.page || 1;
        opts = {
          skip: (page - 1) * num,
          limit: num
        };
        return async.auto({
          count: function(cb) {
            return Project.count(condition, cb);
          },
          list: function(cb) {
            return Project.find(condition, null, opts, cb);
          }
        }, function(err, rst) {
          if (err) {
            console.log(err);
            return res.send(500);
          }
          return res.send({
            totalPage: Math.ceil(rst.count / num),
            list: rst.list
          });
        });
      }
    },
    PUT: function(req, res, next) {
      var _id;
      if (!(_id = req.params._id)) {
        return res.send(400);
      }
      if (res.body._id) {
        delete res.body._id;
      }
      return Project.update({
        _id: _id
      }, res.body, function(err, doc) {
        if (err) {
          console.log(err);
          return res.send(500);
        }
        return res.send(200);
      });
    },
    POST: function(req, res, next) {
      var doc;
      doc = new Project(req.body);
      return doc.save(function(err, doc) {
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
        res.send(400);
      }
      return Project.findByIdAndRemove(_id, function(err) {
        if (err) {
          console.log(err);
          return res.send(500);
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

}).call(this);
