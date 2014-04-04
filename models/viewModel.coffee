mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

viewSchema = new Schema
  catalog: String
  names: [String]

module.exports = mongoose.model 'View', viewSchema