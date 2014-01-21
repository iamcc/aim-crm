mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

projectTypeSchema = new Schema
  name: String
  projects: type: Number, default: 0
  
module.exports = mongoose.model 'ProjectType', projectTypeSchema