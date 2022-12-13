Class {
	#name : #PoEditor,
	#superclass : #SpApplication,
	#instVars : [
		'presenter',
		'project',
		'projectDirectory',
		'projectName',
		'extraDirectory'
	],
	#category : #'PoEditor-Spec2'
}

{ #category : #private }
PoEditor class >> defaultPoFile [

	^ 'PoEditor.po'
]

{ #category : #accessing }
PoEditor class >> extension [

	^ 'poe'
]

{ #category : #'instance creation' }
PoEditor class >> open [

	self readSettings.
	self new open
]

{ #category : #protocol }
PoEditor class >> quit [

	(self confirm: 'Quit Application?' localized) ifFalse: [ ^ self ].
	Smalltalk snapshot: false andQuit: true
]

{ #category : #private }
PoEditor class >> readSettings [

	| file |
	file := FileSystem workingDirectory / self defaultPoFile.
	file isFile ifFalse: [ ^ self ].
	file readStream in: [ :stream | 
		PoTranslator current readFrom: stream.
		stream close ]
]

{ #category : #accessing }
PoEditor class >> templateExtension [

	^ 'pot'
]

{ #category : #accessing }
PoEditor class >> translationExtension [

	^ 'po'
]

{ #category : #constants }
PoEditor >> aboutAppString [

	^ self appName , ' v' , self appVersion , '
Copyright © 2022 Eiichiro Ito (eiichiro.ito@gmail.com)
All rights reserved.
'
]

{ #category : #adding }
PoEditor >> addEntry: aString [

	project addEntry: aString.
	self updateProject
]

{ #category : #constants }
PoEditor >> appName [

	^ self class name
]

{ #category : #constants }
PoEditor >> appVersion [

	^ '0.0.2'
]

{ #category : #private }
PoEditor >> compareEntry: anEntry and: anEntry2 [

	(anEntry deleted xor: [ anEntry2 deleted ]) ifTrue: [ 
		^ anEntry2 deleted ].
	(anEntry isValid xor: [ anEntry2 isValid ]) ifTrue: [ 
		^ anEntry2 isValid ].
	^ anEntry msgid <= anEntry2 msgid
]

{ #category : #constants }
PoEditor >> defaultProjectName [

	^ 'New Project'
]

{ #category : #accessing }
PoEditor >> extraDirectory [

	^ extraDirectory ifNil: [ FileSystem workingDirectory ]
]

{ #category : #accessing }
PoEditor >> extraDirectory: anObject [

	extraDirectory := anObject
]

{ #category : #testing }
PoEditor >> hasMsgid: aString [

	^ project hasMsgid: aString
]

{ #category : #initialization }
PoEditor >> initialize [

	super initialize.
	projectDirectory := extraDirectory := nil.
	projectName := self defaultProjectName
]

{ #category : #private }
PoEditor >> installProject: aProject [

	project := aProject.
	self updateProject
]

{ #category : #'instance creation' }
PoEditor >> newProject [

	^ PoProject new
]

{ #category : #'instance creation' }
PoEditor >> open [

	| window |
	presenter := self newPresenter: SpPoEditorFrame.
	window := presenter open.
	self openNewProject
]

{ #category : #api }
PoEditor >> openNewProject [

	self installProject: self newProject.
	presenter selectEntryIndex: 0.
	projectName := self defaultProjectName
]

{ #category : #api }
PoEditor >> openProject [

	| file newProj |
	file := UIManager default
		        chooseExistingFileReference: 'Open Project' localized
		        extensions: { self class extension }
		        path: self projectDirectory.
	file ifNil: [ ^ self ].
	file isFile ifFalse: [ ^ self ].
	newProj := STON fromStream: file readStream.
	newProj ifNil: [ ^ self ].
	self projectDirectory: file parent.
	self projectName: file base.
	self installProject: newProj
]

{ #category : #api }
PoEditor >> openTemplate [

	| file pot |
	file := UIManager default
		        chooseExistingFileReference:
		        'Open Template File ...' localized
		        extensions: { 
				        self class translationExtension.
				        self class templateExtension }
		        path: self projectDirectory.
	file ifNil: [ ^ self ].
	file isFile ifFalse: [ ^ self ].
	extraDirectory := file parent.
	pot := file extension = self class translationExtension
		       ifTrue: [ PoFile fileNamed: file ]
		       ifFalse: [ PoTemplate fileNamed: file ].
	project addTemplate: pot.
	self updateProject.
	presenter selectEntryIndex: 0
]

{ #category : #api }
PoEditor >> openTranslation [

	| file pot |
	file := UIManager default
		        chooseExistingFileReference:
		        'Open Translation File ...' localized
		        extensions: { self class translationExtension }
		        path: self projectDirectory.
	file ifNil: [ ^ self ].
	file isFile ifFalse: [ ^ self ].
	extraDirectory := file parent.
	pot := PoFile fileNamed: file.
	project addTranslation: pot.
	self updateProject.
	presenter selectEntryIndex: 0
]

{ #category : #accessing }
PoEditor >> presenter [

	^ presenter
]

{ #category : #accessing }
PoEditor >> presenter: anObject [

	presenter := anObject
]

{ #category : #accessing }
PoEditor >> project [

	^ project
]

{ #category : #accessing }
PoEditor >> project: anObject [

	project := anObject
]

{ #category : #accessing }
PoEditor >> projectDirectory [

	^ projectDirectory ifNil: [ FileSystem workingDirectory ]
]

{ #category : #accessing }
PoEditor >> projectDirectory: anObject [

	projectDirectory := anObject
]

{ #category : #accessing }
PoEditor >> projectName [

	^ projectName
]

{ #category : #accessing }
PoEditor >> projectName: anObject [

	projectName := anObject
]

{ #category : #accessing }
PoEditor >> projectPath [

	^ self projectDirectory / self projectName
]

{ #category : #private }
PoEditor >> promptForSavingProject [

	^ UIManager default
		  chooseForSaveFileReference: 'Save Project' localized
		  extensions: { self class extension }
		  path: self projectPath
]

{ #category : #private }
PoEditor >> promptForSavingTranslation [

	^ UIManager default
		  chooseForSaveFileReference: 'Save Translation' localized
		  extensions: { self class translationExtension }
		  path: self extraDirectory / self projectName
]

{ #category : #api }
PoEditor >> saveProject [

	| file |
	file := self promptForSavingProject.
	file ifNil: [ ^ false ].
	^ self saveProjectAs: file
]

{ #category : #api }
PoEditor >> saveProjectAs: aFileReference [

	(self writeProjectAs: aFileReference) ifFalse: [ ^ false ].
	projectName := aFileReference base.
	projectDirectory := aFileReference parent.
	^ true
]

{ #category : #api }
PoEditor >> saveProjectNoDialog [

	| file |
	projectDirectory ifNil: [ ^ self saveProject ].
	file := self projectPath withExtension: self class extension.
	^ self saveProjectAs: file
]

{ #category : #api }
PoEditor >> saveTranslation [

	| file |
	file := self promptForSavingTranslation.
	file ifNil: [ ^ false ].
	(self writeTranslationAs: file) ifFalse: [ ^ false ].
	extraDirectory := file parent.
	^ true
]

{ #category : #accessing }
PoEditor >> updateEntry: anEntry [

	project updateEntry: anEntry.
	self updateProject
]

{ #category : #private }
PoEditor >> updateProject [

	| list |
	list := project entries values.
	list sort: [ :a :b | self compareEntry: a and: b ].
	presenter entries: list
]

{ #category : #private }
PoEditor >> writeProjectAs: aFileReference [

	| str |
	str := STON toString: project.
	aFileReference writeStream
		nextPutAll: str;
		close.
	^ true
]

{ #category : #private }
PoEditor >> writeTranslationAs: aFileReference [

	| list |
	list := project entryList sorted: [ :a :b | 
		        self compareEntry: a and: b ].
	aFileReference writeStream in: [ :stream | 
		list
			do: [ :each | each writeOn: stream ]
			separatedBy: [ stream nextPutAll: String crlf ].
		stream close ].
	^ true
]
