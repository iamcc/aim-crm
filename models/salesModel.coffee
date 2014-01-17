mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

salesSchema = new Schema
  name: String
  phone: String
  
exports.Sales = mongoose.model 'Sales', salesSchema
exports.salesSchema = salesSchema