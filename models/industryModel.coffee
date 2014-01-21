mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

industrySchema = new Schema
  name: String
  projects: type: Number, default: 0
  
# exports.Industry = mongoose.model 'Industry', industrySchema
# exports.industrySchema = industrySchema
module.exports = mongoose.model 'Industry', industrySchema