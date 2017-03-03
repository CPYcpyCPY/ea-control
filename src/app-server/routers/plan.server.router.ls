express = require 'express'
plan = require '../controllers/test-plan.server.controller'
router = express.Router!

module.exports = (router) ->
  router.get '/plans', plan.retrieve-plans
  router.get '/plans/:planId', plan.retrieve-plan-by-id
  router.post '/plans', plan.create-plan

  router.get '/demoDownload/:filename', plan.download-demo
  router.post '/demoUpload', plan.upload-demo

