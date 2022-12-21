Class {
	#name : #PoTranslator,
	#superclass : #Object,
	#instVars : [
		'fonts',
		'texts'
	],
	#classVars : [
		'Current'
	],
	#category : #'PoEditor-Spec2'
}

{ #category : #private }
PoTranslator class >> addLocalizedTextsTo: aSet [

	| list list3 |
	list := #localized senders.
	list do: [ :each | 
		list3 := each sendNodes select: [ :each2 | 
			         each2 selector = #localized and: [ 
				         each2 receiver isLiteralNode and: [ 
					         each2 receiver isLiteralArray not ] ] ].
		list3 := list3 collect: [ :each2 | each2 receiver value ].
		aSet addAll: list3 ]
]

{ #category : #accessing }
PoTranslator class >> argFont [
	^ self fontAt: #Arg
]

{ #category : #accessing }
PoTranslator class >> buttonFont [
	^ self fontAt: #Button
]

{ #category : #accessing }
PoTranslator class >> current [
	^ Current ifNil: [ Current := self defaultTranslator ]
]

{ #category : #accessing }
PoTranslator class >> current: aTranslator [
	Current := aTranslator
]

{ #category : #private }
PoTranslator class >> defaultTranslator [
	| obj |
	obj := self new.
	obj fontAt: #Arg put: StandardFonts defaultFont.
	obj fontAt: #Button put: StandardFonts buttonFont.
	obj fontAt: #Label put: StandardFonts listFont.
	^ obj
]

{ #category : #private }
PoTranslator class >> fontAt: aSymbol [
	^ self current fontAt: aSymbol
]

{ #category : #utilities }
PoTranslator class >> generatePOTFile [

	"PoTranslator generatePOTFile"

	| file strings |
	file := FileSystem workingDirectory / 'PoEditor.pot'.
	file isFile ifTrue: [ file delete ].
	strings := Set new.
	self addLocalizedTextsTo: strings.
	file writeStreamDo: [ :stream | 
		strings asOrderedCollection sorted do: [ :each | 
			stream
				nextPutAll: 'msgid "';
				nextPutAll: each;
				nextPut: $";
				nextPutAll: String crlf;
				nextPutAll: 'msgstr ""';
				nextPutAll: String crlf;
				nextPutAll: String crlf ] ]
]

{ #category : #accessing }
PoTranslator class >> labelFont [
	^ self fontAt: #Label
]

{ #category : #accessing }
PoTranslator class >> translationFor: aString [
	^ self current textAt: aString
]

{ #category : #private }
PoTranslator >> addMsgId: aString1 msgStr: aString2 [
	| key value |
	key := self unquoteString: aString1.
	key isEmpty
		ifTrue: [ ^ self ].
	value := self unquoteString: aString2.
	self textAt: key put: value
]

{ #category : #private }
PoTranslator >> defaultFont [
	^ StrikeFont familyName: 'Verdana' size: 10
]

{ #category : #accessing }
PoTranslator >> fontAt: aString [
	^ fonts at: aString ifAbsent: [ self defaultFont ]
]

{ #category : #accessing }
PoTranslator >> fontAt: aString put: aFont [
	fonts at: aString put: aFont
]

{ #category : #private }
PoTranslator >> fontFromString: aString [
	| ret family point |
	(aString includes: $:)
		ifFalse: [ ^ nil ].
	ret := aString splitOn: $:.
	family := ret first trimBoth.
	point := ret second asNumber max: 5.
	^ LogicalFont familyName: family pointSize: point
]

{ #category : #accessing }
PoTranslator >> fonts [
	^ fonts
]

{ #category : #initialization }
PoTranslator >> initialize [
	fonts := Dictionary new.
	texts := Dictionary new
]

{ #category : #accessing }
PoTranslator >> readFrom: aStream [
	| line key value |
	key := value := ''.
	[ aStream atEnd ]
		whileFalse: [ line := aStream nextLine.
			(line beginsWith: 'msgid')
				ifTrue: [ key := line copyFrom: 7 to: line size ].
			(line beginsWith: 'msgstr')
				ifTrue: [ value := line copyFrom: 8 to: line size.
					self addMsgId: key msgStr: value.
					key := '' ] ]
]

{ #category : #private }
PoTranslator >> setupFonts [
	| str |
	str := self textAt: 'ArgFont'.
	(self fontFromString: str)
		ifNotNil: [ :font | self fontAt: 'Arg' put: font ].
	str := self textAt: 'ButtonFont'.
	(self fontFromString: str)
		ifNotNil: [ :font | 
			self fontAt: 'Button' put: font.
			StandardFonts buttonFont: font ].
	str := self textAt: 'LabelFont'.
	(self fontFromString: str)
		ifNotNil: [ :font | 
			self fontAt: 'Label' put: font.
			StandardFonts
				listFont: font;
				menuFont: font;
				defaultFont: font ].
	str := self textAt: 'CodeFont'.
	(self fontFromString: str)
		ifNotNil: [ :font | StandardFonts codeFont: font ].
	str := self textAt: 'TitleFont'.
	(self fontFromString: str)
		ifNotNil: [ :font | 
			StandardFonts
				windowTitleFont: font;
				balloonFont: font ]
]

{ #category : #accessing }
PoTranslator >> textAt: aString [
	^ texts at: aString ifAbsent: [ aString ]
]

{ #category : #accessing }
PoTranslator >> textAt: aString1 put: aString2 [
	texts at: aString1 put: aString2
]

{ #category : #accessing }
PoTranslator >> texts [
	^ texts
]

{ #category : #private }
PoTranslator >> unquoteString: aString [
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
