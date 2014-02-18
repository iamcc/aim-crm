Agent = require '../models/agentModel'
async = require 'async'

method =
  GET: (req, res, next)->
    if (_id = req.params._id)
      if _id is 'all' then return Agent.find {}, (err, docs)-> res.send docs
      
      Agent.findById _id, (err, doc)->
#        if err
#          console.log err
#          return res.send 500
        return next(err) if err
        res.send doc
    else
      page = (query = req.query).page or 1
      num = query.num or 10
      opts =
        skip: (page-1)*num
        limit: num
        sort: '-_id'

      async.auto {
        count: (cb)->
          Agent.count {}, cb
        data: (cb)->
          Agent.find {}, null, opts, cb
      },
      (err, rst)->
#        if err
#          console.log err
#          return res.send 500
        return next(err) if err
        res.send {
          totalPage: Math.ceil(rst.count/num)
          list: rst.data
        }
  POST: (req, res, next)->
    return res.send 403 if req.user.role not in ['leader', 'admin']
    delete req.body._id

    if (_id = req.params._id)
      Agent.findByIdAndUpdate _id, req.body, (err)->
#        if err
#          console.log err
#          return res.send 500
        return next(err) if err
      res.send 200
    else
      async.auto {
        count: (cb)-> Agent.count {name: req.body.name}, cb
        save: ['count', (cb, rst)->
          return res.send 500, '代理商已经存在' if rst.count > 0
          Agent.create req.body, cb
        ]
      },
      (err, rst)->
#        if err
#          console.log err
#          return res.send 500
        return next(err) if err
        res.send 200

module.exports = (req, res, next)->
  try
    # return res.send 403 if req.user.role not in ['leader', 'admin']
    method[req.method] req, res, next
  catch e
    console.log e
    res.send 405