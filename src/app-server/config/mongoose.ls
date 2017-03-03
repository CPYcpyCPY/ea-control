config = require './config'
mongoose = require 'mongoose'

/**
 * @brief      连接mongodb数据库
 *
 * @return     { Object }  数据库实例（？）
 */
module.exports = ->
  mongoose.Promise = require 'bluebird';
  db = mongoose.connect config.db

  mongoose.set('debug', true)

  mongoose.connection.on "open", !-> console.log("You Have Connect to Mongodb.")
  mongoose.connection.on 'error', !-> console.log 'Mongodb Connection Fail.'

  box = require("../models/box.server.model")
  user = require("../models/user.server.model")
  test-plan = require("../models/test-plan.server.model");
  execution = require("../models/execution.server.model");

  db
