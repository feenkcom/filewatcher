Class {
	#name : #GtFileWatcherModificationAnnouncement,
	#superclass : #GtFileWatcherChangeAnnouncement,
	#category : #'GToolkit-Filewatcher-Core - Announcements'
}

{ #category : #accessing }
GtFileWatcherModificationAnnouncement class >> dealsWith: anEvent [
	^ anEvent kind isModify
]
