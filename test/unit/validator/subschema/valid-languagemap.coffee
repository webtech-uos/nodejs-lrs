assert = require "assert"
Validator = require "../../../../app/validator/validator.coffee"
util = require "util"

val = new Validator 'app/validator/schemas/'

valid = (err, done) ->
  if err?
    done(new Error(util.inspect(err)))
  else
    done()

simpleMap =
  "de": "(German)"
  "fr": "(French)"
  "ja": "(Japanese)"
  "i-enochian": "(example of a grandfathered tag)"

withSubtags =
  "zh-Hant": "(Chinese written using the Traditional Chinese script)"
  "zh-Hans": "(Chinese written using the Simplified Chinese script)"
  "sr-Cyrl": "(Serbian written using the Cyrillic script)"
  "sr-Latn": "(Serbian written using the Latin script)"

extendedTagsAndPrimary =
  "zh-cmn-Hans-CN": "(Chinese, Mandarin, Simplified script, as used in China)"
  "cmn-Hans-CN": "(Mandarin Chinese, Simplified script, as used in China)"
  "zh-yue-HK": "(Chinese, Cantonese, as used in Hong Kong SAR)"
  "yue-HK": "(Cantonese Chinese, as used in Hong Kong SAR)"  

withRegion = 
  "zh-Hans-CN": "(Chinese written used in mainland China)"
  "sr-Latn-RS": "(Serbian written using the Latin script as used in Serbia)"
      
languageVariant =
  "sl-rozaj": "(Resian dialect of Slovenian)"
  "sl-rozaj-biske": "(San Giorgio dialect of Resian dialect of Slovenian)"
  "sl-nedis": "(Nadiza dialect of Slovenian)"

languageRegionVariant = 
  "de-CH-1901": "(German as used in Switzerland using the 1901 variant [orthography])"
  "sl-IT-nedis": "(Slovenian as used in Italy, Nadiza dialect)"

languageScriptRegionVariant =
  "hy-Latn-IT-arevela": "(Eastern Armenian written in Latin script, as used in Italy)"

languageRegion =
  "de-DE": "(German for Germany)"
  "en-US": "(English as used in the United States)"
  "es-419": "(Spanish appropriate for the Latin America and Caribbean region using the UN region code)"

privateUseSubtags =
  "de-CH-x-phonebk" : "privat"
  "az-Arab-x-AZE-derbend" : "privat"

privateUseRegistryValues =
  "x-whatever": "(private use using the singleton 'x')"
  "qaa-Qaaa-QM-x-southern": "(all private tags)"
  "de-Qaaa": "(German, with a private script)"
  "sr-Latn-QM": "(Serbian, Latin script, private region)"
  "sr-Qaaa-RS": "(Serbian, private script, for Serbia)"

describe 'LanguageMap', ->
  
  describe 'with simple tags', ->
    it 'should be valid', (done) ->
      val.validateWithSchema simpleMap, "LanguageMap", (err) ->
        valid err, done
  
  describe 'with subtags', ->
    it 'should be valid', (done) ->
      val.validateWithSchema withSubtags, "LanguageMap", (err) ->
        valid err, done
  
  describe 'with extended tags and primary language', ->
    it 'should be valid', (done) ->
      val.validateWithSchema extendedTagsAndPrimary, "LanguageMap", (err) ->
        valid err, done
  
  describe 'with region', ->
    it 'should be valid', (done) ->
      val.validateWithSchema withRegion, "LanguageMap", (err) ->
        valid err, done
  
  describe 'with language variant', ->
    it 'should be valid', (done) ->
      val.validateWithSchema languageVariant, "LanguageMap", (err) ->
        valid err, done
  
  describe 'with language variant and region', ->
    it 'should be valid', (done) ->
      val.validateWithSchema languageRegionVariant, "LanguageMap", (err) ->
        valid err, done
  
  describe 'with language script, variant and region', ->
    it 'should be valid', (done) ->
      val.validateWithSchema languageScriptRegionVariant, "LanguageMap", (err) ->
        valid err, done
  
  describe 'with language region', ->
    it 'should be valid', (done) ->
      val.validateWithSchema languageRegion, "LanguageMap", (err) ->
        valid err, done
  
  describe 'with private use subtags', ->
    it 'should be valid', (done) ->
      val.validateWithSchema privateUseSubtags, "LanguageMap", (err) ->
        valid err, done
  
  describe 'with private use registry values', ->
    it 'should be valid', (done) ->
      val.validateWithSchema privateUseRegistryValues, "LanguageMap", (err) ->
        valid err, done
  
  
  
      