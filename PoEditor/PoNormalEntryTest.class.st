"
A PoEntryTest is a test class for testing the behavior of PoEntry
"
Class {
	#name : #PoNormalEntryTest,
	#superclass : #TestCase,
	#traits : 'TNewPoData',
	#classTraits : 'TNewPoData classTrait',
	#category : #'PoEditor-Tests'
}

{ #category : #private }
PoNormalEntryTest >> newObj [

	^ PoNormalEntry basicNew initialize
]

{ #category : #test }
PoNormalEntryTest >> testAdoptToEmpty [

	| obj a b |
	obj := self newObj.
	obj msgid: 'abc'.
	obj msgstr: 'def'.
	a := self newEmpty: 'abc'.
	b := obj adoptToEmpty: a.
	self assert: b identicalTo: obj.
	a := self newEmpty: 'def'.
	self should: [ obj adoptToEmpty: a ] raise: Error
]

{ #category : #test }
PoNormalEntryTest >> testAdoptToMulti [

	| obj a b |
	obj := self newObj.
	obj msgid: 'abc'.
	obj msgstr: 'def'.
	a := self newMulti: 'abc' msgstrs: #( b c ).
	b := obj adoptToMulti: a.
	self assert: (b isKindOf: PoMultiMsgstrs).
	self assert: b msgid equals: 'abc'.
	self assertCollection: b msgstrs asArray hasSameElements: #( b c def ).
	a := self newMulti: 'def' msgstrs: #( b c ).
	self should: [ obj adoptToMulti: a ] raise: Error
]

{ #category : #test }
PoNormalEntryTest >> testAdoptToNormal [

	| obj a b |
	obj := self newObj.
	obj msgid: 'abc'.
	obj msgstr: 'def'.
	a := self newNormal: 'abc' msgstr: 'def'.
	b := obj adoptToNormal: a.
	self assert: b identicalTo: obj.
	a := self newNormal: 'abc' msgstr: 'a'.
	b := obj adoptToNormal: a.
	self assert: (b isKindOf: PoMultiMsgstrs).
	self assert: b msgid equals: 'abc'.
	self assertCollection: b msgstrs asArray hasSameElements: #( a def ).
	a := self newNormal: 'def' msgstr: 'a'.
	self should: [ obj adoptToNormal: a ] raise: Error
]

{ #category : #test }
PoNormalEntryTest >> testEqualsSign [

	| a b |
	a := self newObj.
	a msgid: 'abc'.
	a msgstr: 'def'.
	b := self newObj.
	b msgid: 'abc'.
	b msgstr: 'def'.
	self assert: a equals: b.
	b := self newObj.
	b msgid: 'ghi'.
	b msgstr: 'def'.
	self deny: a equals: b.
	a := self newObj.
	a msgid: 'ghi'.
	a msgstr: 'def'.
	self assert: a equals: b.
	b := self newObj.
	b msgid: 'ghi'.
	b msgstr: 'jkl'.
	self deny: a equals: b
]

{ #category : #test }
PoNormalEntryTest >> testIsEmptyMsgstr [

	self deny: self newObj isEmptyMsgstr
]

{ #category : #test }
PoNormalEntryTest >> testIsValid [

	| obj |
	obj := self newObj.
	self assert: obj isValid.
	obj hasError: true.
	self deny: obj isValid
]

{ #category : #test }
PoNormalEntryTest >> testMsgstr [

	| obj |
	obj := self newObj.
	self assert: obj msgid isNil.
	self assert: obj msgstr isNil.
	obj msgid: 'abc'.
	obj msgstr: 'def'.
	self assert: obj msgid equals: 'abc'.
	self assert: obj msgstr equals: 'def'.
	self should: [ obj msgstr: 'jkl' ] raise: Error
]

{ #category : #test }
PoNormalEntryTest >> testMsgstrForEditing [

	| obj r |
	obj := self newObj.
	obj msgid: 'abc'.
	obj msgstr: 'def'.
	r := obj msgstrForEditing.
	self assert: r equals: 'def'
]

{ #category : #test }
PoNormalEntryTest >> testPlus [

	| obj a b |
	obj := self newObj.
	obj msgid: 'abc'.
	obj msgstr: 'def'.
	a := self newEmpty: 'abc'.
	b := obj + a.
	self assert: b identicalTo: obj.
	a := self newEmpty: 'def'.
	self should: [ obj + a ] raise: Error.
	a := self newMulti: 'abc' msgstrs: #( b c ).
	b := obj + a.
	self assert: (b isKindOf: PoMultiMsgstrs).
	self assert: b msgid equals: 'abc'.
	self assertCollection: b msgstrs equals: #( def b c ).
	a := self newMulti: 'def' msgstrs: #( b c ).
	self should: [ obj + a ] raise: Error.
	a := self newNormal: 'abc' msgstr: 'a'.
	b := obj + a.
	self assert: (b isKindOf: PoMultiMsgstrs).
	self assert: b msgid equals: 'abc'.
	self assertCollection: b msgstrs equals: #( def a ).
	a := self newNormal: 'def' msgstr: 'a'.
	self should: [ obj + a ] raise: Error
]

{ #category : #test }
PoNormalEntryTest >> testPrintOn [

	| obj s |
	obj := self newObj.
	s := WriteStream on: String new.
	obj printOn: s.
	self assert: s contents equals: '<nil=nil>'.
	obj msgid: 'abc'.
	obj msgstr: 'def'.
	s := WriteStream on: String new.
	obj printOn: s.
	self assert: s contents equals: '<abc=def>'
]

{ #category : #test }
PoNormalEntryTest >> testWithMsgstr [

	| obj r |
	obj := self newObj.
	obj msgid: 'abc'.
	obj msgstr: 'def'.
	r := obj withMsgstr: 'def'.
	self assert: r identicalTo: obj.
	obj := self newObj.
	obj msgid: 'abc'.
	obj msgstr: 'def'.
	r := obj withMsgstr: ''.
	self assert: (r isKindOf: PoEmptyMsgstr).
	self assert: r msgid equals: 'abc'.
	obj := self newObj.
	obj msgid: 'abc'.
	obj msgstr: 'def'.
	r := obj withMsgstr: 'ghi'.
	self assert: (r isKindOf: PoNormalEntry).
	self assert: r msgid equals: 'abc'.
	self assert: r msgstr equals: 'ghi'
]

{ #category : #test }
PoNormalEntryTest >> testWriteOn [

	| obj s |
	obj := self newObj.
	s := WriteStream on: String new.
	obj writeOn: s.
	self
		assert: s contents
		equals: 'msgid "nil"' , String crlf , 'msgstr "nil"' , String crlf.
	obj msgid: 'abc'.
	obj msgstr: 'def'.
	s := WriteStream on: String new.
	obj writeOn: s.
	self
		assert: s contents
		equals: 'msgid "abc"' , String crlf , 'msgstr "def"' , String crlf.
	obj deleted: true.
	s := WriteStream on: String new.
	obj writeOn: s.
	self
		assert: s contents
		equals: '#msgid "abc"' , String crlf , '#msgstr "def"' , String crlf
]
