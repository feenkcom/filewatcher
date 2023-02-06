Class {
	#name : #GtUpdatingFileBrowser,
	#superclass : #BrFileSelector,
	#instVars : [
		'eventLoop'
	],
	#category : #'GToolkit-Filewatcher-File - UI'
}

{ #category : #accessing }
GtUpdatingFileBrowser >> finalize [
	eventLoop ifNotNil: [ eventLoop stopLoop ]
]

{ #category : #accessing }
GtUpdatingFileBrowser >> folder: aString [
	super folder: aString.
	self setEventLoop: aString.
]

{ #category : #accessing }
GtUpdatingFileBrowser >> handleEvent: anEvent [ 
	self updateDisplay
]

{ #category : #accessing }
GtUpdatingFileBrowser >> setEventLoop: aString [
	eventLoop ifNotNil: [ eventLoop stopLoop ].

	eventLoop := GtFileWatcherEventLoop new
			watch: aString;
			onEvent: [ :anEvent | self handleEvent: anEvent ];
			startLoop
]
