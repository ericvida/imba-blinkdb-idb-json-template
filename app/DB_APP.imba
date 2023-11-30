import {
	use,
	clear,
	watch,
	isAction
} from "blinkdb";
class APPDB
	# NOTE: render words from APP.words
	words = []
	filtered_words = words
	def constructor
		watch(BLINK.wordsTable, do() 
			words = $1
			INDB.setWords(words)
			imba.commit!
		)
		# clear
		use(BLINK.wordsTable) do(ctx)
			if isAction(ctx, "clear")
				L 'user did BLINK.clear()'
				INDB.clear()
				sync!
			let result = await ctx.next(...ctx.params)
			imba.commit!
			return result

	def clear
		BLINK.clear!
		INDB.clear!
		# TODO: JSON.clear!
		await sync!
	def sync
		INDB.setWords
		words = filtered_words = await INDB.loadWords! # getting populated array from index
		
	def trickleDown
		filtered_words = words
		INDB.setWords words
		BLINK.clear()
		BLINK.insertMany words
		imba.commit!

# initialize APP.words from INDB.
global.APP = new APPDB
APP.sync!
# NOTE: initiate words and filtered_words from IndexedDB.