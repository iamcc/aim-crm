mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

salesSchema = new Schema
  name: String
  phone: String
  
module.exports = mongoose.model 'Sales', salesSchema