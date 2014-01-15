// Generated by CoffeeScript 1.6.3
(function() {
  var User;

  User = require('../models/userModel');

  module.exports = function(app) {
    var auth;
    auth = function(req, res, next) {
      if (!(req.user = req.session.user)) {
        return res.send(401);
      }
      return next();
    };
    app.post('/login', function(req, res) {
      var pwd, uname, _ref;
      _ref = req.body, uname = _ref.uname, pwd = _ref.pwd;
      return User.login(uname, pwd, function(b, doc) {
        var resDoc;
        if (!b) {
          return res.send(401);
        }
        req.session.user = doc;
        resDoc = JSON.parse(JSON.stringify(doc));
        delete resDoc.pwd;
        return res.send(resDoc);
      });
    });
    app.get('/logout', function(req, res) {
      req.session = null;
      return res.send(200);
    });
    return app.all('/api/:mod/:_id?', auth, function(req, res, next) {
      var e;
      try {
        return require("../apis/" + req.params.mod)(req, res, next);
      } catch (_error) {
        e = _error;
        console.log(e);
        return res.send(404);
      }
    });
  };

}).call(this);
