Class {
	#name : #GtFileWatcherReadAnnouncement,
	#superclass : #GtFileWatcherFileAnnouncement,
	#category : #'GToolkit-Filewatcher-Core - Announcements'
}

{ #category : #accessing }
GtFileWatcherReadAnnouncement class >> dealsWith: anEvent [
	^ anEvent kind isAccess
]
