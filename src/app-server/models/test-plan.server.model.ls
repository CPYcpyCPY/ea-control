mongoose = require 'mongoose'
Schema = mongoose.Schema

test-plan-schema = new Schema {
	# id : Number,
	name: String,
	type: String,
	company-name: String,
	doc: {
		doc-name: String,
		doc-url: String
	},
	doc-create-date: Date,
	doc-creator: {
		_id: String,
		username: String
	},
	manual-operation-frequency: Number,
	step-count: Number,
	status: String,
	script: {
		test-package: String,
		package-name: String,
		test-name: String
	},
	script-create-date: Date,
	script-creator: {
		_id: String,
		username: String
	},
	expected-execute-duration: Number,
	steps: [{
		_id: Number,
		name: String,
		expected-step-duration: Number,
		capacity: String
	}],
	used-frequency: Number
}

# test-plan-schema.methods.create = (callback) !->
# 	that = @
# 	test-plan.find {}, (err, test-plans) !->
# 		that.id = test-plans.length
# 		that.save callback

test-plan = mongoose.model "TestPlan", test-plan-schema

module.exports = test-plan

