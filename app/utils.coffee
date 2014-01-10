crypto = require('crypto')

getRandomInt = (min, max) ->
  return Math.floor(Math.random() * (max - min + 1)) + min

module.exports =

  uid: (len) ->
    buf = []
    chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
    charlen = chars.length

    for i in [0...charlen]
      buf.push chars[getRandomInt(0, charlen - 1)]

    return buf.join('')
