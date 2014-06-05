// Generated by CoffeeScript 1.7.1
var async;

async = require('async');

exports.getPage = function(model, query, cb) {
  var condition, num, opts, page, sort;
  condition = query.condition;
  num = query.num || 10;
  page = query.page || 1;
  sort = query.sort || '-_id';
  opts = {
    skip: (page - 1) * num,
    limit: num,
    sort: sort
  };
  return async.auto({
    count: function(cb) {
      return model.count(condition, cb);
    },
    list: function(cb) {
      return model.find(condition, null, opts, cb);
    }
  }, function(err, rst) {
    if (err) {
      return cb(err);
    }
    return cb(null, {
      count: rst.count,
      totalPage: Math.ceil(rst.count / num),
      list: rst.list
    });
  });
};

//# sourceMappingURL=helper.map
