crypto = require('crypto')

getRandomInt = (min, max) ->
  return Math.floor(Math.random() * (max - min + 1)) + min

module.exports =

  uid: (len) ->
    buf = []
    chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
    charlen = chars.length

    for i in [0...len]
      buf.push chars[getRandomInt(0, charlen - 1)]

    return buf.join('')

  # Generates a UUID from the current date and a random number.
  # @see http://www.ietf.org/rfc/rfc4122.txt
  generateUUID: ->
    d = (new (Date)()).getTime()
    'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace /[xy]/g, (c) ->
      r = (d + Math.random()*16)%16 | 0
      d = Math.floor(d/16)
      d = if c is 'x' then r else (r & 0x3|0x8)
      d.toString(16)
