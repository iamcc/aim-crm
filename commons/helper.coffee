async = require 'async'

exports.getPage = (model, query, cb) ->
  condition = query.condition

  num = query.num or 10
  page = query.page or 1
  sort = query.sort or '-_id'
  opts =
    skip: (page - 1) * num
    limit: num
    sort: sort

  async.auto {
      count: (cb) ->
        model.count condition, cb
      list: (cb) ->
        model.find condition, null, opts, cb
    } ,
  (err, rst) ->
    return cb err if err
    cb null, {
      count: rst.count
      totalPage: Math.ceil rst.count / num
      list: rst.list
    }