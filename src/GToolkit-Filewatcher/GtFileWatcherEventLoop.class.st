"
Allows to watch files and directories for access, creation, modification, and deletion.



```
eventLoop := GtFileWatcherEventLoop new
	watch: FileLocator imageDirectory;
	startLoop.
eventLoop announcer
	when: GtFileWatcherFileAnnouncement
	do: [  :anEvent | anEvent inspect ]
```

A few notes:
- Different systems behave differently, especially for access events. On some Linux systems, for instance, access events will be generated for all directories contained by the watched directory when the event loop is started. On MacOS, this seems not to be the case.
- Creating file events in the event handler leads to infinite loops. If the watched path contains `PharoDebug.log`, for instance, and the event handler leads to a logged exception, an infinite cycle of debug file modification and the triggered error occurs.
"
Class {
	#name : #GtFileWatcherEventLoop,
	#superclass : #Object,
	#instVars : [
		'semaphore',
		'watcher',
		'semaphoreIndex',
		'process',
		'watching',
		'announcer'
	],
	#category : #'GToolkit-Filewatcher-Core'
}

{ #category : #accessing }
GtFileWatcherEventLoop class >> eventLoopFor: sema sending: message [
	^ [ [ sema wait.
	message value ] repeat ]
]

{ #category : #accessing }
GtFileWatcherEventLoop class >> initialize [

	SessionManager default registerSystemClassNamed: self name
]

{ #category : #'system startup' }
GtFileWatcherEventLoop class >> startUp: resuming [

	resuming ifFalse: [ ^ self ].

	self allInstancesDo: [ :eachInstance | eachInstance resumeOnStartup ]
]

{ #category : #accessing }
GtFileWatcherEventLoop >> announcer [
	^ announcer ifNil: [ announcer := GtFileWatcherAnnouncer new ]
]

{ #category : #initialization }
GtFileWatcherEventLoop >> assessWatchedFiles [
	watching
		select: [ :aPath | aPath exists not ]
		thenDo: [ :aPath | 
			watching remove: aPath.
			watcher unwatch: aPath pathString ]
]

{ #category : #accessing }
GtFileWatcherEventLoop >> finalize [
	self stopLoop.
	Smalltalk unregisterExternalObject: semaphore.

	super finalize
]

{ #category : #accessing }
GtFileWatcherEventLoop >> gtStatusFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Status';
		priority: 1;
		items: [ self summaryAttributes ];
		column: #Attribute text: [ :item | item key ];
		column: #Value text: [ :item | item value ];
		send: [ :item | item value ];
		actionUpdateButton;
		actionButtonIcon: BrGlamorousVectorIcons play
			tooltip: 'Start'
			action: [ self startLoop ];
		actionButtonIcon: BrGlamorousVectorIcons cancel
			tooltip: 'Stop'
			action: [ self stopLoop ]
]

{ #category : #initialization }
GtFileWatcherEventLoop >> initialize [
	semaphore := Semaphore new.
	semaphoreIndex := Smalltalk registerExternalObject: semaphore.
	watcher := GtFileWatcher withSemaphore: semaphoreIndex.
	watching := OrderedCollection new.
	self class finalizationRegistry add: self
]

{ #category : #events }
GtFileWatcherEventLoop >> isRunning [
	^ process isNotNil
]

{ #category : #initialization }
GtFileWatcherEventLoop >> pollEvent [
	| anEvent |
	self assessWatchedFiles.
	anEvent := watcher poll.
	
	"anEvent can be nil when the watcher is being garbage collected"
	anEvent
		ifNotNil: [ announcer announce: (GtFileWatcherFileAnnouncement from: anEvent) ]
]

{ #category : #accessing }
GtFileWatcherEventLoop >> resumeOnStartup [
	semaphore := Semaphore new.
	semaphoreIndex := Smalltalk registerExternalObject: semaphore.
	watcher := GtFileWatcher withSemaphore: semaphoreIndex.

	process ifNotNil: [ self stopLoop startLoop ]
]

{ #category : #events }
GtFileWatcherEventLoop >> startLoop [
	process
		ifNil: [ process := (self class
					eventLoopFor: semaphore
					sending: (WeakMessageSend receiver: self selector: #pollEvent)) fork ]
]

{ #category : #events }
GtFileWatcherEventLoop >> stopLoop [
	process
		ifNotNil: [ process terminate.
			process := nil ]
]

{ #category : #initialization }
GtFileWatcherEventLoop >> subscribers [
	^ self announcer subscriptions subscriptions
]

{ #category : #accessing }
GtFileWatcherEventLoop >> summaryAttributes [
	^ {'Running' -> self isRunning.
		'Subscribers' -> self subscribers.
		'Watched Paths' -> self watchedPaths}
]

{ #category : #initialization }
GtFileWatcherEventLoop >> watch: aPath [
	watcher watch: aPath pathString.
	watching add: aPath
]

{ #category : #initialization }
GtFileWatcherEventLoop >> watchedPaths [
	^ watching
]
