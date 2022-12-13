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
PoAbstractFileTest >> testParametersOf [

	| obj |
	obj := self newObj.
	self assertCollection: (obj parametersOf: 'abc %n') equals: #( '%n' ).
	self
		assertCollection: (obj parametersOf: 'abc %n    def %s')
		equals: #( '%n' '%s' ).
	self
		assertCollection: (obj parametersOf: 'abc%n1def%s23gh')
		equals: #( '%n1' '%s23' ).
	self
		assertCollection: (obj parametersOf: 'abc% def%')
		equals: #()
]

{ #category : #test }
PoAbstractFileTest >> testParseCommandSpec [

	| obj |
	obj := self newObj.
	self
		assertCollection: (obj parseCommandSpec: 'abc %n')
		equals: #( abc '%n' ).
	self
		assertCollection: (obj parseCommandSpec: 'abc %n    def %s')
		equals: #( abc '%n' def '%s' ).
	self
		assertCollection: (obj parseCommandSpec: 'abc%n1def%s23gh')
		equals: #( abc '%n1' def '%s23' gh ).
	self
		assertCollection: (obj parseCommandSpec: 'abc% def%')
		equals: #( abc '%' def '%' )
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
