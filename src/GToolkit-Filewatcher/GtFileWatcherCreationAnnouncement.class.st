Class {
	#name : #GtFileWatcherCreationAnnouncement,
	#superclass : #GtFileWatcherChangeAnnouncement,
	#category : #'GToolkit-Filewatcher-Core - Announcements'
}

{ #category : #accessing }
GtFileWatcherCreationAnnouncement class >> dealsWith: anEvent [
	^ anEvent kind isCreate
]
