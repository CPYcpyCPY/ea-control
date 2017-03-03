mongoose = require 'mongoose'
Schema = mongoose.Schema

execution-schema = new Schema {
	# id : Number,
	name: String,
	test-plan: {
		_id: String,
		name: String
	},
	ea-box: {
		_id: String,
		name: String
	},
	execution-creator: {
		_id: String,
		username: String
	},
	reason: {
		step: String,
		err: String
	}
	start-time: Date,
	end-time: Date,
	result: String,
	comment: String,
	step-execute-detail: [{
		_id: String,
		name: String,
		time-used: Number,
		status: String,
		result: String
	}]
}

# execution-schema.methods.create = (callback) !->
# 	that = @
# 	# console.log that
# 	execution.find {}, (err, executions) !->
# 		that.id = executions.length
# 		that.save callback

execution-schema.statics.retrieve-executions = (query, callback) !->
	if query.kind == "box"
		execution.find { "eaBox.id" : query.id}, (err, executions) !->
			callback(err, executions)
	else
		execution.find { "testPlan.id" : query.id}, (err, executions) !->
			callback(err, executions)

execution-schema.statics.retrieve-execution = (execution-id, callback) !->
	execution.findOne {id: execution-id}, (err, execution) !->
		callback(err, execution)


execution = mongoose.model "Execution", execution-schema

module.exports = execution