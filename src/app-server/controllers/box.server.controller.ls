mongoose = require('mongoose')
Box = mongoose.model('Box')
Execution = mongoose.model('Execution')
Plan = mongoose.model('TestPlan')
Promise = require 'bluebird'
{ send-data, handle-error } = require '../utils/utils'


/**
 * @brief      获取测试盒列表
 */
exports.retrieve-boxes = (req, res) !->
  Box.find {} .exec! .then (boxes) -> boxes
  .then (boxes) ->
    promise-list = []
    console.log '9'
    for let box in boxes
      promise-list.push(Execution.find-one {'eaBox._id': box._id} .sort('startTime': 1) .exec! .then (execution) ->
        Plan.find-one {_id: if execution then execution.testPlan._id else undefined} .exec! .then (plan) -> {
          _id: box._id
          name: box.name
          execution
          plan
        }
      )

    Promise.all promise-list
  .then (boxes) -> send-data res, 'OK', boxes, '获取测试盒列表成功'
  .catch (err) -> handle-error res, 'DATABASE_QUERY_ERROR', err, '数据库查询错误'


/**
 * @brief      获取一个测试盒详情
 */
exports.retrieve-box-by-id = (req, res) !->
  Box.find-one {_id: req.params.box-id} .exec! .then (box) -> box
  .then (box) !->
    Execution.find {'eaBox._id': box._id} .exec!
    .then (executions) ->

      data = {
        _id: box._id
        id: box.id
        name: box.name
        working-status: box.workingStatus
        executions: executions
      }
      console.log 'data: ', data
      send-data res, 'OK', data, '获取测试盒详情'
    .catch (err) -> handle-error res, 'DATABASE_QUERY_ERROR', err, '数据库查询错误'

