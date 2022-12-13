Class {
	#name : #PoProject,
	#superclass : #Object,
	#instVars : [
		'entries'
	],
	#category : #'PoEditor-Project'
}

{ #category : #adding }
PoProject >> addEntry: anAbstractEntry [

	| newEntry |
	newEntry := (entries
		             at: anAbstractEntry msgid
		             ifPresent: [ :entry | entry + anAbstractEntry ]
		             ifAbsent: [ anAbstractEntry ])
		            copy;
		            deleted: false;
		            yourself.
	entries at: anAbstractEntry msgid put: newEntry
]

{ #category : #adding }
PoProject >> addTemplate: anAbstractFile [

	entries do: [ :each | each deleted: true ].
	anAbstractFile entries do: [ :each | self addEntry: each ]
]

{ #category : #adding }
PoProject >> addTranslatedEntry: anAbstractEntry [

	| entry newEntry |
	entry := entries at: anAbstractEntry msgid ifAbsent: [ ^ self ].
	entry deleted ifTrue: [ ^ self ].
	newEntry := entry + anAbstractEntry.
	entry == newEntry ifFalse: [ 
		entries at: anAbstractEntry msgid put: newEntry ]
]

{ #category : #adding }
PoProject >> addTranslation: anAbstractFile [

	anAbstractFile entries do: [ :each | self addTranslatedEntry: each ]
]

{ #category : #accessing }
PoProject >> entries [

	^ entries
]

{ #category : #accessing }
PoProject >> entries: anObject [

	entries := anObject
]

{ #category : #accessing }
PoProject >> entryAt: aString [

	^ entries at: aString
]

{ #category : #accessing }
PoProject >> entryList [

	^ entries values
]

{ #category : #initialization }
PoProject >> initialize [

	entries := Dictionary new
]

{ #category : #accessing }
PoProject >> invalids [

	^ entries values reject: #isValid
]

{ #category : #printing }
PoProject >> printOn: aStream [

	aStream
		nextPutAll: self class name;
		nextPutAll: '(entries=';
		nextPutAll: entries size asString;
		nextPutAll: ')'
]

{ #category : #accessing }
PoProject >> updateEntry: anEntry [

	entries at: anEntry msgid put: anEntry
]

{ #category : #accessing }
PoProject >> valids [

	^ entries values select: #isValid
]
