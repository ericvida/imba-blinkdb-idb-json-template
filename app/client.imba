import './assets/app.css'
import {nanoid} from 'nanoid'
import {many,watch,insert,insertMany,clear,count,remove} from 'BlinkDB'
import {wordTable, db, loadLocalData, loadMemData, persist, clearData} from './db.imba'
# Uncomment for dark mode:
# import './dark-styles'
global css 
	@root 
		fs:xs
		1sp:.6em
	* rd:0.5sp
let inputWord = {
	id: nanoid!
	key: ""
	value: ""
}
# clearData()
let dictionary = loadLocalData()

# await watch(wordTable, do(words)
# 	dictionary = words
# 	imba.commit!
# )

# when adding object to dictionary
# persist(dictionary)
# await upsert(dictionary)

# run app from memory
# use localStorage for persistant between reloads
#	persist(json)
# loadLocalData on initial mount
# loadMemData on changes


tag imba-blink-app
	dictionary = loadLocalData()
	def addWord
		dictionary.push inputWord
		inputWord = {
			id: nanoid!
			key: ""
			value: ""
		}
		persist(dictionary)
		imba.commit!
	def deleteWord selectedWord
		let deleted = await remove(wordTable, selectedWord)
		L deleted
		imba.commit!
	def render
		<self>
			<h1> "hello world!"
			<h1> "Imba + BlinkDB"
			<p> "An Imba starter template with {<a href="https://blinkdb.io/"> "BlinkDB"} for blazing fast client-side data, and json file persistence"
			<p> "Useful for local projects, and practice projects."
			<input bind=query>
			<[d:hflex ja:center g:1sp]>
				<button @click.clearDictionary> "clear BlinkDB"
				<button @click.loadDictionary> "load Dictionary"
				# <button @click.saveJson> "save json"
				# <sub> dict.length
			<.adder>
				<input placeholder="word" bind=inputWord.key> 
				<input placeholder="definition" bind=inputWord.value> 
				<button @click.addWord> "add"
			<div>
				css d:hflex flw:wrap g:1sp w:200px
					p:2sp
				for dictWord in dictionary # needs to come from localStorage
					<div> 
						css d:hflex
						<.left> "key"
							css c:warmer9 fw:bold p:1sp 
								bg:warmer2
								rdr:0
						<.right> "value"
							css bg:warmer3 p:1sp pr:2sp rd:sm rdl:0
								c:warmer9
								pos:relative
							<.delete @click.deleteWord(dictWord)> "᰽"
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

imba.mount <imba-blink-app>, document.getElementById('app')