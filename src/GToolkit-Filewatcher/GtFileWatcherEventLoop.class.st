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

{ #category : #events }
GtFileWatcherEventLoop >> startLoop [
	process := [ [
	semaphore wait.
	self pollEvent ] repeat ] fork
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

{ #category : #initialization }
GtFileWatcherEventLoop >> watch: aPath [
	watcher watch: aPath.
	watching add: aPath
]

{ #category : #initialization }
GtFileWatcherEventLoop >> watchedPaths [
	^ watching
]
