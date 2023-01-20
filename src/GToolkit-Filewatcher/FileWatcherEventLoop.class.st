Class {
	#name : #FileWatcherEventLoop,
	#superclass : #Object,
	#instVars : [
		'semaphore',
		'watcher',
		'semaphoreIndex',
		'onEvent'
	],
	#category : #'GToolkit-Filewatcher'
}

{ #category : #initialization }
FileWatcherEventLoop >> initialize [
	semaphore := Semaphore new.
	semaphoreIndex := Smalltalk registerExternalObject: semaphore.
	watcher := GtFileWatcher withSemaphore: semaphoreIndex.
]

{ #category : #accessing }
FileWatcherEventLoop >> onEvent: aBlock [
	onEvent := aBlock
]

{ #category : #initialization }
FileWatcherEventLoop >> pollEvent [
	onEvent cull: watcher poll
]

{ #category : #events }
FileWatcherEventLoop >> startLoop [
	[ [
	semaphore wait.
	self pollEvent ] repeat ] fork
]

{ #category : #initialization }
FileWatcherEventLoop >> watch: aPath [
	watcher watch: aPath
]
