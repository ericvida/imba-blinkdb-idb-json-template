import {openDB, insert, get, update, deleteKeyValue,set} from 'idbkeyvalue'

export class INDB
	def setWords data
		set('words', data)
	def loadWords
		let retrievedValue = await get('words')
		return retrievedValue
	def updateWords data
		update('words', data)
	def clear
		set('words', [])
	def upsertWords data
		set('words', data)
global.INDB = new INDB
