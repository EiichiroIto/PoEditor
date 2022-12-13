"
A PoAbstractEntryTest is a test class for testing the behavior of PoAbstractEntry
"
Class {
	#name : #PoAbstractEntryTest,
	#superclass : #TestCase,
	#category : #'PoEditor-Tests'
}

{ #category : #private }
PoAbstractEntryTest >> newObj [

	^ PoAbstractEntry basicNew
]

{ #category : #test }
PoAbstractEntryTest >> testMsgid [

	| obj |
	obj := PoAbstractEntry msgid: 'abc'.
	self assert: (obj isKindOf: PoEmptyMsgstr).
	self should: [ PoAbstractEntry msgid: '' ] raise: Error
]

{ #category : #test }
PoAbstractEntryTest >> testMsgidMsgstr [

	| obj |
	obj := PoAbstractEntry msgid: 'abc' msgstr: 'def'.
	self assert: (obj isKindOf: PoNormalEntry).
	obj := PoAbstractEntry msgid: 'abc' msgstr: ''.
	self assert: (obj isKindOf: PoEmptyMsgstr).
	self should: [ PoAbstractEntry msgid: '' msgstr: 'def' ] raise: Error
]

{ #category : #test }
PoAbstractEntryTest >> testMsgidMsgstrs [

	| obj |
	obj := PoAbstractEntry msgid: 'abc' msgstrs: #( 'def' 'ghi' ).
	self assert: (obj isKindOf: PoMultiMsgstrs).
	obj := PoAbstractEntry msgid: 'abc' msgstrs: #( 'def' ).
	self assert: (obj isKindOf: PoNormalEntry).
	obj := PoAbstractEntry msgid: 'abc' msgstrs: #(  ).
	self assert: (obj isKindOf: PoEmptyMsgstr).
	self
		should: [ PoAbstractEntry msgid: '' msgstrs: #( 'def' 'ghi' ) ]
		raise: Error
]
