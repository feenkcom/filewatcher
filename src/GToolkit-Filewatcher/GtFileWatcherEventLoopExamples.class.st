Class {
	#name : #GtFileWatcherEventLoopExamples,
	#superclass : #Object,
	#instVars : [
		'events',
		'toCleanup',
		'watchedDirectory'
	],
	#category : #'GToolkit-Filewatcher-Examples'
}

{ #category : #accessing }
GtFileWatcherEventLoopExamples >> cleanUp [
	toCleanup stopLoop.
	toCleanup := nil.
	watchedDirectory ifNotNil: #ensureDeleteAll.
	events := OrderedCollection new
]

{ #category : #accessing }
GtFileWatcherEventLoopExamples >> eventLoopAnnouncer [
	<gtExample>
	<return: #GtFileWatcherAnnouncer>
	| eventLoop announcer |
	eventLoop := self startedEventLoop.
	announcer := eventLoop announcer.

	self assert: announcer hasSubscriptions.

	^ announcer
]

{ #category : #accessing }
GtFileWatcherEventLoopExamples >> eventLoopWithEvent [
	<gtExample>
	<return: #GtFileWatcherEventLoop>
	| eventLoop aFile |
	eventLoop := self startedEventLoop.

	events := OrderedCollection new.

	aFile := self watchedDirectory / 'GtFileWatcherEventLoopExamples.txt'.

	aFile ensureCreateFile.

	1 second wait.	"we get exactly one creation event for our file"
	self
		assert: (events select: [ :anEvent | anEvent paths first = aFile pathString ]) size
		equals: 1.

	^ eventLoop
]

{ #category : #accessing }
GtFileWatcherEventLoopExamples >> eventLoopWithSubscriber [
	<gtExample>
	<return: #GtFileWatcherEventLoop>
	| eventLoop |
	eventLoop := self simpleEventLoop.

	events := OrderedCollection new.

	eventLoop announcer
		when: GtFileWatcherCreationAnnouncement
		do: [ :anEvent | events add: anEvent ].

	self assert: eventLoop subscribers size equals: 1.

	^ eventLoop
]

{ #category : #accessing }
GtFileWatcherEventLoopExamples >> eventLoopWithSubscriberAndWatchedPath [
	<gtExample>
	<return: #GtFileWatcherEventLoop>
	| eventLoop |
	eventLoop := self eventLoopWithSubscriber.

	eventLoop watch: self watchedDirectory.

	self assert: eventLoop watchedPaths size equals: 1.

	^ eventLoop
]

{ #category : #accessing }
GtFileWatcherEventLoopExamples >> simpleEventLoop [
	<gtExample>
	<after: #cleanUp>
	<return: #GtFileWatcherEventLoop>
	| eventLoop |
	eventLoop := GtFileWatcherEventLoop new.
	toCleanup := eventLoop.

	self assert: eventLoop subscribers size equals: 0.
	self assert: eventLoop watchedPaths size equals: 0.

	^ eventLoop
]

{ #category : #accessing }
GtFileWatcherEventLoopExamples >> startedEventLoop [
	<gtExample>
	<return: #GtFileWatcherEventLoop>
	| eventLoop |
	eventLoop := self eventLoopWithSubscriberAndWatchedPath.

	eventLoop startLoop.

	self assert: eventLoop isRunning.

	^ eventLoop
]

{ #category : #accessing }
GtFileWatcherEventLoopExamples >> stoppedEventLoop [
	<gtExample>
	<return: #GtFileWatcherEventLoop>
	| eventLoop |
	eventLoop := self startedEventLoop.

	eventLoop stopLoop.

	self assert: eventLoop isRunning not.

	^ eventLoop
]

{ #category : #accessing }
GtFileWatcherEventLoopExamples >> watchedDirectory [
	^ watchedDirectory
		ifNil: [ watchedDirectory := (FileLocator imageDirectory / UUID new asString) createDirectory ]
]
