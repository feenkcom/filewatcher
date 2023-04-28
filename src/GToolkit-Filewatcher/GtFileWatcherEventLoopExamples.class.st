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
		ensureDelete
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
			self assert: anEvent kind isCreate.
			events add: anEvent ].

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
