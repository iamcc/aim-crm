mongoose = require 'mongoose'
Schema = mongoose.Schema

productSchema = new Schema {
  name:
    type: String
    required: true
    trim: true
  unit:
    type: String
    required: true
  price:
    type: Number
    min: 0
}

module.exports = mongoose.model 'Product', productSchema