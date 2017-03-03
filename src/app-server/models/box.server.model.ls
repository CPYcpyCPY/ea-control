mongoose = require 'mongoose'
Schema = mongoose.Schema

box-schema = new Schema {
	id : String,
	name: String,
	company-name: String,
	product-info: {
		rpi-serial: String,
		rpi-version: String,
		release-date: Date,
		box-version: String
	},
	register-date: Date,
	working-status:
		type: String
		enum: ["busy", "idle"]
}

# box-schema.methods.create = (callback) !->
# 	that = @
# 	box.find {}, (err, boxes) !->
# 		that.id = boxes.length
# 		that.save callback

box = mongoose.model "Box", box-schema

module.exports = box
console.log '2'
