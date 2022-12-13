Extension { #name : #String }

{ #category : #'*PoEditor' }
String >> localized [

	^ PoTranslator translationFor: self asString
]
