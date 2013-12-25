assert = require "assert"
Validator = require "../../../../app/validator/validator.coffee"

val = new Validator 'app/validator/schemas/'

invalid = (err, done) ->
  if err?
    done()
  else
    done(new Error "Should not be valid")

validDates =
  withDelimiter : "2012-01-11T11:13:42+02:00"
  withMillis : "2012-01-11T11:13:42.111+02:00"
  withoutDelimiter : "20120111T111342+02:00"
  withUTCTimezone : "2012-01-11T00:00:00Z"        
  withoutTimezone : "2012-01-11T11:13:42"
  extendedPlus : "+2012-01-11T00:00:00Z"
  extendedMinus : "-0001-01-11T00:00:00Z"      

invalidDates =
  wrongYear : "20-01-11T11:13:42+02:00"
  wrongHour : "2012-01-11T1:13:42+02:00"
  wrongTimezone : "2012-01-11T11:13:42+02:"
  

describe 'ISO 8061 date', ->

  describe 'with delimiter', ->
    it 'should be valid', (done) ->
      val.validateWithSchema validDates.withDelimiter, "ISO8061Date", done

  describe 'with milliseconds', ->
    it 'should be valid', (done) ->
      val.validateWithSchema validDates.withMillis, "ISO8061Date", done

  describe 'without delimiter', ->
    it 'should be valid', (done) ->
      val.validateWithSchema validDates.withoutDelimiter, "ISO8061Date", done

  describe 'without timezone', ->
    it 'should be valid', (done) ->
      val.validateWithSchema validDates.withoutTimezone, "ISO8061Date", done

  describe 'with utc timezone', ->
    it 'should be valid', (done) ->
      val.validateWithSchema validDates.withUTCTimezone, "ISO8061Date", done

  describe 'extended with plus', ->
    it 'should be valid', (done) ->
      val.validateWithSchema validDates.extendedPlus, "ISO8061Date", done

  describe 'extended with minus', ->
    it 'should be valid', (done) ->
      val.validateWithSchema validDates.extendedMinus, "ISO8061Date", done

  describe 'with wrong year', ->
    it 'should be invalid', (done) ->
      val.validateWithSchema invalidDates.wrongYear, "ISO8061Date", (err) ->
        invalid err, done

  describe 'without wrong hour', ->
    it 'should be invalid', (done) ->
      val.validateWithSchema invalidDates.wrongHour, "ISO8061Date", (err) ->
        invalid err, done

  describe 'with wrong timezone', ->
    it 'should be invalid', (done) ->
      val.validateWithSchema invalidDates.wrongTimezone, "ISO8061Date", (err) ->
        invalid err, done

