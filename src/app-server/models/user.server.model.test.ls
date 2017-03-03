box = require './box.server.model'
require('../config/mongoose')!
# User = new user {
#   name: "测试盒子1",
#   test-plan: {
#     _id: 1,
#     name: "asda"
#   },
#   ea-box: {
#     _id : 1,
#     name: "测试"
#   },
#   execution-creator: {
#     _id: 1,
#     username: "我"
#   },
#   start-time: Date()
#   end-time: Date()
#   step-execute-detail:
#     * id: "1"
#       name: "1"
#       step-duration: 100
#       result: "fail"
#     * id: "2"
#       name: "2"
#       step-duration: 200
#       result: "succ"
# }
# id : Number,
#   username: String,
#   password: String,
#   company-name: String,
#   role:
#     type: String
#     enum: ["admin", "user"]
# User = new user {
#   username: "zhaowu"
#   password: "12345678"
#   company-name: "美的"
#   role: "admin"
# }

# # mongoose.Promise = require('q').Promise;

# User1 = new user {
#   username: "lisi"
#   password: "12345678"
#   company-name: "美的"
#   role: "user"
# }

Box1 = new box {
  name: "测试盒d-6"
  company-name: "美的"
  product-info:
    rpi-serial: "5b7f76f0-ffd1-4025-aae0-ea6acf10f171"
    rpi-version: "0.0.1"
    release-date: Date()
    box-version: "0.1.1"
  register-date: Date()
  working-status: "spare"
}

Box2 = new box {
  name: "测试盒m-5"
  company-name: "美的"
  product-info:
    rpi-serial: "8a5b572d-c314-483d-a506-f1387da4d872"
    rpi-version: "0.0.1"
    release-date: Date()
    box-version: "0.1.1"
  register-date: Date()
  working-status: "busy"
}

Box1.create (err) !->
  if err
    console.log err
  else 
    Box2.create!
    console.log("succ")
