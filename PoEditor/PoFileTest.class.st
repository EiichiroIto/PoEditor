"
A PoFileTest is a test class for testing the behavior of PoFile
"
Class {
	#name : #PoFileTest,
	#superclass : #TestCase,
	#category : #'PoEditor-Tests'
}

{ #category : #private }
PoFileTest >> newObj [

	^ PoFile new
]

{ #category : #test }
PoFileTest >> testAddMsgIdMsgStr [

	| obj |
	obj := self newObj.
	self assert: obj entries isCollection.
	self assert: obj entries isEmpty.
	obj addMsgId: 'abc' msgStr: 'def'.
	obj addMsgId: 'ghi' msgStr: 'jkl'.
	obj addMsgId: 'abc' msgStr: 'mno'.
	self assert: (obj entries first msgstr) equals: 'def'.
	self assert: (obj entries second msgstr) equals: 'jkl'.
	self assert: (obj entries third msgstr) equals: 'mno'.
	self assert: obj entries size equals: 3
]

{ #category : #test }
PoFileTest >> testEmptyMsgids [

	| obj r |
	obj := self newObj.
	obj addMsgId: 'abc' msgStr: 'def'.
	obj addMsgId: 'ghi' msgStr: ''.
	obj addMsgId: 'jkl' msgStr: 'mno'.
	r := obj emptyMsgids.
	self assert: r size equals: 1.
	self assert: r first msgid equals: 'ghi'.
	obj addMsgId: 'pqr' msgStr: ''.
	r := obj emptyMsgids.
	self assert: r size equals: 2.
	self assert: r first msgid equals: 'ghi'.
	self assert: r second msgid equals: 'pqr'
]

{ #category : #test }
PoFileTest >> testEntries [

	| obj d |
	obj := self newObj.
	self assert: obj entries isCollection.
	self assert: obj entries isEmpty.
	d := OrderedCollection new.
	obj entries: d.
	self assert: obj entries identicalTo: d
]

{ #category : #test }
PoFileTest >> testInitialize [

	| obj |
	obj := self newObj.
	self assert: obj entries isCollection.
	self assert: obj entries isEmpty
]
