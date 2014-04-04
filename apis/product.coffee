Product = require '../models/productModel'
Agent = require '../models/agentModel'
_ = require 'underscore'

method =
  GET: (req, res, next) ->
    Product.find {}, (err, products) ->
      return next err if err
      res.send products
  POST: (req, res, next) ->
    delete req.body._id

    if id = req.params._id
      Product.findById id, (err, product) ->
        return next err if err

        _.extend product, req.body

        product.save (err2) ->
          return next err2 if err

          Agent.find {}, (err3, agents) ->
            console.log err3 if err3

            for agent in agents
              agentProduct = agent.products.id(product._id)
              agentProduct.name = product.name
              agentProduct.unit = product.unit
              agent.save()

          res.send 200
    else
      product = new Product req.body
      product.save (err) ->
        return next err if err

        product.price *= 0.3

        Agent.find {}, (err2, agents) ->
          for agent in agents
            agent.products.push product
            agent.save()

        res.send 200

module.exports = (req, res, next) ->
  try
    method[req.method] req, res, next
  catch e
    console.log e
    res.send 405