"
A PoAbstractFileTest is a test class for testing the behavior of PoAbstractFile
"
Class {
	#name : #PoAbstractFileTest,
	#superclass : #TestCase,
	#category : #'PoEditor-Tests'
}

{ #category : #private }
PoAbstractFileTest >> newObj [

	^ PoAbstractFile new
]

{ #category : #test }
PoAbstractFileTest >> testUnquoteString [

	| obj r |
	obj := self newObj.
	r := obj unquoteString: 'abc'.
	self assert: r equals: 'abc'.
	r := obj unquoteString: '  abc  '.
	self assert: r equals: 'abc'.
	r := obj unquoteString: '"abc'.
	self assert: r equals: 'abc'.
	r := obj unquoteString: '   "abc'.
	self assert: r equals: 'abc'.
	r := obj unquoteString: 'abc"'.
	self assert: r equals: 'abc'.
	r := obj unquoteString: 'abc"   '.
	self assert: r equals: 'abc'.
	r := obj unquoteString: '"abc"'.
	self assert: r equals: 'abc'
]
