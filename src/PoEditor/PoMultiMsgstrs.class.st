Class {
	#name : #PoMultiMsgstrs,
	#superclass : #PoEmptyMsgstr,
	#instVars : [
		'msgstrs',
		'selectedIndex'
	],
	#category : #'PoEditor-Data'
}

{ #category : #arithmetic }
PoMultiMsgstrs >> + other [

	^ other adoptToMulti: self
]

{ #category : #comparing }
PoMultiMsgstrs >> = other [

	^ self == other
]

{ #category : #private }
PoMultiMsgstrs >> adoptToEmpty: anEntry [

	self assert: [ msgid = anEntry msgid ].
	^ self
]

{ #category : #private }
PoMultiMsgstrs >> adoptToMulti: anEntry [

	| list |
	self assert: [ msgid = anEntry msgid ].
	list := anEntry msgstrs.
	msgstrs do: [ :each | 
		(list includes: each) ifFalse: [ list := list copyWith: each ] ].
	^ PoAbstractEntry msgid: msgid msgstrs: list
]

{ #category : #private }
PoMultiMsgstrs >> adoptToNormal: anEntry [

	self assert: [ msgid = anEntry msgid ].
	(msgstrs includes: anEntry msgstr) ifTrue: [ ^ self ].
	^ PoAbstractEntry msgid: msgid msgstrs: { anEntry msgstr } , msgstrs
]

{ #category : #testing }
PoMultiMsgstrs >> hasMsgstr: aString [

	^ msgstrs includes: aString
]

{ #category : #initialization }
PoMultiMsgstrs >> initialize [

	super initialize.
	msgstrs := Array new.
	selectedIndex := 0
]

{ #category : #testing }
PoMultiMsgstrs >> isEmptyMsgstr [
	^ false
]

{ #category : #testing }
PoMultiMsgstrs >> isMultiMsgstrs [

	^ true
]

{ #category : #testing }
PoMultiMsgstrs >> isValid [

	^ selectedIndex > 0
]

{ #category : #accessing }
PoMultiMsgstrs >> msgstr [

	^ selectedIndex = 0
		  ifTrue: [ '[multiple msgstrs]' ]
		  ifFalse: [ msgstrs at: selectedIndex ]
]

{ #category : #accessing }
PoMultiMsgstrs >> msgstrForEditing [

	^ selectedIndex = 0
		  ifTrue: [ super msgstrForEditing ]
		  ifFalse: [ msgstrs at: selectedIndex ]
]

{ #category : #accessing }
PoMultiMsgstrs >> msgstrs [

	^ msgstrs
]

{ #category : #accessing }
PoMultiMsgstrs >> msgstrs: anObject [

	msgstrs := anObject
]

{ #category : #printing }
PoMultiMsgstrs >> printOn: aStream [

	aStream
		nextPut: $<;
		nextPutAll: msgid asString;
		nextPutAll: '=['.
	msgstrs
		do: [ :each | aStream nextPutAll: each asString ]
		separatedBy: [ aStream nextPut: $, ].
	aStream nextPutAll: ']>'
]

{ #category : #accessing }
PoMultiMsgstrs >> selectedIndex [

	^ selectedIndex
]

{ #category : #accessing }
PoMultiMsgstrs >> selectedIndex: anObject [

	selectedIndex := anObject
]

{ #category : #accessing }
PoMultiMsgstrs >> withMsgstr: aString [

	| index |
	aString isEmpty ifTrue: [ 
		selectedIndex = 0 ifTrue: [ ^ self ].
		msgstrs := msgstrs copyWithoutIndex: selectedIndex.
		selectedIndex := 0.
		^ msgstrs size = 1
			  ifTrue: [ PoAbstractEntry msgid: msgid msgstr: msgstrs first ]
			  ifFalse: [ self ] ].
	index := msgstrs indexOf: aString.
	selectedIndex = 0
		ifTrue: [ 
			index = 0
				ifTrue: [ msgstrs := msgstrs copyWith: aString ]
				ifFalse: [ msgstrs at: index put: aString ] ]
		ifFalse: [ 
		index = 0 ifTrue: [ msgstrs at: selectedIndex put: aString ] ].
	selectedIndex := msgstrs indexOf: aString.
	^ self
]

{ #category : #writing }
PoMultiMsgstrs >> writeOn: aStream [

	msgstrs
		do: [ :each | 
			(hasError or: [ deleted ]) ifTrue: [ aStream nextPut: $# ].
			aStream
				nextPutAll: 'msgid "';
				nextPutAll: msgid asString;
				nextPutAll: '"';
				nextPutAll: String crlf.
			(hasError or: [ deleted ]) ifTrue: [ aStream nextPut: $# ].
			aStream
				nextPutAll: 'msgstr "';
				nextPutAll: each asString;
				nextPutAll: '"';
				nextPutAll: String crlf ]
		separatedBy: [ aStream nextPutAll: String crlf ]
]
