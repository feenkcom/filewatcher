Class {
	#name : #GtFileWatcherRemovalAnnouncement,
	#superclass : #GtFileWatcherChangeAnnouncement,
	#category : #'GToolkit-Filewatcher-Core - Announcements'
}

{ #category : #accessing }
GtFileWatcherRemovalAnnouncement class >> dealsWith: anEvent [
	^ anEvent kind isRemove
]
