Class {
	#name : #GtFileWatcherFileAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'paths'
	],
	#category : #'GToolkit-Filewatcher-Core - Announcements'
}

{ #category : #accessing }
GtFileWatcherFileAnnouncement class >> dealsWith: anEvent [
	^ self subclassResponsibility
]

{ #category : #'instance creation' }
GtFileWatcherFileAnnouncement class >> for: anEvent [
	^ self new event: anEvent
]

{ #category : #'instance creation' }
GtFileWatcherFileAnnouncement class >> from: anEvent [
	self
		allSubclassesDo: [ :aClass | (aClass dealsWith: anEvent) ifTrue: [ ^ aClass for: anEvent ] ].
	^ self error: 'No announcement for event ', anEvent asString
]

{ #category : #accessing }
GtFileWatcherFileAnnouncement >> event: anEvent [
	paths := anEvent paths
]

{ #category : #'as yet unclassified' }
GtFileWatcherFileAnnouncement >> isChange [
	^ false
]

{ #category : #accessing }
GtFileWatcherFileAnnouncement >> paths [
	^ paths
]
