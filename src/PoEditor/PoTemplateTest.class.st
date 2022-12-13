"
A PoTemplateTest is a test class for testing the behavior of PoTemplate
"
Class {
	#name : #PoTemplateTest,
	#superclass : #TestCase,
	#category : #'PoEditor-Tests'
}

{ #category : #private }
PoTemplateTest >> newObj [

	^ PoTemplate new
]

{ #category : #test }
PoTemplateTest >> testAddMsgIdMsgStr [

	| obj |
	obj := self newObj.
	self assert: obj entries isCollection.
	self assert: obj entries isEmpty.
	obj addMsgId: 'abc' msgStr: 'def'.
	obj addMsgId: 'ghi' msgStr: 'jkl'.
	obj addMsgId: 'abc' msgStr: 'mno'.
	self assert: obj entries first msgid equals: 'abc'.
	self assert: obj entries second msgid equals: 'ghi'.
	self assert: obj entries third msgid equals: 'abc'.
	self assert: obj entries size equals: 3
]

{ #category : #test }
PoTemplateTest >> testEntries [

	| obj m |
	obj := self newObj.
	self assert: obj entries isCollection.
	self assert: obj entries isEmpty.
	m := OrderedCollection new.
	obj entries: m.
	self assert: obj entries identicalTo: m
]

{ #category : #test }
PoTemplateTest >> testInitialize [

	| obj |
	obj := self newObj.
	self assert: obj entries isCollection.
	self assert: obj entries isEmpty
]
