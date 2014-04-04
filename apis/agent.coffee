Agent = require '../models/agentModel'
Product = require '../models/productModel'
async = require 'async'

method =
  GET: (req, res, next)->
    if (_id = req.params._id)
      if _id is 'all' then return Agent.find {}, (err, docs)-> res.send docs
      
      Agent.findById _id, (err, doc)->
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
        return next(err) if err
        res.send {
          totalPage: Math.ceil(rst.count/num)
          list: rst.data
        }
  POST: (req, res, next)->
    return res.send 403 if req.user.role not in ['leader', 'admin']
    delete req.body._id

    if (_id = req.params._id)
      Agent.count {name: req.body.name}, (err, count) ->
        return next err if err
        return res.send 500, '代理商已经存在' if count > 1

        Agent.findByIdAndUpdate _id, req.body, (err2)->
          return next(err2) if err2
          res.send 200
    else
      async.auto {
        count: (cb)-> Agent.count {name: req.body.name}, cb
        products: (cb) -> Product.find {}, cb
        save: ['count', 'products', (cb, rst)->
          return res.send 500, '代理商已经存在' if rst.count > 0

          for product in rst.products
            product.price *= 0.3

          req.body.products = rst.products

          Agent.create req.body, cb
        ]
      },
      (err, rst)->
        return next(err) if err
        res.send 200

module.exports = (req, res, next)->
  try
    method[req.method] req, res, next
  catch e
    console.log e
    res.send 405