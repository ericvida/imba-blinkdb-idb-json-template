import express from 'express'
import cheffy from './app/vendor/cheffyDB.js' # modified to save pretty json.
import index from './app/index.html'
# Using Imba with Express as the server is quick to set up:
const app = express()
const port = process.env.PORT or 3000

# Express works like usual, so we can allow JSON in the POST request:
const jsonBody = express.json({ limit: '20kb' })
app.post('/saveDictionary', jsonBody, do(req,res)
	cheffy.set("dictionary", req.body)
	return req.body
)

app.get('/loadDictionary') do(req,res)
	let dictionary = await cheffy.get("dictionary")
	res.send dictionary

# catch-all route that returns our index.html
app.get(/.*/) do(req,res)
	# only render the html for requests that prefer an html response
	unless req.accepts(['image/*', 'html']) == 'html'
		return res.sendStatus(404)

	res.send(index.body)

# Express is set up and ready to go!
imba.serve(app.listen(port))
