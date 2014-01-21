// Generated by CoffeeScript 1.6.3
(function() {
  var ObjectId, Schema, mongoose, projectTypeSchema;

  mongoose = require('mongoose');

  Schema = mongoose.Schema;

  ObjectId = Schema.Types.ObjectId;

  projectTypeSchema = new Schema({
    name: String,
    projects: {
      type: Number,
      "default": 0
    }
  });

  module.exports = mongoose.model('ProjectType', projectTypeSchema);

}).call(this);