Class {
	#name : #SpPoEditorFrame,
	#superclass : #SpPresenter,
	#instVars : [
		'menu',
		'entryList',
		'msgstrList',
		'msgstrEditButton',
		'infoLabel',
		'msgidAddButton',
		'msgidRemoveButton',
		'checkEntriesButton'
	],
	#category : #'PoEditor-Spec2'
}

{ #category : #'button actions' }
SpPoEditorFrame >> addNewMsgid [

	| entry ret |
	ret := UIManager default
		       request: 'Enter msgid' localized
		       initialAnswer: ''.
	ret ifNil: [ ^ self ].
	ret isEmpty ifTrue: [ ^ self ].
	(application hasMsgid: ret) ifTrue: [ 
		^ self inform: 'The msgid is already there.' localized ].
	entry := PoAbstractEntry msgid: ret.
	application addEntry: entry
]

{ #category : #private }
SpPoEditorFrame >> clearMsgstrList [

	msgstrList items: #()
]

{ #category : #initialization }
SpPoEditorFrame >> connectPresenters [

	msgidAddButton action: [ self addNewMsgid ].
	checkEntriesButton action: [ application checkEntries ].
	msgidRemoveButton action: [ self removeMsgid ].
	entryList whenSelectionChangedDo: [ :mode | self entrySelected: mode ].
	msgstrEditButton action: [ self editMsgstr ].
	msgstrList whenSelectionChangedDo: [ :mode | self msgstrSelected: mode ]
]

{ #category : #layout }
SpPoEditorFrame >> defaultExtent [

	^ 1024 @ 768
]

{ #category : #layout }
SpPoEditorFrame >> defaultLayout [

	| toolbarHeight |
	toolbarHeight := self class defaultFont height + 12.
	^ SpBoxLayout newVertical
		  add: #menu withConstraints: [ :c | c height: toolbarHeight ];
		  add: (SpPanedLayout newHorizontal
				   add: (SpBoxLayout newVertical
						    add: (SpBoxLayout newHorizontal
								     add: #msgidAddButton;
								     add: #checkEntriesButton;
								     add: #msgidRemoveButton;
								     yourself)
						    withConstraints: [ :c | c height: toolbarHeight ];
						    add: #entryList;
						    yourself);
				   add: (SpBoxLayout newVertical
						    add: #msgstrEditButton
						    withConstraints: [ :c | c height: toolbarHeight ];
						    add: #msgstrList;
						    yourself);
				   yourself);
		  add: #infoLabel withConstraints: [ :c | c height: toolbarHeight ];
		  yourself
]

{ #category : #'button actions' }
SpPoEditorFrame >> editMsgstr [

	| entry ret list |
	entry := entryList selectedItem.
	entry ifNil: [ ^ self ].
	ret := UIManager default
		       request: 'Enter msgstr' localized
		       initialAnswer: entry msgstrForEditing.
	ret ifNil: [ ^ self ].
	application updateEntry: (entry withMsgstr: ret).
	list := entryList items collect: #msgid.
	entryList selectIndex: (list indexOf: entry msgid)
]

{ #category : #accessing }
SpPoEditorFrame >> entries: aCollection [

	entryList items: aCollection.
	self showInfo
]

{ #category : #accessing }
SpPoEditorFrame >> entryList [

	^ entryList
]

{ #category : #accessing }
SpPoEditorFrame >> entryList: anObject [

	entryList := anObject
]

{ #category : #private }
SpPoEditorFrame >> entrySelected: aSelectionMode [

	| entry |
	aSelectionMode selectedIndex = 0
		ifTrue: [ ^ self clearMsgstrList ].
	entry := entryList items at: aSelectionMode selectedIndex.
	entry isMultiMsgstrs
		ifFalse: [ ^ self clearMsgstrList ].
	msgstrList items: entry msgstrs.
	msgstrList selectIndex: entry selectedIndex
]

{ #category : #'menu building' }
SpPoEditorFrame >> fileMenu [

	^ self newMenu
		  addGroup: [ :grp | 
			  grp
				  addItem: [ :item | 
					  item
						  name: 'New' localized;
						  action: [ application openNewProject ] ];
				  addItem: [ :item | 
					  item
						  name: 'Open ' localized;
						  action: [ application openProject ] ];
				  addItem: [ :item | 
					  item
						  name: 'Save' localized;
						  action: [ application saveProjectNoDialog ] ];
				  addItem: [ :item | 
					  item
						  name: 'Save As' localized;
						  action: [ application saveProject ] ];
				  yourself ];
		  addGroup: [ :grp | 
			  grp
				  addItem: [ :item | 
					  item
						  name: 'Open Template File ...' localized;
						  action: [ application openTemplate ] ];
				  addItem: [ :item | 
					  item
						  name: 'Open Translation File ...' localized;
						  action: [ application openTranslation ] ];
				  addItem: [ :item | 
					  item
						  name: 'Save Translation File ...' localized;
						  action: [ application saveTranslation ] ];
				  yourself ];
		  addGroup: [ :grp | 
			  grp
				  addItem: [ :item | 
					  item
						  name: 'Close' localized;
						  action: [ application closeAllWindows ] ];
				  addItem: [ :item | 
					  item
						  name: 'Quit' localized;
						  action: [ application class quit ] ] ];
		  yourself
]

{ #category : #'menu building' }
SpPoEditorFrame >> helpMenu [

	^ self newMenu
		  addItem: [ :item | 
			  item
				  name: ('About ' , application appName) localized;
				  action: [ owner window showAbout ] ];
		  addItem: [ :item | 
			  item
				  name: 'inspect' localized;
				  action: [ application inspect ] ];
		  yourself
]

{ #category : #accessing }
SpPoEditorFrame >> infoLabel [

	^ infoLabel
]

{ #category : #accessing }
SpPoEditorFrame >> infoLabel: anObject [

	infoLabel := anObject
]

{ #category : #initialization }
SpPoEditorFrame >> initializePresenters [

	menu := self newMenuBar.
	entryList := self newTable.
	msgidAddButton := self newButton.
	checkEntriesButton := self newButton.
	msgidRemoveButton := self newButton.
	msgstrEditButton := self newButton.
	msgstrList := self newList.
	infoLabel := self newLabel.
	self setupMenu.
	self setupButtons.
	self setupTable.
	self setupLabels.
	self focusOrder
		add: menu;
		add: msgidAddButton;
		add: msgidRemoveButton;
		add: entryList;
		add: msgstrEditButton;
		add: msgstrList;
		add: infoLabel
]

{ #category : #initialization }
SpPoEditorFrame >> initializeWindow: aWindow [

	aWindow
		initialExtent: self defaultExtent;
		aboutText: application aboutAppString;
		title: application class name
]

{ #category : #'menu actions' }
SpPoEditorFrame >> inspectEntry [

	entryList selectedItem ifNotNil: [ :entry | entry inspect ]
]

{ #category : #accessing }
SpPoEditorFrame >> menu [

	^ menu
]

{ #category : #accessing }
SpPoEditorFrame >> menu: anObject [

	menu := anObject
]

{ #category : #accessing }
SpPoEditorFrame >> msgidAddButton [

	^ msgidAddButton
]

{ #category : #accessing }
SpPoEditorFrame >> msgidAddButton: anObject [

	msgidAddButton := anObject
]

{ #category : #accessing }
SpPoEditorFrame >> msgidRemoveButton [

	^ msgidRemoveButton
]

{ #category : #accessing }
SpPoEditorFrame >> msgidRemoveButton: anObject [

	msgidRemoveButton := anObject
]

{ #category : #accessing }
SpPoEditorFrame >> msgstrEditButton [

	^ msgstrEditButton
]

{ #category : #accessing }
SpPoEditorFrame >> msgstrEditButton: anObject [

	msgstrEditButton := anObject
]

{ #category : #accessing }
SpPoEditorFrame >> msgstrList [

	^ msgstrList
]

{ #category : #accessing }
SpPoEditorFrame >> msgstrList: anObject [

	msgstrList := anObject
]

{ #category : #private }
SpPoEditorFrame >> msgstrSelected: aSelectionMode [

	| msgstr entry |
	aSelectionMode selectedIndex = 0 ifTrue: [ ^ self ].
	entry := entryList selectedItem.
	entry isMultiMsgstrs ifFalse: [ ^ self ].
	msgstr := msgstrList items at: aSelectionMode selectedIndex.
	entry selectedIndex: (entry msgstrs indexOf: msgstr).
	entryList refresh.
	self showInfo
]

{ #category : #'button actions' }
SpPoEditorFrame >> removeMsgid [

	| entry |
	entry := entryList selectedItem.
	entry ifNil: [ ^ self ].
	(self confirm: 'Remove this msgid?' localized , ' --- ' , entry msgid) 
		ifFalse: [ ^ self ].
	application removeEntry: entry
]

{ #category : #accessing }
SpPoEditorFrame >> selectEntryIndex: anInteger [

	entryList selectIndex: 0 scrollToSelection: true
]

{ #category : #initialization }
SpPoEditorFrame >> setupButtons [

	msgidAddButton
		icon: (Smalltalk ui iconNamed: #add);
		label: 'Add' localized;
		help: 'Add new msgid' localized.
	checkEntriesButton
		icon: (Smalltalk ui iconNamed: #smallDebug);
		label: 'Check' localized;
		help: 'Check all entries' localized.
	msgidRemoveButton
		icon: (Smalltalk ui iconNamed: #remove);
		label: 'Remove' localized;
		help: 'Remove msgid' localized.
	msgstrEditButton
		icon: (Smalltalk ui iconNamed: #edit);
		label: 'Edit' localized;
		help: 'Edit msgstr' localized
]

{ #category : #initialization }
SpPoEditorFrame >> setupLabels [

	infoLabel label: ''
]

{ #category : #initialization }
SpPoEditorFrame >> setupMenu [
	menu
		addItem: [ :item | 
			item
				name: 'File' localized;
				subMenu: self fileMenu ];
		addItem: [ :item | 
			item
				name: 'Help' localized;
				subMenu: self helpMenu ]
]

{ #category : #initialization }
SpPoEditorFrame >> setupTable [

	entryList
		addColumn: ((SpStringTableColumn
				  title: 'Status'
				  evaluated: [ :entry | self statusOfEntry: entry ])
				 width: 40;
				 yourself);
		addColumn:
		(SpStringTableColumn title: 'msgid' evaluated: [ :x | x msgid ]);
		addColumn:
		(SpStringTableColumn title: 'msgstr' evaluated: [ :x | x msgstr ]);
		contextMenu: (SpMenuPresenter new
				 addItem: [ :item | 
					 item
						 name: 'delete / undelete' localized;
						 action: [ self toggleDeleteEntry ] ];
				 addItem: [ :item | 
					 item
						 name: 'inspect' localized;
						 action: [ self inspectEntry ] ];
				 yourself)
]

{ #category : #private }
SpPoEditorFrame >> showInfo [

	| st |
	st := WriteStream on: String new.
	st
		nextPutAll: entryList items size asString;
		nextPutAll: ' entries.';
		nextPutAll: (entryList items count: [ :each | each deleted ]) asString;
		nextPutAll: ' removed.';
		nextPutAll: (entryList items count: [ :each | each isValid not ]) asString;
		nextPutAll: ' errors.'.
	infoLabel label: st contents
]

{ #category : #private }
SpPoEditorFrame >> statusOfEntry: anEntry [

	anEntry deleted ifTrue: [ ^ 'x' ].
	^ anEntry isValid
		  ifTrue: [ 
			  anEntry isMultiMsgstrs
				  ifTrue: [ 'm' ]
				  ifFalse: [ '' ] ]
		  ifFalse: [ '!' ]
]

{ #category : #'menu actions' }
SpPoEditorFrame >> toggleDeleteEntry [

	entryList selectedItem ifNotNil: [ :entry | 
		entry deleted: entry deleted not ].
	entryList refresh.
	self showInfo
]
