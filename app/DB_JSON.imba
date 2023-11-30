
class JSONDB
	def loadWords
		# NOTE: loads Words from Json
		# NOTE: add try catch for other datasets and add corresponding http get request.
		try
			const res = await window.fetch('/loadWords')
			let data = await res.json()
			# L 'loaded', data
			return data

		
	def setWords
		L 'attempt save json', APP.words
		# NOTE: one-directionally saves words to Json
		# NOTE: add try catch for other datasets and add corresponding http post request.
		try
			let res = await window.fetch('/setWords', {
				method: 'POST'
				headers: {
					'Content-Type': 'application/json'
				}
				body: JSON.stringify(APP.words)
			})
			let data = await res.json()
			# L data, 'saved to json successfully'
			return data
		catch e
			console.log 'error saving words to json', e
global.JSONDB = new JSONDB