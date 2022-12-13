"
A PoEmptyMsgstrTest is a test class for testing the behavior of PoEmptyMsgstr
"
Class {
	#name : #PoEmptyMsgstrTest,
	#superclass : #TestCase,
	#traits : 'TNewPoData',
	#classTraits : 'TNewPoData classTrait',
	#category : #'PoEditor-Tests'
}

{ #category : #private }
PoEmptyMsgstrTest >> newObj [

	^ PoEmptyMsgstr basicNew initialize
]

{ #category : #test }
PoEmptyMsgstrTest >> testAdoptToEmpty [

	| obj a b |
	obj := self newObj.
	obj msgid: 'abc'.
	a := self newEmpty: 'abc'.
	b := obj adoptToEmpty: a.
	self assert: b identicalTo: obj.
	a := self newEmpty: 'def'.
	self should: [ obj adoptToEmpty: a ] raise: Error
]

{ #category : #test }
PoEmptyMsgstrTest >> testAdoptToMulti [

	| obj a b |
	obj := self newObj.
	obj msgid: 'abc'.
	a := self newMulti: 'abc' msgstrs: #( a b ).
	b := obj adoptToMulti: a.
	self assert: b identicalTo: a.
	a := self newMulti: 'def' msgstrs: #( a b ).
	self should: [ obj adoptToMulti: a ] raise: Error
]

{ #category : #test }
PoEmptyMsgstrTest >> testAdoptToNormal [

	| obj a b |
	obj := self newObj.
	obj msgid: 'abc'.
	a := self newNormal: 'abc' msgstr: 'def'.
	b := obj adoptToNormal: a.
	self assert: b identicalTo: a.
	a := self newNormal: 'ghi' msgstr: 'def'.
	self should: [ obj adoptToNormal: a ] raise: Error
]

{ #category : #test }
PoEmptyMsgstrTest >> testDeleted [

	| obj |
	obj := self newObj.
	self deny: obj deleted.
	obj deleted: true.
	self assert: obj deleted.
	obj deleted: false.
	self deny: obj deleted
]

{ #category : #test }
PoEmptyMsgstrTest >> testEqualsSign [

	| a b |
	a := self newObj.
	a msgid: 'abc'.
	b := self newObj.
	b msgid: 'abc'.
	self assert: a equals: b.
	b := self newObj.
	b msgid: 'def'.
	self deny: a equals: b
]

{ #category : #test }
PoEmptyMsgstrTest >> testHasError [

	| obj |
	obj := self newObj.
	self deny: obj hasError.
	obj hasError: true.
	self assert: obj hasError
]

{ #category : #test }
PoEmptyMsgstrTest >> testInitialize [

	| obj |
	obj := self newObj.
	self deny: obj deleted
]

{ #category : #test }
PoEmptyMsgstrTest >> testIsEmptyMsgstr [

	self assert: self newObj isEmptyMsgstr
]

{ #category : #test }
PoEmptyMsgstrTest >> testIsMultiMsgstrs [

	self deny: self newObj isMultiMsgstrs
]

{ #category : #test }
PoEmptyMsgstrTest >> testIsValid [

	self deny: self newObj isValid
]

{ #category : #test }
PoEmptyMsgstrTest >> testMsgid [

	| obj |
	obj := self newObj.
	self assert: obj msgid isNil.
	obj msgid: 'abc'.
	self assert: obj msgid equals: 'abc'.
	self should: [ obj msgid: 'ghi' ] raise: Error
]

{ #category : #test }
PoEmptyMsgstrTest >> testMsgstr [

	self assert: self newObj msgstr isEmpty
]

{ #category : #test }
PoEmptyMsgstrTest >> testMsgstrForEditing [

	| obj r |
	obj := self newObj.
	obj msgid: 'abc'.
	r := obj msgstrForEditing.
	self assert: r equals: 'abc'
]

{ #category : #test }
PoEmptyMsgstrTest >> testPlus [

	| obj a b |
	obj := self newObj.
	obj msgid: 'abc'.
	a := self newEmpty: 'abc'.
	b := obj + a.
	self assert: b identicalTo: a.
	a := self newEmpty: 'def'.
	self should: [ obj + a ] raise: Error.
	a := self newMulti: 'abc' msgstrs: #( a b ).
	b := obj + a.
	self assert: b identicalTo: a.
	a := self newMulti: 'def' msgstrs: #( a b ).
	self should: [ obj + a ] raise: Error.
	a := self newNormal: 'abc' msgstr: 'def'.
	b := obj + a.
	self assert: b identicalTo: a.
	a := self newNormal: 'ghi' msgstr: 'def'.
	self should: [ obj + a ] raise: Error
]

{ #category : #test }
PoEmptyMsgstrTest >> testPrintOn [

	| obj s |
	obj := self newObj.
	s := WriteStream on: String new.
	obj printOn: s.
	self assert: s contents equals: '<nil>'.
	obj msgid: 'abc'.
	s := WriteStream on: String new.
	obj printOn: s.
	self assert: s contents equals: '<abc>'.
	obj deleted: true.
	s := WriteStream on: String new.
	obj printOn: s.
	self assert: s contents equals: '<*abc>'
]

{ #category : #test }
PoEmptyMsgstrTest >> testWithMsgstr [

	| obj r |
	obj := self newObj.
	obj msgid: 'abc'.
	r := obj withMsgstr: 'def'.
	self assert: (r isKindOf: PoNormalEntry).
	self assert: r msgid equals: 'abc'.
	self assert: r msgstr equals: 'def'.
	obj := self newObj.
	obj msgid: 'abc'.
	r := obj withMsgstr: ''.
	self assert: r identicalTo: obj
]

{ #category : #test }
PoEmptyMsgstrTest >> testWriteOn [

	| obj s |
	obj := self newObj.
	s := WriteStream on: String new.
	obj writeOn: s.
	self
		assert: s contents
		equals: 'msgid "nil"' , String crlf , 'msgstr ""' , String crlf.
	obj msgid: 'abc'.
	s := WriteStream on: String new.
	obj writeOn: s.
	self
		assert: s contents
		equals: 'msgid "abc"' , String crlf , 'msgstr ""' , String crlf.
	obj deleted: true.
	s := WriteStream on: String new.
	obj writeOn: s.
	self
		assert: s contents
		equals: '#msgid "abc"' , String crlf , '#msgstr ""' , String crlf
]
