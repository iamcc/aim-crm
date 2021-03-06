// Generated by CoffeeScript 1.7.1
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

//# sourceMappingURL=projectTypeModel.map
