Class {
	#name : #GtFileWatcherChangeAnnouncement,
	#superclass : #GtFileWatcherFileAnnouncement,
	#category : #'GToolkit-Filewatcher-Core - Announcements'
}

{ #category : #accessing }
GtFileWatcherChangeAnnouncement class >> dealsWith: anEvent [
	^ false
]

{ #category : #'as yet unclassified' }
GtFileWatcherChangeAnnouncement >> isChange [
	^ true
]
