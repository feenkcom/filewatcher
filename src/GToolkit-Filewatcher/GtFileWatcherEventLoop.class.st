Class {
	#name : #GtFileWatcherEventLoop,
	#superclass : #Object,
	#instVars : [
		'semaphore',
		'watcher',
		'semaphoreIndex',
		'process',
		'subscribers'
	],
	#category : #'GToolkit-Filewatcher'
}

{ #category : #initialization }
GtFileWatcherEventLoop >> initialize [
	semaphore := Semaphore new.
	semaphoreIndex := Smalltalk registerExternalObject: semaphore.
	watcher := GtFileWatcher withSemaphore: semaphoreIndex.
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
	process terminate
]

{ #category : #initialization }
GtFileWatcherEventLoop >> watch: aPath [
	watcher watch: aPath
]
