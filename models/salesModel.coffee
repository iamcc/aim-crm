mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

salesSchema = new Schema
  name: String
  phone: String
  area: type: ObjectId, ref: 'Area'
  company: String
  leader: type: ObjectId, ref: 'Sales'
  
module.exports = mongoose.model 'Sales', salesSchema