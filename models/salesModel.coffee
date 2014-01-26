mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

salesSchema = new Schema
  name: String
  phone: String
  company:
    _id: ObjectId
    name: String
    manager:
      _id: ObjectId
      name: String
    parent: ObjectId
  
# exports.Sales = mongoose.model 'Sales', salesSchema
# exports.salesSchema = salesSchema
module.exports = mongoose.model 'Sales', salesSchema
