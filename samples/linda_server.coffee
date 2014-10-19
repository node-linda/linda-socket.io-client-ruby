#!/usr/bin/env coffee
## see https://github.com/node-linda/linda-socket.io

http = require 'http'

app = http.createServer()
io = require('socket.io').listen(app)

linda = require('linda').Server.listen(io: io, server: app)

linda.on 'write', (data) ->
  console.log "write tuple - #{JSON.stringify data}"

linda.on 'watch', (data) ->
  console.log "watch tuple - #{JSON.stringify data}"

port = (process.env.PORT || 3000) - 0
app.listen port
console.log "server start - port:#{port}"

if process.env.EXIT_AT?
  setTimeout ->
    process.exit()
  , process.env.EXIT_AT-0
