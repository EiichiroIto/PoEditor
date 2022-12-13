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

{ #category : #api }
PoAbstractFile >> emptyMsgids [

	self subclassResponsibility
]

{ #category : #accessing }
PoAbstractFile >> entries [

	self subclassResponsibility
]

{ #category : #utilities }
PoAbstractFile >> parametersOf: aString [

	| list |
	list := self parseCommandSpec: aString.
	^ list select: [ :each | (each beginsWith: '%') and: [ each ~= '%' ] ]
]

{ #category : #utilities }
PoAbstractFile >> parseCommandSpec: aCommandSpec [

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
