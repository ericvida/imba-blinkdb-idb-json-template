import express from 'express'
import index from './app/index.html'
import {bodyParser} from 'body-parser'
# https://www.npmjs.com/package/simple-json-db
import SimpleJsonDb from 'simple-json-db'
let simple = new SimpleJsonDb('./app/JSON/backup.json')

# Using Imba with Express as the server is quick to set up:
const app = express()
# app.use(bodyParser.json({limit: '50mb'}));
# app.use(bodyParser.urlencoded({limit: '50mb', extended: true}));
const port = process.env.PORT or 3000

# Express works like usual, so we can allow JSON in the POST request:
const jsonBody = express.json({ limit: '50mb' })
app.post('/save_words', jsonBody, do(req,res)
	try
		let state = req.body
		await simple.set('words', state.words)
		return req.body
	catch err
		console.error err
)

app.post('/delete', jsonBody, do(req,res)
	try
		L 'deleting', req.body
		await simple.delete(req.body)
		return req.body
	catch err
		console.error err
)

app.get('/load_words') do(req,res)
	try
		let words = await simple.get('words')
		res.send {words}
	catch err
		console.error err

# catch-all route that returns our index.html
app.get(/.*/) do(req,res)
	# only render the html for requests that prefer an html response
	unless req.accepts(['image/*', 'html']) == 'html'
		return res.sendStatus(404)

	res.send(index.body)

# Express is set up and ready to go!
imba.serve(app.listen(port))
