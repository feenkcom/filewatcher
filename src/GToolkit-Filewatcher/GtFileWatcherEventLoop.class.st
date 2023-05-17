Class {
	#name : #GtFileWatcherEventLoop,
	#superclass : #Object,
	#instVars : [
		'semaphore',
		'watcher',
		'semaphoreIndex',
		'process',
		'subscribers',
		'watching'
	],
	#category : #'GToolkit-Filewatcher-Core'
}

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
	| announcer |
	announcer := Announcer new.
	self onEvent: [:anEvent | announcer announce: (GtFileWatcherFileAnnouncement from: anEvent) ].
	^ announcer
]

{ #category : #accessing }
GtFileWatcherEventLoop >> finalize [
	self stopLoop.
	
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
	subscribers := OrderedCollection new.
	watching := OrderedCollection new
]

{ #category : #events }
GtFileWatcherEventLoop >> isRunning [
	^ process isNotNil
]

{ #category : #accessing }
GtFileWatcherEventLoop >> onEvent: aBlock [
	subscribers add: aBlock
]

{ #category : #initialization }
GtFileWatcherEventLoop >> pollEvent [
	| anEvent |
	anEvent := watcher poll.
	subscribers do: [ :aSubscriber | aSubscriber cull: anEvent ]
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
		ifNil: [ process := [ [ semaphore wait.
				self pollEvent ] repeat ] fork ]
]

{ #category : #events }
GtFileWatcherEventLoop >> stopLoop [
	process
		ifNotNil: [ process terminate.
			process := nil ]
]

{ #category : #initialization }
GtFileWatcherEventLoop >> subscribers [
	^ subscribers
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
