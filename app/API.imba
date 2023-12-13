import JSON_FILE from './JSON/backup.json'
import {openDB, insert as IDBinsert, get as IDBget} from 'idbkeyvalue'
openDB()
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

# FIXME: replace with Imba native syntax when available
### @ts 
interface Word {
	id: string;
	stamp: string;
	name: string;
	definition?: string;
}
###

class APPDB
	# NOTE: render words from APP.words
	# wordsTable = createTable(blinkDB, "words")()
	wordsTable = createTable<Word>(blinkDB, "words")()
	words = []
	filtered_words = []
	
	def constructor
		### INFO:
		The Phylosophy is that all crud operations are done first on BlinkDB and then pushed to APP state and persisted to JSON.
		First time the app is loaded, it checks if there is any data in BlinkDB and if not, it loads data from JSON and also pushes it to the client APP state. (APP.words and APP.filtered_words)
		###
		initFromJson!
	# def loadJSON
	# 	### INFO:
	# 	manually loads JSON to IDB
	# 	###
		
		
	def initFromJson
		### INFO: 
		If app state (words,stamp) is new
		and blinkDB is empty
		update both from JSON
		###
		# let fromIDB = 
		# L fromIDB
		
		
		let idb_words = {}
		if idb_words.length is 0
			IDBinsert('words', JSON_FILE.words)
		else
			idb_words = await IDBget('words')
		# let json = await fromJSON!
		# INFO: update blinkDB from JSON
		insertMany(wordsTable, idb_words)
		# INFO: update APP.words from JSON
		words = idb_words
		# INFO: update APP.filtered_words sorted by BlinkDB
		filtered_words = await many(wordsTable, {
			sort: {
				key: 'name'
				order: 'asc'
			}
		})
		imba.commit!
		
	def remove wordObject
		L 'removed', wordObject.id
		await remove(wordsTable, {id: wordObject.id})
		persistBlink!
		imba.commit!
	
	def clearAll
		### NOTE
		deletes contents of BlinkDB wordsTable
		and commites changes to APP.words and APP.filtered_words
		and persists to JSON
		###
		await clear(wordsTable)
		persistBlink!
	
	def addWord newWord
		### NOTE
		1. insert new word to BlinkDB
		2. sorts by stamp from newest to oldest so first word can be used to check latest update of db
		3. save to JSON in same sorting (new to oldest)
		###
		await insert(wordsTable, newWord) 
		persistBlink! # persists blink to APP.words APP.filtered_words & idb_words
	def updateWord editWord
		await upsert(wordsTable, editWord)
		persistBlink! # persists blink to APP.words APP.filtered_words & idb_words
		
	def persistBlink # persists blink to APP.words & idb_words
		# NOTE: APP.words are sorted by timestamp from new to old, to be stored in json that way as well. That way idb_words[1].stamp shows time of the last update to the json file.
		words = await many(wordsTable, {
			sort: {
				key: 'stamp'
				order: 'desc'
			}
		})
		# NOTE: Filtered words are sorted by name.
		# filtered words are only client side, for displaying words in UI, and reflect search queries.
		filtered_words = await many(wordsTable, {
			sort: {
				key: 'name'
				order: 'asc'
			}
		})
		
		# NOTE persist words to indexedDB
		# save to indexedDB
		IDBinsert('words', words)
		L await IDBget('words')
		
		# # NOTE: persists words to JSON after Blink>words
		# try 
		# 	let res = await window.fetch('/save_words', {
		# 		method: 'POST'
		# 		headers: {
		# 			'Content-Type': 'application/json'
		# 		}
		# 		body: JSON.stringify {words}
		# 	})
		# catch e
		# 	console.error 'error', e
		imba.commit!
	def fromJSON
		### NOTE: 
		returns data from JSON
		###
		# const res = await window.fetch('/load_words')
		let data = JSON_FILE
		imba.commit!
		return data
	
	def lastJsonWordsUpdate
		let json = await fromJSON!
		return idb_words[1].stamp
	
	def saveToJson
		try
			let res = await window.fetch('/save_words', {
				method: 'POST'
				headers: {
					'Content-Type': 'application/json'
				}
				body: JSON.stringify {words}
			})
		catch e
			console.error 'error', e
global.APP = new APPDB
# NOTE: initiate words and filtered_words from IndexedDB.