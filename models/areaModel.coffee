mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId
salesSchema = require('./salesModel').salesSchema

teamSchema = new Schema
  name: String
  leader: salesSchema

companySchema = new Schema
  name: String
  managers: [salesSchema]
  teams: [teamSchema]

areaSchema = new Schema
  name: String
  managers: [salesSchema]
  companies: [companySchema]

exports.Area = mongoose.model 'Area', areaSchema
exports.teamSchema = teamSchema
exports.companySchema = companySchema
exports.areaSchema = areaSchema