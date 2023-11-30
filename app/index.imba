import 'imba/preflight.css'
global css 
	@root 
		fs:sm
		1sp:.6em
		ff:sans
		hue:indigo
	button
		p:1sp
		bg:white @hover:hue1 @active:hue3
		c:cool8 @hover:hue8
	* rd:0.5sp
import {nanoid} from 'nanoid'
import './DB_INDB'
import './DB_BLINK'
import './DB_JSON'
import './DB_APP'

tag offline-dictionary
	# NOTE: EXPERIMENTAL BELOW
	@observable wordQuery = ""
	@observable definitionQuery = ""
	@autorun def search
		if wordQuery isnt ""
			if definitionQuery isnt ""
				APP.filtered_words = APP.words.filter(do(word) 
					word.name.includes wordQuery and word.definition.includes definitionQuery)
			APP.filtered_words = APP.words.filter(do(word) 
				word.name.includes wordQuery)
		elif definitionQuery isnt ""
				APP.filtered_words = APP.words.filter(do(word) 
					word.name.includes definitionQuery)
		else
			APP.filtered_words = APP.words
		imba.commit!
	# NOTE: EXPERIMENTAL ABOVE
	def clear
		APP.clear!
		APP.sync!
		imba.commit!
	def addWord
		newWord = {
			id: nanoid()
			name: wordQuery
			definition: definitionQuery
		}
		BLINK.insert newWord
		wordQuery = ""
		definitionQuery = ""
		
	def removeWord word
		BLINK.remove(word)
		imba.commit!
		
	def saveJson
		JSONDB.setWords!
	
	def loadJson
		L await JSONDB.loadWords!
		
	def render
		<self>
			css p:3sp
				bg:cool1
				c:cool9
				d:vflex g:1sp
				mih:100vh
			<h1> "Imba + BlinkDB + IndexedDB + JSON"
				css fs:4xl
					fw:bold
					ff:sans
			<p> "A starter template for incredibly fast offline web-apps {<br>} with session persistence via IndexedDB and manual JSON data backup."
				css mb:4sp
			<div>
				css d:hflex g:1sp
				
				<button @dblclick.saveJson> "backup to JSON"
				<button @dblclick.loadJson> "restore from JSON"
				<button @dblclick.clear> "Double CLick to Clear Client Data"
					css bg@hover:red1 @active:red3
						c@hover:red8
			<div>
				css d:hflex g:1sp
				<div>
					css d:vflex g:1sp flg:1
						input
							px:1sp
							py:1sp
					<input bind=wordQuery @keydown.enter=addWord placeholder="new word | search">
					<input bind=definitionQuery @keydown.enter=addWord placeholder="definition">
					<button @dblclick.addWord> 
						css h:100%
							w:150px
							bg:hue5 @hover:hue4 @active:hue6
							c:hue0
							as:flex-end
							fs:sm
						"add"
				<div>
			<div>
			for word in APP.filtered_words
				<%card @dblclick.removeWord(word)> 
					css d:vflex g:1sp
						bg:white p:2sp
						pos:relative
					<.id> word.id
						css fs:xxs c:gray2
					<info>
						<h3> word.name
							css fw:bold
						<p> word.definition
					# TODO: Make button to edit
					<button> "✏️"
						css pos:absolute
							p:0
							r:1sp
							t:1sp
							bg@hover:hue1
							cursor:pointer
							bd:2px solid hue1
							s:3sp
							d:flex jac:center

imba.mount <offline-dictionary>, document.getElementById('app')