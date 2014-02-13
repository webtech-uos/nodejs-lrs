JaySchema = require 'jayschema'
fs = require 'fs'

schemaDir = '../../../app/validator/schemas/'
schema = 'xAPIStatement'
sampleStatement = require '../../data/1.0.0/valid/statement/different-verbs/answered-a2050403-6ac3-424e-8c75-5ff67897f612'
  # require '../../data/1.0.0/valid/statement/different-verbs/attended-67d9c0ed-49e7-4b1b-a4aa-2254d07132f9'
# ]

describe.skip 'JaySchema', ->
  it 'should allow multiple callbacks', (done) ->
    
    @timeout 10000
  
    js = new JaySchema (ref, callback) ->
      fs.readFile './app/validator/schemas/' + ref + ".json", "utf8", (err, data) ->
        if err?
          callback err
        else
          callback undefined, JSON.parse(data)
      # callback undefined, require schemaDir + ref

    js.register require schemaDir + schema

    c = 0
    n = 20
    for i in [1..n]
      js.validate JSON.parse(JSON.stringify(sampleStatement)), schema, (err) ->
        console.log "returned: #{++c} - #{JSON.stringify err}"
        done() if c is n