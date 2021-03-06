// Generated by CoffeeScript 1.7.1
var Project, View, helper, method;

View = require('../models/viewModel');

Project = require('../models/projectModel');

helper = require('../commons/helper');

method = {
  GET: function(req, res, next) {
    return View.find({}, function(err, docs) {
      return res.send(docs);
    });
  },
  POST: function(req, res, next) {
    delete req.body._id;
    if (req.params._id) {
      return View.findByIdAndUpdate(req.params._id, req.body, function(err, doc) {
        if (err) {
          return next(err);
        }
        return res.send(200);
      });
    } else {
      return View.create(req.body, function(err) {
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

//# sourceMappingURL=view.map
