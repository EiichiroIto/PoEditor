"
A PoProjectTest is a test class for testing the behavior of PoProject
"
Class {
	#name : #PoProjectTest,
	#superclass : #TestCase,
	#category : #'PoEditor-Tests'
}

{ #category : #private }
PoProjectTest >> newFile [

	^ PoFile new
]

{ #category : #private }
PoProjectTest >> newProject [

	^ PoProject new
]

{ #category : #private }
PoProjectTest >> newTemplate [

	^ PoTemplate new
]

{ #category : #test }
PoProjectTest >> testAddEntry [

	| obj e |
	obj := self newProject.
	self assert: obj valids size equals: 0.
	self assert: obj invalids size equals: 0.
	e := PoAbstractEntry msgid: 'abc' msgstr: 'def'.
	obj addEntry: e.
	self assert: obj valids size equals: 1.
	self assert: obj invalids size equals: 0.
	e := PoAbstractEntry msgid: 'abc'.
	obj addEntry: e.
	self assert: obj valids size equals: 1.
	self assert: obj invalids size equals: 0.
	e := PoAbstractEntry msgid: 'abc' msgstr: 'def'.
	obj addEntry: e.
	self assert: obj valids size equals: 1.
	self assert: obj invalids size equals: 0.
	e := PoAbstractEntry msgid: 'abc' msgstr: 'ghi'.
	obj addEntry: e.
	self assert: obj valids size equals: 0.
	self assert: obj invalids size equals: 1.
	e := PoAbstractEntry msgid: 'def'.
	obj addEntry: e.
	self assert: obj valids size equals: 0.
	self assert: obj invalids size equals: 2.
	e := PoAbstractEntry msgid: 'def' msgstr: 'jkl'.
	obj addEntry: e.
	self assert: obj valids size equals: 1.
	self assert: obj invalids size equals: 1
]

{ #category : #test }
PoProjectTest >> testAddTemplate [

	| prj file x |
	prj := self newProject.
	file := self newFile
		        addMsgId: 'abc' msgStr: 'def';
		        addMsgId: 'ghi' msgStr: 'jkl';
		        addMsgId: 'abc' msgStr: 'mno';
		        yourself.
	prj addTemplate: file.
	self assert: prj entries size equals: 2.
	x := prj entryAt: 'abc'.
	self assert: (x isKindOf: PoMultiMsgstrs).
	self
		assertCollection: x msgstrs asArray
		hasSameElements: #( 'def' 'mno' ).
	x := prj entryAt: 'ghi'.
	self assert: (x isKindOf: PoNormalEntry).
	self assert: x msgstr equals: 'jkl'
]

{ #category : #test }
PoProjectTest >> testAddTemplate2 [

	| prj file x |
	prj := self newProject.
	file := self newTemplate
		        addMsgId: 'abc' msgStr: 'def';
		        addMsgId: 'ghi' msgStr: 'jkl';
		        addMsgId: 'abc' msgStr: 'mno';
		        yourself.
	prj addTemplate: file.
	self assert: prj entries size equals: 2.
	x := prj entryAt: 'abc'.
	self assert: (x isKindOf: PoEmptyMsgstr).
	self assert: x msgid equals: 'abc'.
	x := prj entryAt: 'ghi'.
	self assert: (x isKindOf: PoEmptyMsgstr).
	self assert: x msgid equals: 'ghi'
]

{ #category : #test }
PoProjectTest >> testAddTemplate3 [

	| prj file |
	prj := self newProject.
	file := self newFile
		        addMsgId: 'abc' msgStr: 'def';
		        addMsgId: 'ghi' msgStr: 'jkl';
		        addMsgId: 'abc' msgStr: 'mno';
		        yourself.
	prj addTemplate: file.
	self assert: prj entries size equals: 2.
	self deny: (prj entryAt: 'abc') deleted.
	self deny: (prj entryAt: 'ghi') deleted.
	file := self newFile
		        addMsgId: 'abc' msgStr: 'mno';
		        yourself.
	prj addTemplate: file.
	self deny: (prj entryAt: 'abc') deleted.
	self assert: (prj entryAt: 'ghi') deleted
]

{ #category : #test }
PoProjectTest >> testEntries [

	| obj x |
	obj := self newProject.
	self assert: obj entries isDictionary.
	self assert: obj entries isEmpty.
	x := Dictionary new.
	obj entries: x.
	self assert: obj entries identicalTo: x
]

{ #category : #test }
PoProjectTest >> testInitialize [

	| obj |
	obj := self newProject.
	self assert: obj entries isDictionary.
	self assert: obj entries isEmpty
]

{ #category : #test }
PoProjectTest >> testInvalids [

	| obj |
	obj := self newProject.
	self assert: obj invalids isArray.
	self assert: obj invalids isEmpty
]

{ #category : #test }
PoProjectTest >> testValids [

	| obj |
	obj := self newProject.
	self assert: obj valids isArray.
	self assert: obj valids isEmpty
]
