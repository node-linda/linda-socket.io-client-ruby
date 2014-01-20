#!/usr/bin/env coffee
## see https://github.com/node-linda/linda-socket.io

http = require 'http'

app = http.createServer()
io = require('socket.io').listen(app)
io.configure 'development', ->
  ## io.set 'log level', 2

linda = require('linda-socket.io').Linda.listen(io: io, server: app)

linda.on 'write', (data) ->
  console.log "write tuple - #{JSON.stringify data}"

linda.on 'watch', (data) ->
  console.log "watch tuple - #{JSON.stringify data}"

port = process.argv[2]-0 || 3000
app.listen port
console.log "server start - port:#{port}"
