Class {
	#name : #PoNormalEntry,
	#superclass : #PoEmptyMsgstr,
	#instVars : [
		'msgstr'
	],
	#category : #'PoEditor-Data'
}

{ #category : #arithmetic }
PoNormalEntry >> + other [

	^ other adoptToNormal: self
]

{ #category : #private }
PoNormalEntry >> adoptToEmpty: anEntry [

	self assert: [ msgid = anEntry msgid ].
	^ self
]

{ #category : #private }
PoNormalEntry >> adoptToMulti: anEntry [

	self assert: [ msgid = anEntry msgid ].
	(anEntry msgstrs includes: msgstr) ifTrue: [ ^ anEntry ].
	^ PoAbstractEntry msgid: msgid msgstrs: anEntry msgstrs , { msgstr }
]

{ #category : #private }
PoNormalEntry >> adoptToNormal: anEntry [

	self assert: [ msgid = anEntry msgid ].
	msgstr = anEntry msgstr ifTrue: [ ^ self ].
	^ PoAbstractEntry msgid: msgid msgstrs: { 
			  anEntry msgstr.
			  msgstr }
]

{ #category : #testing }
PoNormalEntry >> isEmptyMsgstr [
	^ false
]

{ #category : #testing }
PoNormalEntry >> isValid [

	^ hasError not
]

{ #category : #accessing }
PoNormalEntry >> msgstr [

	^ msgstr
]

{ #category : #accessing }
PoNormalEntry >> msgstr: anObject [

	self assert: [ msgstr isNil ].
	msgstr := anObject
]

{ #category : #accessing }
PoNormalEntry >> msgstrForEditing [

	^ msgstr
]

{ #category : #printing }
PoNormalEntry >> printOn: aStream [

	aStream
		nextPut: $<;
		nextPutAll: msgid asString;
		nextPut: $=;
		nextPutAll: msgstr asString;
		nextPut: $>
]

{ #category : #accessing }
PoNormalEntry >> withMsgstr: aString [

	msgstr = aString ifTrue: [ ^ self ].
	^ aString isEmpty
		  ifTrue: [ PoAbstractEntry msgid: msgid ]
		  ifFalse: [ PoAbstractEntry msgid: msgid msgstr: aString ]
]

{ #category : #writing }
PoNormalEntry >> writeOn: aStream [

	(hasError or: [ deleted ]) ifTrue: [ aStream nextPut: $# ].
	aStream
		nextPutAll: 'msgid "';
		nextPutAll: msgid asString;
		nextPutAll: '"';
		nextPutAll: String crlf.
	(hasError or: [ deleted ]) ifTrue: [ aStream nextPut: $# ].
	aStream
		nextPutAll: 'msgstr "';
		nextPutAll: msgstr asString;
		nextPutAll: '"';
		nextPutAll: String crlf
]
