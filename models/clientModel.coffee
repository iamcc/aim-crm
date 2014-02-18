mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId
ID = require './idModel'

clientSchema = new Schema
  code: String
  name: String

clientSchema.pre 'validate', (next)->
  self = @
  prefix = 'KH'
  ID.getID prefix, (err, doc) ->
    return next err if err
    self.code = String(doc.count)
    while self.code.length < 6
      self.code = '0' + self.code
    self.code = prefix + self.code
    next()

module.exports = mongoose.model 'Client', clientSchema