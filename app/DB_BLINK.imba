import {
	clear,
	count,
	createDB,
	createTable,
	first,
	insert,
	insertMany,
	key,
	many,
	one,
	remove,
	removeMany, 
	removeWhere, 
	update,
	updateMany,
	updateWhere,
	upsert,
	upsertMany,
	use,
	watch,
	isAction,
	isValidEntity,
	uuid
} from "blinkdb";


let blinkDB = createDB()
class BLINKDB
	def constructor
		persist!
	def persist
		# NOTE: experimental
		wordsTable = createTable(blinkDB, "words")()
		await insertMany wordsTable, await INDB.loadWords() 
	def clear
		await clear(wordsTable)
	def count
		L "count"
		count(wordsTable)
	def createDB
		L "createDB"
	def createTable
		L "createTable"
	def first
		L "first"
	def insert wordObject
		await insert(wordsTable, wordObject )
	def insertMany wordsArray
		await insertMany(wordsTable, wordsArray )
	def key
		L "key"
	def many query
		# NOTE: SEE FILTERS https://blinkdb.io/docs/filters
		await many(wordsTable, query)
		
	def one
		L "one"
	def remove wordObject # EXAMPLE: {id:"alice-uuid}
		await remove(wordsTable, wordObject)
		imba.commit!
	def removeMany wordsArray # EXAMPLE: [{id:"alice-uuid},{id:"ecila-uuid}]
		await remove(wordsTable, wordsArray)
		L "removeMany"
	def removeWhere
		L "removeWhere"
	def update
		L "update"
	def updateMany
		L "updateMany"
	def updateWhere
		L "updateWhere"
	def upsert
		L "upsert"
		await upsert(wordsTable, wordObject )
	def upsertMany
		L "upsertMany"
	def use
		L "use"
	def watch
		L "watch"
	def isAction
		L "isAction"
	def isValidEntity
		L "isValidEntity"
	def uuiD
		L "uuid"

global.BLINK = new BLINKDB
