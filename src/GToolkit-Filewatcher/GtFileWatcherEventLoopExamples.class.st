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
GtFileWatcherEventLoopExamples >> announcerWithEvent [
	<gtExample>
	| announcer announcerEvents |
	announcer := self eventLoopAnnouncer.
	announcerEvents := OrderedCollection new.

	announcer
		when: GtFileWatcherFileAnnouncement
		do: [  :anEvent |
			"we get other event kinds here, so we filter"
			anEvent isChange ifTrue: [ announcerEvents add: anEvent ] ].

	(Smalltalk imageDirectory / 'GtFileWatcherEventLoopExamples.txt')
		ensureCreateFile.

	1 second wait.

	self assert: events size equals: 1.
	self assert: announcerEvents size equals: 1.
	self
		assert: announcerEvents first paths first
		equals: (Smalltalk imageDirectory / 'GtFileWatcherEventLoopExamples.txt') pathString.

	^ announcer
]

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
	
	self assert: announcer hasSubscriptions not.
	
	^ announcer
]

{ #category : #accessing }
GtFileWatcherEventLoopExamples >> eventLoopWithEvent [
	<gtExample>
	| eventLoop |
	eventLoop := self startedEventLoop.
	
	(Smalltalk imageDirectory / 'GtFileWatcherEventLoopExamples.txt') ensureCreateFile.
	
	1 second wait.
	
	self assert: events size equals: 1.
	
	^ eventLoop
]

{ #category : #accessing }
GtFileWatcherEventLoopExamples >> eventLoopWithSubscriber [
	<gtExample>
	| eventLoop |
	eventLoop := self simpleEventLoop.

	events := OrderedCollection new.

	eventLoop
		onEvent: [ :anEvent |
			"we get other event kinds here, so we filter"
			anEvent kind isCreate ifTrue: [ events add: anEvent ] ].

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
