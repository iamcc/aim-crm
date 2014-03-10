// Generated by CoffeeScript 1.7.1
(function() {
  var Project, method, moment;

  Project = require('../models/projectModel');

  moment = require('moment');

  method = {
    GET: function(req, res, next) {
      var condition, opts, query;
      condition = JSON.parse((query = req.query).condition);
      if (req.user.role === 'supporter') {
        condition['supporter._id'] = req.user._id;
      }
      if (condition.sOrderDate) {
        condition.orderDate = condition.orderDate || {};
        condition.orderDate.$gte = condition.sOrderDate;
        delete condition.sOrderDate;
      }
      if (condition.eOrderDate) {
        condition.orderDate = condition.orderDate || {};
        condition.orderDate.$lte = condition.eOrderDate;
        delete condition.eOrderDate;
      }
      opts = {
        sort: '_id'
      };
      return Project.find(condition, null, opts, function(err, docs) {
        if (err) {
          return next(err);
        }
        res.attachment('export.xls');
        return res.render('export', {
          data: docs,
          moment: moment
        });
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

//# sourceMappingURL=export.map