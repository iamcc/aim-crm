mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId
# salesSchema = require('./salesModel').salesSchema

# teamSchema = new Schema
#   name: String
#   leader: salesSchema
#   # sales: [salesSchema]

# companySchema = new Schema
#   name: String
#   managers: [salesSchema]
#   teams: [teamSchema]

areaSchema = new Schema
  name: String
  managers: [{
    _id: ObjectId
    name: String
  }]
  # companies: [companySchema]
  # children: [areaSchema]
  parent: ObjectId

# exports.Area = mongoose.model 'Area', areaSchema
# exports.salesSchema = salesSchema
# exports.teamSchema = teamSchema
# exports.companySchema = companySchema
# exports.areaSchema = areaSchema
module.exports = mongoose.model 'Area', areaSchema