// Generated by CoffeeScript 1.7.1
(function() {
  var Sales, async, method;

  Sales = require('../models/salesModel');

  async = require('async');

  method = {
    GET: function(req, res, next) {
      var query, _id;
      if ((_id = req.params._id)) {
        return console.log(_id);
      } else {
        if ((query = req.query).s) {
          return Sales.find({
            name: new RegExp(req.query.s, 'i')
          }, null, {
            limit: 10
          }, function(err, docs) {
            if (err) {
              return next(err);
            }
            return res.send(docs);
          });
        } else if (query.company) {
          return Sales.find({
            'company._id': query.company
          }, null, {
            sort: 'name'
          }, function(err, docs) {
            if (err) {
              return next(err);
            }
            return res.send(docs);
          });
        }
      }
    },
    POST: function(req, res, next) {
      var _id;
      _id = req.body._id;
      delete req.body._id;
      if (_id) {
        return Sales.findByIdAndUpdate(_id, req.body, function(err) {
          if (err) {
            return next(err);
          }
          return res.send(200);
        });
      } else {
        return Sales.create(req.body, function(err) {
          if (err) {
            return next(err);
          }
          return res.send(200);
        });
      }
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

//# sourceMappingURL=sales.map
