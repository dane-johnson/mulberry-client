_ = require 'lodash'
io = require 'socket.io-client'

uuid = ''
roomcode = null
gamestate = {}
update = null
socket = null


connect = () ->
  socket = io()
  
  roomcode = location.pathname.match( /\/(.*)/ )[1] || null
  socket.on 'connect', ->
    socket.emit if not roomcode? then 'screen' else 'player'

  getgamestate = () ->
    obj = {}
    _.assign(obj, gamestate)
    obj

  getroomcode = () ->
    new String(roomcode)

  socket.on 'uuid', (data) ->
    uuid = data
  socket.on 'update', (data) ->
    if update?
      update state()

  gamestate: getgamestate
  roomcode: getroomcode
  emit: socket.emit.bind(socket)
  on: socket.on.bind(socket)

module.exports =
  connect: connect
