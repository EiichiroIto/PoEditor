Class {
	#name : #PoEmptyMsgstr,
	#superclass : #PoAbstractEntry,
	#instVars : [
		'msgid',
		'deleted',
		'hasError'
	],
	#category : #'PoEditor-Data'
}

{ #category : #arithmetic }
PoEmptyMsgstr >> + other [

	^ other adoptToEmpty: self
]

{ #category : #comparing }
PoEmptyMsgstr >> = other [

	^ msgid = other msgid and: [ self msgstr = other msgstr ]
]

{ #category : #private }
PoEmptyMsgstr >> adoptToEmpty: anEntry [

	self assert: [ msgid = anEntry msgid ].
	^ self
]

{ #category : #private }
PoEmptyMsgstr >> adoptToMulti: anEntry [

	self assert: [ msgid = anEntry msgid ].
	^ anEntry
]

{ #category : #private }
PoEmptyMsgstr >> adoptToNormal: anEntry [

	self assert: [ msgid = anEntry msgid ].
	^ anEntry
]

{ #category : #accessing }
PoEmptyMsgstr >> deleted [

	^ deleted
]

{ #category : #accessing }
PoEmptyMsgstr >> deleted: anObject [

	deleted := anObject
]

{ #category : #accessing }
PoEmptyMsgstr >> hasError [

	^ hasError
]

{ #category : #accessing }
PoEmptyMsgstr >> hasError: anObject [

	hasError := anObject
]

{ #category : #initialization }
PoEmptyMsgstr >> initialize [

	super initialize.
	deleted := false.
	hasError := false
]

{ #category : #testing }
PoEmptyMsgstr >> isEmptyMsgstr [
	^ true
]

{ #category : #testing }
PoEmptyMsgstr >> isMultiMsgstrs [

	^ false
]

{ #category : #testing }
PoEmptyMsgstr >> isValid [

	^ false
]

{ #category : #accessing }
PoEmptyMsgstr >> msgid [

	^ msgid
]

{ #category : #accessing }
PoEmptyMsgstr >> msgid: anObject [

	self assert: [ msgid isNil ].
	msgid := anObject
]

{ #category : #accessing }
PoEmptyMsgstr >> msgstr [

	^ ''
]

{ #category : #accessing }
PoEmptyMsgstr >> msgstrForEditing [

	^ msgid
]

{ #category : #printing }
PoEmptyMsgstr >> printOn: aStream [

	aStream nextPut: $<.
	deleted ifTrue: [ aStream nextPut: $* ].
	aStream
		nextPutAll: msgid asString;
		nextPut: $>
]

{ #category : #accessing }
PoEmptyMsgstr >> withMsgstr: aString [

	aString isEmpty ifTrue: [ ^ self ].
	^ PoAbstractEntry msgid: msgid msgstr: aString
]

{ #category : #writing }
PoEmptyMsgstr >> writeOn: aStream [

	(hasError or: [ deleted ]) ifTrue: [ aStream nextPut: $# ].
	aStream
		nextPutAll: 'msgid "';
		nextPutAll: msgid asString;
		nextPutAll: '"';
		nextPutAll: String crlf.
	(hasError or: [ deleted ]) ifTrue: [ aStream nextPut: $# ].
	aStream
		nextPutAll: 'msgstr ""';
		nextPutAll: String crlf
]
