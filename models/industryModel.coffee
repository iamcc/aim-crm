mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

industrySchema = new Schema
  name: String
  
module.exports = mongoose.model 'Industry', industrySchema