Validator = require "../../app/validator/validator.coffee"
fs = require "fs"

data_path = "test/data/1.0.0/invalid/statement/"

fs.readdir data_path, (err, files) ->
  for file in files
    describe "Validate an invalid statement", ->
      val = new Validator "app/validator/schemas/"
      # val.loadSchema "UUID"
      # val.loadSchema "IFI"
      # val.loadSchema "Agent"
      # val.loadSchema "Group"
      val.loadSchema "xAPI"
      describe "#{file}", ->
        it "should have error", (done) ->
          data = val.loadJsonFile data_path + file
          val.validate data, (err) ->
            if err?
              done 
            else
              done err