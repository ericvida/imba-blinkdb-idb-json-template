### TODO:
[ ] Add session persistence via IndexedDB instead
[ ] and manual json load and backup
###
import 'imba/preflight.css'
import {normalizeText as normalize} from 'normalize-text'
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
import './API.imba'

tag offline-dictionary
	# NOTE: EXPERIMENTAL BELOW
	@observable editWord = {}
	@observable wordQuery = ""
	@observable definitionQuery = ""
	@autorun def search
		if wordQuery isnt ""
			if definitionQuery isnt ""
				### NOTE
				if both word & definition queries are full
				search match for both
				###
				APP.filtered_words = APP.words.filter do 
					if normalize($1.definition).includes normalize(definitionQuery)
						normalize($1.name).includes normalize(wordQuery)
			else
				### NOTE
				if wordQuery is full
				search match for wordQuery only
				###
				APP.filtered_words = APP.words.filter(do normalize($1.name).includes normalize(wordQuery))
		elif definitionQuery isnt ""
			### NOTE
			if word query is not full
			and only definition query is full
			search by definition query only
			###
			APP.filtered_words = APP.words.filter(do normalize($1.definition).includes normalize(definitionQuery))
		else
			### NOTE
			if word & def query are empty
			show all words
			###
			APP.filtered_words = APP.words
		imba.commit!
		
	# NOTE: EXPERIMENTAL ABOVE
	def clearAll
		L 'clear not setup'
		APP.clearAll!
		imba.commit!
	def addOrSaveWord
		if editWord.id is undefined
			addWord!
		else
			saveWordEdit!
			L 'edit saved'
	def addWord
		newWord = {
			id: nanoid!
			stamp: stampString!
			name: wordQuery
			definition: definitionQuery
		}
		# L 'clicked addWord', newWord
		APP.addWord newWord
		wordQuery = ""
		definitionQuery = ""
	def updateWord word
		L 'updateWord not set up'
	def activateWordEdit word
		editWord = word
		wordQuery = word.name
		definitionQuery = word.definition
		imba.commit!
	def saveWordEdit
		newWord = {
			id: editWord.id
			stamp: stampString!
			name: wordQuery
			definition: definitionQuery
		}
		APP.updateWord newWord
		editWord = {}
		wordQuery = ""
		definitionQuery = ""
	def removeWord word
		APP.remove(word)
	def stampString
		Date.now!.toString!
	def render
		<self>
			css p:3sp
				bg:cool1
				c:cool9
				d:vflex g:1sp
				mih:100vh
			<h1> "Imba + BlinkDB + JSON Persistence"
				css fs:4xl
					fw:bold
					ff:sans
			<p> "A starter template for incredibly fast offline web-apps {<br>} with session persistence via JSON and manual JSON data backup."
				css mb:4sp
			<div>
				css d:hflex g:1sp jc:end w:100%
				# <button @click.saveJson> "backup to JSON"
				# <button @dblclick.loadJson> "restore from JSON (dblclick)"
				<button @dblclick.clearAll> "Clear All Data (double click)"
					css bg:red1 @hover:red2 @active:red6
						c@hover:red9
			<div>
				css d:hflex g:1sp
				<div>
					css d:vflex g:1sp flg:1
						input
							px:1sp
							py:1sp
					<input bind=wordQuery @keydown.enter.addOrSaveWord
					placeholder="new word | search">
					<input bind=definitionQuery @keydown.enter.addOrSaveWord placeholder="definition | search">
					
					# FIXME: Clicking on Add Button doesn't have same effect as hitting Enter.
					if editWord.id is undefined
						<button @click.addOrSaveWord> 
							css h:100%
								w:150px
								bg:hue5 @hover:hue4 @active:hue6
								c:hue0
								as:flex-end
								fs:sm
							"add"
					else
						<button @click.addOrSaveWord> 
							css h:100%
								w:150px
								hue:emerald
								bg:hue5 @hover:hue4 @active:hue6
								c:hue0
								as:flex-end
								fs:sm
							"save"
			<div> "{APP.filtered_words.length} words"
			for word in APP.filtered_words
				<%card> 
					css d:vflex g:1sp
						bg:white p:2sp
						pos:relative
					<.id> word.id
						css fs:xxs c:gray2
					<.info>
						<h3> word.name
							css fw:bold
						<p> word.definition
					# TODO: Make button to edit
					<.button-group>
						css pos:absolute
							t:1sp r:1sp
							d:hflex g:1sp
							button
								bd:1px solid gray2
						<button @click.activateWordEdit(word)> "✏️"
						<button @dblclick.removeWord(word)> "x"

imba.mount <offline-dictionary>, document.getElementById('app')