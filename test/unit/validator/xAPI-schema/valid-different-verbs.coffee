Validator = require "../../../../app/validator/validator.coffee"
fs = require "fs"

data_path = "test/data/1.0.0/valid/statement/different-verbs/"

valid = (err, done) ->
  if err?
    done(new Error err[0].desc)
  else
    done()

val = new Validator "app/validator/schemas/"
      
fs.readdir data_path, (err, files) ->
  for file in files
    do (file) ->
      describe "Valid statement with different verb", ->
        describe "from #{file}", ->
          it "should be valid", (done) ->
            fs.readFile data_path + file, "utf8", (err, data) ->
              if err?
                done err
                return
              else
                try 
                  json = JSON.parse data
                catch error
                  done error
                  return
                val.validate json, (errors) ->
                  valid errors, done