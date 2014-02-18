// Generated by CoffeeScript 1.7.1
(function() {
  var ObjectId, Schema, mongoose, salesSchema;

  mongoose = require('mongoose');

  Schema = mongoose.Schema;

  ObjectId = Schema.Types.ObjectId;

  salesSchema = new Schema({
    name: String,
    phone: String,
    company: {
      _id: ObjectId,
      name: String,
      manager: {
        _id: ObjectId,
        name: String
      },
      parent: ObjectId
    }
  });

  module.exports = mongoose.model('Sales', salesSchema);

}).call(this);

//# sourceMappingURL=salesModel.map
