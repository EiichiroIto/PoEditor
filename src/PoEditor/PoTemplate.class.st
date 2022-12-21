Class {
	#name : #PoTemplate,
	#superclass : #PoAbstractFile,
	#instVars : [
		'entries'
	],
	#category : #'PoEditor-Data'
}

{ #category : #adding }
PoTemplate >> addMsgId: aString1 msgStr: aString2 [

	aString1 isEmpty ifTrue: [ ^ self ].
	entries add: (PoAbstractEntry msgid: aString1)
]

{ #category : #accessing }
PoTemplate >> entries [

	^ entries
]

{ #category : #accessing }
PoTemplate >> entries: anObject [

	entries := anObject
]

{ #category : #initialization }
PoTemplate >> initialize [

	super initialize.
	entries := OrderedCollection new
]
