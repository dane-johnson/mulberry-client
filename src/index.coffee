_ = require 'lodash'
io = require 'socket.io-client'
cookie = require 'js-cookie'

uuid = cookie.get('uuid')
roomcode = null
gamestate = {}
socket = null
updateListeners = []
resetListeners = []

update = (data) ->
  _.assign(gamestate, data)
  updateListeners.forEach (listener) ->
    listener gamestate

reset = ->
  resetListeners.forEach (listener) ->
    listener()

onUpdate = (listener) ->
  updateListeners.push listener

onReset = (listener) ->
  resetListeners.push listener

connect = () ->
  socket = io()
  
  
  roomcode = location.pathname.match( /\/(.*)/ )[1] || null
  socket.on 'connect', ->
    socket.emit if not roomcode? then 'screen' else 'player'
    socket.emit 'init', uuid

  socket.on 'reset', ->
    gamestate = {}
    socket.emit 'init'

  getgamestate = () ->
    obj = {}
    _.assign(obj, gamestate)
    obj

  getroomcode = () ->
    new String(roomcode)

  socket.on 'uuid', (data) ->
    uuid = data
    cookie.set 'uuid', uuid
  socket.on 'update', (data) ->
    update data
  socket.on 'reset', ->
    reset()

  gamestate: getgamestate
  roomcode: getroomcode
  emit: socket.emit.bind socket
  onUpdate: onUpdate
  onReset: onReset

module.exports =
  connect: connect
