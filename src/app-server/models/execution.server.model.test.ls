execution = require "./execution.server.model"
test-plan = require "./test-plan.server.model"
require('../config/mongoose')!

execution.retrieve-executions {kind: "box", id: 1}, (err, executions) !->
  console.log executions

execution.retrieve-execution 0, (err, execution) !->
  console.log "enter here"
  console.log execution
# test-plan1 = new test-plan {
#   name: "b36自动洗测试"
#   type: "初期"
#   company-name: "美的"
#   doc:
#     doc-name: "reboot.ei6"
#     doc-url: "http://邓.org"
#   doc-create-date: Date()
#   doc-create:
#     _id: 0
#     username: "lisi"
#   manual-operation-frequency: 20
#   step-count: 3
#   status: "editable"
#   script:
#     package-name: "payment_application.zirz" 
#   script-create-date: Date()
#   script-creator:
#     _id: 1
#     name: "zhaowu"
#   expected-execute-duration: 500000
#   steps:
#     * id: 1
#       name: "启动"
#       expected-step-duration: 400000
#     * id: 2
#       name: "排水"
#       expected-step-duration: 4000

#   used-frequency: 2
# }

# execution1 = new execution {
#   "name": "b36自动洗测试"
#   test-plan:
#     id: 0
#     name: "b36自动洗测试"
#   ea-box:
#     id: 1
#     name: "测试盒m-5"
#   execution-creator:
#     id: 0
#     username: "lisi"
#   start-time: Date()
#   end-time: Date()
#   result: "Fail"
#   step-execute-detail:
#     * id: 1
#       name: "启动"
#       step-duration: 310000
#       result: "Pass"
#     * id: 2
#       name: "排水"
#       step-duration: 3000
#       result: "Fail"
# }

# execution2 = new execution {
#   "name": "b36自动洗测试"
#   test-plan:
#     id: 0
#     name: "b36自动洗测试"
#   ea-box:
#     id: 1
#     name: "测试盒m-5"
#   execution-creator:
#     id: 0
#     username: "lisi"
#   start-time: Date()
#   result: "Pass"
#   step-execute-detail:
#     * id: 1
#       name: "启动"
#       step-duration: 400000
#       result: "Pass"
#     * id: 2
#       name: "排水"
#       step-duration: 4200
#       result: "Pass"
# }

# test-plan1.create (err) !->
#   execution1.create (err) !->
#     execution2.create!
#     console.log "successfully"