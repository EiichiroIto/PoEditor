Trait {
	#name : #TNewPoData,
	#category : #'PoEditor-Tests'
}

{ #category : #'instance creation' }
TNewPoData >> newEmpty: aString [

	^ PoAbstractEntry msgid: aString
]

{ #category : #private }
TNewPoData >> newMulti: aString msgstrs: aCollection [

	^ PoAbstractEntry msgid: aString msgstrs: aCollection
]

{ #category : #private }
TNewPoData >> newNormal: aString msgstr: aString2 [

	^ PoAbstractEntry msgid: aString msgstr: aString2
]
