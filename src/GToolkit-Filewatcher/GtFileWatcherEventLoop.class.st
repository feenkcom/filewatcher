Class {
	#name : #GtFileWatcherEventLoop,
	#superclass : #Object,
	#instVars : [
		'semaphore',
		'watcher',
		'semaphoreIndex',
		'onEvent',
		'process'
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
	onEvent := aBlock
]

{ #category : #initialization }
GtFileWatcherEventLoop >> pollEvent [
	onEvent cull: watcher poll
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
