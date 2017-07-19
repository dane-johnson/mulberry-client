_ = require 'lodash'
io = require 'socket.io-client'

uuid = ''
roomcode = null
gamestate = {}
update = null


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
  emit: socket.emit
  on: socket.on

module.exports =
  connect: connect
