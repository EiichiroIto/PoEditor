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
PoProjectTest >> testAddTranslatedEntry [

	| prj a b c d r |
	prj := self newProject.
	a := PoAbstractEntry msgid: 'abc'.
	b := PoAbstractEntry msgid: 'def'.
	prj addEntry: a.
	prj addEntry: b.
	c := PoAbstractEntry msgid: 'abc' msgstr: 'ghi'.
	prj addTranslatedEntry: c.
	r := prj entryAt: 'abc'.
	self assert: r msgstr equals: 'ghi'.
	r deleted: true.
	c := PoAbstractEntry msgid: 'abc' msgstr: 'pqr'.
	prj addTranslatedEntry: c.
	self assert: r msgstr equals: 'ghi'.
	d := PoAbstractEntry msgid: 'jkl' msgstr: 'mno'.
	prj addTranslatedEntry: c.
	self deny: (prj hasMsgid: 'jkl')
]

{ #category : #test }
PoProjectTest >> testAddTranslation [

	| prj file1 file2 r |
	prj := self newProject.
	file1 := self newFile
		         addMsgId: 'abc' msgStr: 'def';
		         addMsgId: 'ghi' msgStr: 'jkl';
		         yourself.
	prj addTemplate: file1.
	self assert: (prj entryAt: 'abc') msgstr equals: 'def'.
	self assert: (prj entryAt: 'ghi') msgstr equals: 'jkl'.
	file2 := self newFile
		         addMsgId: 'abc' msgStr: 'mno';
		         yourself.
	prj addTranslation: file2.
	r := prj entryAt: 'abc'.
	self assertCollection: r msgstrs equals: #( 'def' 'mno' ).
	self assert: (prj entryAt: 'ghi') msgstr equals: 'jkl'
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
PoProjectTest >> testEntryAt [

	| prj obj |
	prj := self newProject.
	self should: [ prj entryAt: 'abc' ] raise: Error.
	obj := PoAbstractEntry msgid: 'abc'.
	prj addEntry: obj.
	self assert: (prj entryAt: 'abc') identicalTo: obj
]

{ #category : #test }
PoProjectTest >> testEntryList [

	| prj a b |
	prj := self newProject.
	self assert: prj entryList isEmpty.
	a := PoAbstractEntry msgid: 'abc' msgstr: 'def'.
	b := PoAbstractEntry msgid: 'ghi' msgstr: 'jkl'.
	prj addEntry: a.
	prj addEntry: b.
	self assert: prj entryList isArray.
	self assert: prj entryList size equals: 2.
	self assert: prj entryList first identicalTo: a.
	self assert: prj entryList second identicalTo: b
]

{ #category : #test }
PoProjectTest >> testHasMsgid [

	| prj a b |
	prj := self newProject.
	self assert: prj entryList isEmpty.
	a := PoAbstractEntry msgid: 'abc' msgstr: 'def'.
	b := PoAbstractEntry msgid: 'ghi' msgstr: 'jkl'.
	prj addEntry: a.
	prj addEntry: b.
	self assert: (prj hasMsgid: 'abc').
	self assert: (prj hasMsgid: 'ghi').
	self deny: (prj hasMsgid: 'def')
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
PoProjectTest >> testPrintOn [

	| prj s |
	prj := self newProject.
	s := WriteStream on: String new.
	prj printOn: s.
	self assert: s contents equals: 'PoProject(entries=0)'.
	prj addEntry: (PoAbstractEntry msgid: 'abc' msgstr: 'def').
	prj addEntry: (PoAbstractEntry msgid: 'ghi' msgstr: 'jkl').
	s := WriteStream on: String new.
	prj printOn: s.
	self assert: s contents equals: 'PoProject(entries=2)'
]

{ #category : #test }
PoProjectTest >> testRemoveEntry [

	| prj a b |
	prj := self newProject.
	self assert: prj entryList isEmpty.
	a := PoAbstractEntry msgid: 'abc' msgstr: 'def'.
	b := PoAbstractEntry msgid: 'ghi' msgstr: 'jkl'.
	prj addEntry: a.
	prj addEntry: b.
	self assert: prj entryList size equals: 2.
	prj removeEntry: a.
	self assert: prj entryList size equals: 1.
	self assert: prj entryList first identicalTo: b
]

{ #category : #test }
PoProjectTest >> testUpdateEntry [

	| prj a b c |
	prj := self newProject.
	self assert: prj entryList isEmpty.
	a := PoAbstractEntry msgid: 'abc' msgstr: 'def'.
	b := PoAbstractEntry msgid: 'ghi' msgstr: 'jkl'.
	prj addEntry: a.
	prj addEntry: b.
	self assert: prj entryList size equals: 2.
	c := PoAbstractEntry msgid: 'abc'.
	prj updateEntry: c.
	self assert: prj entryList size equals: 2.
	self assert: prj entryList first identicalTo: c.
	self assert: prj entryList second identicalTo: b
]

{ #category : #test }
PoProjectTest >> testValids [

	| obj |
	obj := self newProject.
	self assert: obj valids isArray.
	self assert: obj valids isEmpty
]
