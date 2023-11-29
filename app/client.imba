import './assets/app.css'
import {nanoid} from 'nanoid'
import {many,watch,insert,insertMany,clear,count,remove} from 'BlinkDB'
import {wordTable, db} from './db.imba'
# Uncomment for dark mode:
# import './dark-styles'
global css 
	@root 
		fs:xs
		1sp:.6em
	* rd:0.5sp

tag my-first-imba-app
	inputWord = {
		id: nanoid()
		name: ""
		definition: ""
	}
	def awaken
		let json\Array = await db.loadDictionaryFromJson! # load from cheffyDB.json
		let dbCount = await count(wordTable)
		if dbCount is 0 # if BlinkDB is empty
			if json.length > 0
				await insertMany(wordTable, json) # update BlinkDB
				imba.commit!

	def addWord newWord
		if newWord.name is "" or newWord.definition is ""
			console.log "missing word or definition"
			return # don't addWord
		try
			await insert wordTable, newWord
			db.saveDictionaryToJson(state.dictionary)
			inputWord = {
				id: nanoid()
				name: ""
				definition: ""
			}
			imba.commit!
		

	def loadDictionary
		let json = await db.loadDictionaryFromJson!
		L json
		imba.commit!
	
	def clearDictionary
		await clear(wordTable)
		db.saveDictionaryToJson(state.dictionary, yes)
		imba.commit
	
	def deleteWord item
		await remove(wordTable, item)
		L 'deleting', item
		# FIXME:  When deleting multiple words, the json file is not updated after first deletion
		
	<self>
		
		<h1> "Imba + BlinkDB"
		<p> "An Imba starter template with {<a href="https://blinkdb.io/"> "BlinkDB"} for blazing fast client-side data, and json file persistence"
		<p> "Useful for local projects, and practice projects."
		
		<[d:hflex ja:center g:1sp]>
			<button @click.clearDictionary> "clear BlinkDB"
			<button @click.loadDictionary> "load Dictionary"
			# <button @click.saveJson> "save json"
			<sub> state.dictionary.length
		
		<.adder>
			<input placeholder="word" bind=inputWord.name> 
			<input placeholder="definition" bind=inputWord.definition> 
			<button @click.addWord(inputWord)> "add"
		
		<div>
			css d:hflex flw:wrap g:1sp w:200px
				p:2sp
			for item in state.dictionary
				<div> 
					css d:hflex
					<.left> item.name
						css c:warmer9 fw:bold p:1sp 
							bg:warmer2
							rdr:0
					<.right> item.definition
						css bg:warmer3 p:1sp pr:2sp rd:sm rdl:0
							c:warmer9
							pos:relative
						<.delete @click.deleteWord(item)> "᰽"
							css d:flex jc:center ai:center
								bg:warmer9 @hover:red5
								c:red5 @hover:warmer9
								cursor:pointer
								s:2.5sp
								rd:full
								p:0 m:0
								pos:absolute
								t:-1sp
								r:-1sp

imba.mount <my-first-imba-app>, document.getElementById('app')
