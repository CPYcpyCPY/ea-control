Execution = require("mongoose").model("Execution")
{ send-data, handle-error } = require '../utils/utils'

/**
 * @brief      Retrieves execution list.
 */
exports.retrieve-executions = (req, res) !->
  { kind, id } = req.query
  Execution.retrieve-executions { 'kind': kind, '_id': id } .exec!
  .then (executions) -> send-data res, 'OK', executions, '获取测试执行记录列表成功'
  .catch (err) -> handle-error res, 'DATABASE_QUERY_ERROR', err, '数据库查询错误'


/**
 * @brief      Retrieves an execution by _id.
 */
exports.retrieve-execution-by-id = (req, res) !->
  Execution.find-one {'_id': req.params.id} .exec!
  .then (execution) -> send-data res, 'OK', execution, '获取测试执行详情成功'
  .catch (err) -> handle-error res, 'DATABASE_QUERY_ERROR', err, '数据库查询错误'
