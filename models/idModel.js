// Generated by CoffeeScript 1.7.1
var idSchema, mongoose;

mongoose = require('mongoose');

idSchema = new mongoose.Schema({
  _id: {
    type: String,
    required: true,
    index: {
      unique: true
    }
  },
  count: {
    type: Number,
    "default": 0
  }
});

idSchema.statics.getID = function(id, cb) {
  return this.findByIdAndUpdate(id, {
    $inc: {
      count: 1
    }
  }, {
    "new": true,
    upsert: true
  }, cb);
};

module.exports = mongoose.model('ID', idSchema);

//# sourceMappingURL=idModel.map
