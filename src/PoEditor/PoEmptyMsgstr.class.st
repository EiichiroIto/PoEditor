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

{ #category : #testing }
PoEmptyMsgstr >> hasValidMsgid [

	| list |
	msgid trimBoth isEmpty ifTrue: [ ^ false ].
	list := self parametersOf: msgid.
	list isEmpty ifTrue: [ ^ true ].
	^ list allSatisfy: [ :each | each size = 2 ]
]

{ #category : #testing }
PoEmptyMsgstr >> hasValidMsgstr [

	^ false
]

{ #category : #testing }
PoEmptyMsgstr >> hasValidMsgstr: aString [

	| msgidList msgstrList tmp |
	aString trimBoth isEmpty ifTrue: [ ^ false ].
	msgidList := self parametersOf: msgid.
	msgstrList := (self parametersOf: aString) asOrderedCollection.
	msgidList size = msgstrList size ifFalse: [ ^ false ].
	msgidList do: [ :each | 
		(msgstrList includes: each)
			ifTrue: [ msgstrList remove: each ifAbsent: [ ^ false ] ]
			ifFalse: [ 
				tmp := msgstrList
					       detect: [ :each2 | each2 beginsWith: each ]
					       ifNone: [ nil ].
				tmp ifNotNil: [ msgstrList remove: tmp ] ] ].
	^ msgstrList isEmpty
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

{ #category : #utilities }
PoEmptyMsgstr >> parametersOf: aString [

	| list |
	list := self parseCommandSpec: aString.
	^ list select: [ :each | (each beginsWith: '%') and: [ each ~= '%' ] ]
]

{ #category : #utilities }
PoEmptyMsgstr >> parseCommandSpec: aCommandSpec [

	"Answer an array of token strings containing my keywords and argument specs."

	| result len i j spec k |
	result := OrderedCollection new.
	spec := aCommandSpec.
	"(spec isKindOf: UTF8) ifTrue: [spec := String withAll: spec]."
	len := aCommandSpec size.

	i := 1.
	[ i < len and: [ (spec at: i) isSeparator ] ] whileTrue: [ 
		i := i + 1 ].
	[ i <= len ] whileTrue: [ 
		j := spec indexOf: $% startingAt: i.
		j > 0
			ifTrue: [ 
				j > i ifTrue: [ result addLast: (spec copyFrom: i to: j - 1) ].
				j < len
					ifTrue: [ 
						k := j + 1.
						(spec at: k) isLetter
							ifTrue: [ 
								[ k + 1 <= len and: [ (spec at: k + 1) isDigit ] ] whileTrue: [ 
									k := k + 1 ].
								k >= len
									ifTrue: [ 
										result addLast: (spec copyFrom: j to: len).
										i := len + 1 ]
									ifFalse: [ 
										result addLast: (spec copyFrom: j to: k).
										i := k + 1 ] ]
							ifFalse: [ 
								result addLast: '%'.
								i := j + 1 ] ]
					ifFalse: [ 
						result addLast: '%'.
						i := j + 2 ] ]
			ifFalse: [ 
				result addLast: (spec copyFrom: i to: len).
				i := len + 1 ] ].

	result := result select: [ :s | s ~= ' ' ].
	^ result asArray collect: [ :s | s trimBoth ]
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
		nextPutAll: String crlf;
		nextPutAll: String crlf
]
