Validator = require "../../../../app/validator/validator.coffee"
fs = require "fs"

data_path = "test/data/1.0.0/invalid/statement/"

invalid = (err, done) ->
  if err?
    done()
  else
    done(new Error "Should not be valid")

fs.readdir data_path, (err, files) ->
  for file in files
    do (file) ->
      describe "Invalid statement", ->
        val = new Validator "app/validator/schemas/"
        describe "from #{file}", ->
          it "should be invalid", (done) ->
            try
              data = val.loadJsonFile data_path + file
            catch error
              done()
              return
            val.validateWithSchema data, "Statement", (err) ->
              invalid err, done