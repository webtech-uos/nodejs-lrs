Validator = require "../../app/validator/validator.coffee"
fs = require "fs"

data_path = "test/data/1.0.0/valid/statement/minimal-example-variants/"
file = "minimal-agent-account.json"

# fs.readdir data_path, (err, files) ->
#   for file in files
describe "Validate an valid statement", ->
  @timeout 0
  val = new Validator "app/validator/schemas/"
  val.loadSchema "UUID"
  val.loadSchema "IFI"
  val.loadSchema "Agent"
  val.loadSchema "Group"
  val.loadSchema "xAPI"
  describe "#{file}", ->
    it "should validate without errors", (done) ->
      fs.readFile data_path + file, (err, data) ->
        if err?
          done err
        else
          json = JSON.parse data
          val.validate data, (errors) ->
            if errors?
              done errors
            else
              done