Validator = require "../../../app/validator/validator.coffee"
fs = require "fs"

data_path = "test/data/1.0.0/invalid/statement/"

invalid = (err, done) ->
  if err?
    done()
  else
    done(new Error "Should not be valid")

fs.readdir data_path, (err, files) ->
  for file in files
    describe "Validate an invalid statement", ->
      val = new Validator "app/validator/schemas/"
      describe "#{file}", ->
        it "should have error", (done) ->
          data = val.loadJsonFile data_path + file
          val.validateWithSchema data, "xAPI", (err) ->
            invalid err, done