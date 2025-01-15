Class {
	#name : #GtFileWatcherEventLoopExamples,
	#superclass : #Object,
	#instVars : [
		'events',
		'toCleanup'
	],
	#category : #'GToolkit-Filewatcher-Examples'
}

{ #category : #accessing }
GtFileWatcherEventLoopExamples >> cleanUp [
	toCleanup stopLoop.
	toCleanup := nil.
	(Smalltalk imageDirectory / 'GtFileWatcherEventLoopExamples.txt')
		ensureDelete.
	events := OrderedCollection new
]

{ #category : #accessing }
GtFileWatcherEventLoopExamples >> eventLoopAnnouncer [
	<gtExample>
	| eventLoop announcer |
	eventLoop := self startedEventLoop.
	announcer := eventLoop announcer.
	
	self assert: announcer hasSubscriptions.
	
	^ announcer
]

{ #category : #accessing }
GtFileWatcherEventLoopExamples >> eventLoopWithEvent [
	<gtExample>
	| eventLoop aFile |
	eventLoop := self startedEventLoop.

	events := OrderedCollection new.

	aFile := Smalltalk imageDirectory / 'GtFileWatcherEventLoopExamples.txt'.

	aFile ensureCreateFile.

	1 second wait.

	"we get exactly one creation event for our file"
	self
		assert: (events select: [ :anEvent | anEvent paths first = aFile pathString ]) size
		equals: 1.

	^ eventLoop
]

{ #category : #accessing }
GtFileWatcherEventLoopExamples >> eventLoopWithSubscriber [
	<gtExample>
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
	| eventLoop |
	eventLoop := self eventLoopWithSubscriber.
	
	eventLoop watch: Smalltalk imageDirectory.
	
	self assert: eventLoop watchedPaths size equals: 1.
	
	^ eventLoop
]

{ #category : #accessing }
GtFileWatcherEventLoopExamples >> simpleEventLoop [
	<gtExample>
	<after: #cleanUp>
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
	| eventLoop |
	eventLoop := self eventLoopWithSubscriberAndWatchedPath.
	
	eventLoop startLoop.
	
	self assert: eventLoop isRunning.
	
	^ eventLoop
]

{ #category : #accessing }
GtFileWatcherEventLoopExamples >> stoppedEventLoop [
	<gtExample>
	| eventLoop |
	eventLoop := self startedEventLoop.
	
	eventLoop stopLoop.
	
	self assert: eventLoop isRunning not.
	
	^ eventLoop
]
