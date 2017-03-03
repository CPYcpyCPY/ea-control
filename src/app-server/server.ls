Mongoose = require './config/mongoose'
express = require './config/express'
socket = require './config/socket'
config = require './config/config'
http = require 'http'

process.env.NODE_ENV = process.env.NODE_ENV || 'development'

db = Mongoose!
app = express!
server = http.Server app

server.listen config.port, !->
  console.log "Express server listening on 3000"

socket server
