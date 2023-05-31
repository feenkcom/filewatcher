Class {
	#name : #GtFileWatcherAnnouncer,
	#superclass : #Announcer,
	#instVars : [
		'eventLoop'
	],
	#category : #'GToolkit-Filewatcher-Core'
}

{ #category : #accessing }
GtFileWatcherAnnouncer >> eventLoop [
	^ eventLoop
]

{ #category : #accessing }
GtFileWatcherAnnouncer >> eventLoop: anObject [
	eventLoop := anObject.
	self registerToEventLoop
]

{ #category : #accessing }
GtFileWatcherAnnouncer >> registerToEventLoop [
	self eventLoop
		onEvent: [ :anEvent | self announce: (GtFileWatcherFileAnnouncement from: anEvent) ]
]
