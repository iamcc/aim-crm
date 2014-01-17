mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

industrySchema = new Schema
  name: String
  
exports.Industry = mongoose.model 'Industry', industrySchema
exports.industrySchema = industrySchema