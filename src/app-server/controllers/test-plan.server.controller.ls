Plan = require("mongoose").model("TestPlan")
Execution = require("mongoose").model("Execution")
Promise = require('bluebird')
{ send-data, handle-error } = require '../utils/utils'

/**
 * 静态
 * @brief      获取测试计划列表
 */
exports.retrieve-plans = (req, res) !->
  Plan.find {} .exec! .then (plans) ->
    promise-list = []
    for let doc in plans
      plan = doc.to-object!
      promise-list.push ( Execution.find {'testPlan._id': plan._id} .exec! .then (executions) ->
        plan.passes = (executions.filter (execution)-> execution.result is 'pass').length
        plan.fails = executions.length - plan.passes
        plan
      )

    Promise.all promise-list
  .then (plans) -> send-data res, 'OK', plans, '获取测试计划列表成功'
  .catch (err) -> handle-error res, 'DATABASE_QUERY_ERROR', err, '数据库查询错误'


/**
 * @brief      获取一个测试计划详情
 */
exports.retrieve-plan-by-id = (req, res) !->
  Plan.find-one {'_id': req.params.planId} .exec! .then (doc) ->
    plan = doc.to-object!
    Execution.find {'testPlan._id': plan._id}  .exec! .then (executions) ->
      plan.executions = executions
      plan
  .then (plan) -> send-data res, 'OK', plan, '获取测试计划详情成功'
  .catch (err) -> handle-error res, 'DATABASE_QUERY_ERROR', err, '数据库查询错误'


/**
 * @brief      创建新测试计划
 */
exports.create-plan = (req, res) !->
  {name, type, manual-operation-frequency, status, used-frequency, doc-creator, script-creator, expected-execute-duration, doc-create-date, script} = req.body

  # steps是硬编码的
  plan = new Plan {
    name
    type
    manual-operation-frequency
    status
    used-frequency
    doc-creator
    script-creator
    expected-execute-duration
    doc-create-date
    steps: [
      {name: '排水'          ,expectedStepDuration: 45000}
      {name: '进水'          ,expectedStepDuration: 0      ,capacity: '4L'}
      {name: '频率检测'       ,expectedStepDuration: 0}
      {name: '高速洗涤'       ,expectedStepDuration: 300000}
      {name: '排水'          ,expectedStepDuration: 45000}
    ]
  }

  plan.save!
  .then (new-plan) !-> send-data res, 'OK', new-plan, '创建新测试计划成功'
  .catch (err) -> handle-error res, 'DATABASE_INSERT_ERROR', err, '数据库插入错误，添加新测试计划失败'


/**
 * @brief      Uploads test-plan-doc for demo.
 */
exports.upload-demo = (req, res) !->
  { id, username, user-id } = req.body
  Plan.update {'_id': id}, { $set: { status: 'executable', script-creator: {_id: user-id, username: username }, script: { test-package: 'driven-test-plans', package-name: '../node_modules/midea-kitchen-tests/bin/b36', test-name: 'soak' }} } .exec!
  .then (doc) -> send-data res, 'OK', null, '上传测试文档成功'
  .catch (err) -> handle-error res, 'WRITE_FILE_FAIL', err, '上传测试文档失败'


/**
 * @brief      Downloads a test-execution data for demo.
 */
exports.download-demo = (req, res) !->
  console.log 'download-demo'
  filename = req.params.filename
  file = 'assets/demo/' + filename
  res.download file

