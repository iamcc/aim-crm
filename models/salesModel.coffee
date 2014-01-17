mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId
teamSchema = require('../areaModel').teamSchema

salesSchema = new Schema
  name: String
  phone: String
  team: teamSchema
  
exports.Sales = mongoose.model 'Sales', salesSchema
exports.salesSchema = salesSchema
