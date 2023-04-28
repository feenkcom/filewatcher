Class {
	#name : #GtFileWatcherOtherAnnouncement,
	#superclass : #GtFileWatcherFileAnnouncement,
	#category : #'GToolkit-Filewatcher-Core - Announcements'
}

{ #category : #accessing }
GtFileWatcherOtherAnnouncement class >> dealsWith: anEvent [
	^ anEvent kind isAny or: [ anEvent kind isOther ]
]
