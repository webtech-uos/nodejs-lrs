Validator = require "../../../app/validator/validator.coffee"
fs = require "fs"

# Test of regex for media types in attachment object.

data_path = "test/data/1.0.0/valid/statement/minimal-example-variants/"

valid = (err, done) ->
  if err?
    done(new Error err[0].desc)
  else
    done()

val = new Validator "app/validator/schemas/"

withParameters = 
  "charset": "application/json; charset=UTF-8"

  "Content-Type1": 'message/external-body; name="BodyFormats.ps";
                   site="thumper.bellcore.com"; mode="image";
                   access-type=ANON-FTP; directory="pub";
                   expiration="Fri, 14 Jun 1991 19:13:14 -0400 (EDT)"'

  "Content-Type2": 'message/external-body; access-type=local-file;
                   name="/u/nsb/writing/rfcs/RFC-MIME.ps";
                   site="thumper.bellcore.com";
                   expiration="Fri, 14 Jun 1991 19:13:14 -0400 (EDT)"'

  "Content-Type3": 'message/external-body;
                   access-type=mail-server
                   server="listserv@bogus.bitnet";
                   expiration="Fri, 14 Jun 1991 19:13:14 -0400 (EDT)"'
      
fs.readFile "test/unit/validator/media-types.csv", "utf8", (err, data) ->
  if err?
    console.log err
    return
  describe 'Media type', ->
    it 'should all be valid', (done) ->
      lines = data.split "\n"
      for line in lines
        words = line.split ","
        unless words[1] == "" or words[1] == " " or words[1] == "Template"
          if not words[1].match /^[a-zA-Z@<>_"\-\.":,]+\/[a-zA-Z0-9@<>_"\-\.:,]+(\+[a-zA-Z0-9@<>_"\-\.:,]+)?([;\s]([a-zA-Z0-9@<>_"\-\.:,]+=[a-zA-Z0-9@<>_"\-\.:,]+))*$/
            done(new Error words[1] + " not accepted!")
            return
      done()

describe 'Media type with parameter', ->
  it 'should all be valid', (done) ->
    for line in withParameters
      if not line.match /^[a-zA-Z0-9@<>_"\-\.:,]+\/[a-zA-Z0-9@<>_"\-\.:,]+(\+[a-zA-Z0-9@<>_"\-\.:,]+)?(;\s([a-zA-Z0-9@<>_"\-\.:,]+[=][a-zA-Z0-9@<>_"\-\.:,]+))*$/
        done(new Error word + " not accepted!")
        return
    done()