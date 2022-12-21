"
A PoMultiMsgstrsTest is a test class for testing the behavior of PoMultiMsgstrs
"
Class {
	#name : #PoMultiMsgstrsTest,
	#superclass : #TestCase,
	#traits : 'TNewPoData',
	#classTraits : 'TNewPoData classTrait',
	#category : #'PoEditor-Tests'
}

{ #category : #private }
PoMultiMsgstrsTest >> newObj [

	^ PoMultiMsgstrs basicNew initialize
]

{ #category : #test }
PoMultiMsgstrsTest >> testAdoptToEmpty [

	| obj a b |
	obj := self newObj.
	obj msgid: 'abc'.
	obj msgstrs: #( a b ) asSet.
	a := self newEmpty: 'abc'.
	b := obj adoptToEmpty: a.
	self assert: b identicalTo: obj.
	a := self newEmpty: 'def'.
	self should: [ obj adoptToEmpty: a ] raise: Error
]

{ #category : #test }
PoMultiMsgstrsTest >> testAdoptToMulti [

	| obj a b |
	obj := self newObj.
	obj msgid: 'abc'.
	obj msgstrs: #( a b ) asSet.
	a := self newMulti: 'abc' msgstrs: #( b c ).
	b := obj adoptToMulti: a.
	self assert: (b isKindOf: PoMultiMsgstrs).
	self assert: b msgid equals: 'abc'.
	self assertCollection: b msgstrs asArray hasSameElements: #( a b c ).
	a := self newMulti: 'def' msgstrs: #( b c ).
	self should: [ obj adoptToMulti: a ] raise: Error
]

{ #category : #test }
PoMultiMsgstrsTest >> testAdoptToNormal [

	| obj a b |
	obj := self newObj.
	obj msgid: 'abc'.
	obj msgstrs: #( a b ).
	a := self newNormal: 'abc' msgstr: 'a'.
	b := obj adoptToNormal: a.
	self assert: (b isKindOf: PoMultiMsgstrs).
	self assert: b msgid equals: 'abc'.
	self assertCollection: b msgstrs equals: #( a b ).
	a := self newNormal: 'def' msgstr: 'a'.
	self should: [ obj adoptToNormal: a ] raise: Error
]

{ #category : #test }
PoMultiMsgstrsTest >> testHasMsgstr [

	| obj |
	obj := self newObj.
	obj msgid: 'abc'.
	obj msgstrs: #( a b c ) asSet.
	self assert: (obj hasMsgstr: 'a').
	self assert: (obj hasMsgstr: 'b').
	self assert: (obj hasMsgstr: 'c').
	self deny: (obj hasMsgstr: 'd')
]

{ #category : #test }
PoMultiMsgstrsTest >> testInitialize [

	| obj |
	obj := self newObj.
	self assert: obj msgid isNil.
	self assert: obj msgstrs isCollection.
	self assert: obj msgstrs isEmpty.
	self assert: obj selectedIndex equals: 0
]

{ #category : #test }
PoMultiMsgstrsTest >> testIsEmptyMsgstr [

	self deny: self newObj isEmptyMsgstr
]

{ #category : #test }
PoMultiMsgstrsTest >> testIsMultiMsgstrs [

	self assert: self newObj isMultiMsgstrs
]

{ #category : #test }
PoMultiMsgstrsTest >> testIsValid [

	| obj |
	obj := self newObj.
	self deny: obj isValid.
	obj msgid: 'abc'.
	obj msgstrs: #( 'def' 'ghi' ).
	obj selectedIndex: 0.
	self deny: obj isValid.
	obj selectedIndex: 1.
	self assert: obj isValid
]

{ #category : #test }
PoMultiMsgstrsTest >> testMsgstr [

	| obj r |
	obj := self newObj.
	obj msgid: 'abc'.
	obj msgstrs: #( 'def' 'ghi' ).
	obj selectedIndex: 0.
	r := obj msgstr.
	self assert: r equals: '[multiple msgstrs]'.
	obj := self newObj.
	obj msgid: 'abc'.
	obj msgstrs: #( 'def' 'ghi' ).
	obj selectedIndex: 1.
	r := obj msgstr.
	self assert: r equals: 'def'
]

{ #category : #test }
PoMultiMsgstrsTest >> testMsgstrForEditing [

	| obj r |
	obj := self newObj.
	obj msgid: 'abc'.
	obj msgstrs: #( 'def' 'ghi' ).
	obj selectedIndex: 0.
	r := obj msgstrForEditing.
	self assert: r equals: 'abc'.
	obj := self newObj.
	obj msgid: 'abc'.
	obj msgstrs: #( 'def' 'ghi' ).
	obj selectedIndex: 1.
	r := obj msgstrForEditing.
	self assert: r equals: 'def'
]

{ #category : #test }
PoMultiMsgstrsTest >> testMsgstrs [

	| obj x |
	obj := self newObj.
	self assert: obj msgstrs isCollection.
	self assert: obj msgstrs isEmpty.
	x := Set new.
	obj msgstrs: x.
	self assert: obj msgstrs identicalTo: x
]

{ #category : #test }
PoMultiMsgstrsTest >> testPlus [

	| obj a b |
	obj := self newObj.
	obj msgid: 'abc'.
	obj msgstrs: #( a b ).
	a := self newEmpty: 'abc'.
	b := obj + a.
	self assert: b identicalTo: obj.
	a := self newEmpty: 'def'.
	self should: [ obj + a ] raise: Error.
	a := self newMulti: 'abc' msgstrs: #( b c ).
	b := obj + a.
	self assert: (b isKindOf: PoMultiMsgstrs).
	self assert: b msgid equals: 'abc'.
	self assertCollection: b msgstrs equals: #( a b c ).
	a := self newMulti: 'def' msgstrs: #( b c ).
	self should: [ obj + a ] raise: Error.
	a := self newNormal: 'abc' msgstr: #a.
	b := obj + a.
	self assert: (b isKindOf: PoMultiMsgstrs).
	self assert: b msgid equals: 'abc'.
	self assertCollection: b msgstrs equals: #( a b ).
	a := self newNormal: 'def' msgstr: 'a'.
	self should: [ obj + a ] raise: Error
]

{ #category : #test }
PoMultiMsgstrsTest >> testPrintOn [

	| obj s |
	obj := self newObj.
	s := WriteStream on: String new.
	obj printOn: s.
	self assert: s contents equals: '<nil=[]>'.
	obj msgid: 'abc'.
	obj msgstrs: #(a b) asSet.
	s := WriteStream on: String new.
	obj printOn: s.
	self assert: s contents equals: '<abc=[a,b]>'
]

{ #category : #test }
PoMultiMsgstrsTest >> testSelectedIndex [

	| obj |
	obj := self newObj.
	self assert: obj selectedIndex equals: 0.
	obj selectedIndex: 1.
	self assert: obj selectedIndex equals: 1
]

{ #category : #test }
PoMultiMsgstrsTest >> testWithMsgstr [

	| obj r |
	obj := self newObj.
	obj msgid: 'abc'.
	obj msgstrs: #( 'def' 'ghi' ) copy.
	obj selectedIndex: 1.
	r := obj withMsgstr: ''.
	self assert: (obj isKindOf: PoMultiMsgstrs).
	self assert: obj msgid equals: 'abc'.
	self deny: (obj hasMsgstr: 'def').
	self assert: (obj hasMsgstr: 'ghi').
	self deny: (obj hasMsgstr: '').
	self assert: obj selectedIndex equals: 0.
	obj := self newObj.
	obj msgid: 'abc'.
	obj msgstrs: #( 'def' 'ghi' ) copy.
	obj selectedIndex: 1.
	r := obj withMsgstr: 'def'.
	self assert: (obj isKindOf: PoMultiMsgstrs).
	self assert: obj msgid equals: 'abc'.
	self assert: (obj hasMsgstr: 'def').
	self assert: (obj hasMsgstr: 'ghi').
	self assert: obj selectedIndex equals: 1.
	obj := self newObj.
	obj msgid: 'abc'.
	obj msgstrs: #( 'def' 'ghi' ) copy.
	obj selectedIndex: 1.
	r := obj withMsgstr: 'ghi'.
	self assert: (obj isKindOf: PoMultiMsgstrs).
	self assert: obj msgid equals: 'abc'.
	self assert: (obj hasMsgstr: 'def').
	self assert: (obj hasMsgstr: 'ghi').
	self assert: obj selectedIndex equals: 2.
	obj := self newObj.
	obj msgid: 'abc'.
	obj msgstrs: #( 'def' 'ghi' ) copy.
	obj selectedIndex: 1.
	r := obj withMsgstr: 'jkl'.
	self assert: (obj isKindOf: PoMultiMsgstrs).
	self assert: obj msgid equals: 'abc'.
	self deny: (obj hasMsgstr: 'def').
	self assert: (obj hasMsgstr: 'ghi').
	self assert: (obj hasMsgstr: 'jkl').
	self assert: obj selectedIndex equals: 1
]

{ #category : #test }
PoMultiMsgstrsTest >> testWriteOn [

	| obj s |
	obj := self newObj.
	s := WriteStream on: String new.
	obj writeOn: s.
	self assert: s contents isEmpty.
	obj msgid: 'abc'.
	obj msgstrs: #( 'def' 'ghi' ).
	s := WriteStream on: String new.
	obj writeOn: s.
	self
		assert: s contents
		equals: 'msgid "abc"' , String crlf , 'msgstr "def"' , String crlf
			, String crlf , 'msgid "abc"' , String crlf , 'msgstr "ghi"'
			, String crlf , String crlf.
	obj deleted: true.
	s := WriteStream on: String new.
	obj writeOn: s.
	self
		assert: s contents
		equals:
			'#msgid "abc"' , String crlf , '#msgstr "def"' , String crlf
			, String crlf , '#msgid "abc"' , String crlf , '#msgstr "ghi"'
			, String crlf , String crlf.
	obj deleted: false.
	obj selectedIndex: 2.
	s := WriteStream on: String new.
	obj writeOn: s.
	self
		assert: s contents
		equals:
			'msgid "abc"' , String crlf , 'msgstr "ghi"'
			, String crlf , String crlf
]
