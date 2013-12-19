fs = require 'fs'
cradle = require 'cradle'

dbHost = "http://localhost"
dbName = "wt2"


readFile= (fileName) ->
  
  	fs.readFileSync fileName, 'utf8'


createDB= ->
	
	conn = new (cradle.Connection)(dbHost, 5984,
  		cache: true
 	 	raw: false
		)
	
	db = conn.database dbName
	
	db.exists (err, exists) ->
		
		if err 
		
			console.log "error " + err
		
		else if exists
			
			console.log "database " + dbName + " exists, data and views will not be imported"
			
		else
			
			console.log "create db " + dbName
			
			db.create()
			
			console.log "import sample data"
			
			db.save JSON.parse (readFile('example_data.json'))
			
			console.log 'import views'
			db.save '_design/find_by', JSON.parse (readFile('views_find_by.json'))
			

# start the process:
createDB()
