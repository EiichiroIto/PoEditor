Class {
	#name : #PoAbstractFile,
	#superclass : #Object,
	#category : #'PoEditor-Data'
}

{ #category : #'instance creation' }
PoAbstractFile class >> fileNamed: aString [

	^ self new readFrom: aString asFileReference readStream
]

{ #category : #adding }
PoAbstractFile >> addMsgId: aString1 msgStr: aString2 [

	self subclassResponsibility
]

{ #category : #accessing }
PoAbstractFile >> entries [

	self subclassResponsibility
]

{ #category : #'file read/write' }
PoAbstractFile >> readFrom: aStream [

	| line key value |
	key := value := ''.
	[ aStream atEnd ] whileFalse: [ 
		line := aStream nextLine.
		(line beginsWith: 'msgid') ifTrue: [ 
			key := line copyFrom: 7 to: line size.
			key := self unquoteString: key ].
		(line beginsWith: 'msgstr') ifTrue: [ 
			value := line copyFrom: 8 to: line size.
			value := self unquoteString: value.
			key ifNotEmpty: [ self addMsgId: key msgStr: value ].
			key := '' ] ]
]

{ #category : #utilities }
PoAbstractFile >> unquoteString: aString [
	| tmp |
	tmp := aString trimBoth.
	tmp ifEmpty: [ ^ tmp ].
	tmp first = $"
		ifTrue: [ tmp := tmp allButFirst ].
	tmp ifEmpty: [ ^ tmp ].
	tmp last = $"
		ifTrue: [ tmp := tmp allButLast ].
	^ tmp
]
