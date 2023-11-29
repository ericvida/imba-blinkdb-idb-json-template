let state = {
	dictionary: []
}
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
import {nanoid} from 'nanoid'
let BDB = createDB();
export let wordTable = createTable(BDB, "words")();

# await insertMany(wordTable, [
# 	{ id: nanoid!, word: "hello", definition: "used as a greeting or to begin a telephone conversation." },
# 	{ id: nanoid!, word: "world", definition: "the earth, together with all of its countries and peoples." },
# ])


class BlinkDB
	def loadDictionaryFromJson
		# NOTE: loads Words from Json
		# NOTE: add try catch for other datasets and add corresponding http get request.
		try
			const res = await window.fetch('/loadDictionary')
			let data = await res.json()
			return data
	
	def saveDictionaryToJson newDictionary, force = no
		# NOTE: saves words to Json
		# NOTE: add try catch for other datasets and add corresponding http post request.
		if newDictionary.length > 0
			L 'forcing to save empty json'
			force = yes
		if force
			try
				let res = await window.fetch('/saveDictionary', {
					method: 'POST'
					headers: {
						'Content-Type': 'application/json'
					}
					body: JSON.stringify(newDictionary)
				})
				let data = await res.json()
				L data, 'saved to json successfully'
			catch e
				console.log 'error saving words to json', e
		else
			console.log 'no words to save to json'

export let db = new BlinkDB(wordTable)

let dispose = await watch wordTable, {}, do(dictionary)
	state.dictionary = dictionary
	db.saveDictionaryToJson(dictionary)
	imba.commit!


extend tag Element
	get state
		return state
	get db
		return db
