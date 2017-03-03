mongoose = require "mongoose"
Schema = mongoose.Schema

user-schema = new Schema {
  # id : Number,
  username: String,
  password: String,
  company-name: String,
  role:
    type: String
    enum: ["admin", "user"]
  create-date: { type: Date, default: Date.now}
}

# user-schema.methods.create = (callback) !->
#   that = @
#   user.find {}, (err, users) !->
#     that.id = users.length
#     that.save callback

user = mongoose.model "User", user-schema

module.exports = user
