Class {
	#name : #PoAbstractEntry,
	#superclass : #Object,
	#category : #'PoEditor-Data'
}

{ #category : #'instance creation' }
PoAbstractEntry class >> fromSton: stonReader [

	^ self basicNew initialize
		  fromSton: stonReader;
		  yourself
]

{ #category : #'instance creation' }
PoAbstractEntry class >> msgid: aString [

	self assert: [ aString notEmpty ].
	^ PoEmptyMsgstr basicNew initialize
		  msgid: aString;
		  yourself
]

{ #category : #'instance creation' }
PoAbstractEntry class >> msgid: aString msgstr: aString2 [

	self assert: [ aString notEmpty ].
	aString2 isEmpty ifTrue: [ ^ self msgid: aString ].
	^ PoNormalEntry basicNew initialize
		  msgid: aString;
		  msgstr: aString2;
		  yourself
]

{ #category : #'instance creation' }
PoAbstractEntry class >> msgid: aString msgstrs: aCollection [

	| list |
	self assert: [ aString notEmpty ].
	list := aCollection copy.
	list isEmpty ifTrue: [ ^ self msgid: aString ].
	list size = 1 ifTrue: [ ^ self msgid: aString msgstr: list first ].
	^ PoMultiMsgstrs basicNew initialize
		  msgid: aString;
		  msgstrs: list;
		  yourself
]

{ #category : #'instance creation' }
PoAbstractEntry class >> new [

	self shouldNotImplement
]

{ #category : #arithmetic }
PoAbstractEntry >> + other [

	self subclassResponsibility
]

{ #category : #arithmetic }
PoAbstractEntry >> adoptToEmpty: anEntry [

	self subclassResponsibility
]

{ #category : #arithmetic }
PoAbstractEntry >> adoptToMulti: anEntry [

	self subclassResponsibility
]

{ #category : #arithmetic }
PoAbstractEntry >> adoptToNormal: anEntry [

	self subclassResponsibility
]

{ #category : #writing }
PoAbstractEntry >> writeOn: aStream [

	self subclassResponsibility
]
