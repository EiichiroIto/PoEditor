Class {
	#name : #PoFile,
	#superclass : #PoAbstractFile,
	#instVars : [
		'entries'
	],
	#category : #'PoEditor-Data'
}

{ #category : #adding }
PoFile >> addMsgId: aString1 msgStr: aString2 [

	aString1 isEmpty ifTrue: [ ^ self ].
	entries add: (aString2 isEmpty
			 ifTrue: [ PoAbstractEntry msgid: aString1 ]
			 ifFalse: [ PoAbstractEntry msgid: aString1 msgstr: aString2 ])
]

{ #category : #accessing }
PoFile >> entries [

	^ entries
]

{ #category : #accessing }
PoFile >> entries: anObject [

	entries := anObject
]

{ #category : #initialization }
PoFile >> initialize [

	super initialize.
	entries := OrderedCollection new
]
