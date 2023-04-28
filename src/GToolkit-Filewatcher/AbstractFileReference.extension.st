Extension { #name : #AbstractFileReference }

{ #category : #'*GToolkit-Filewatcher' }
AbstractFileReference >> watcher [
	^ GtFileWatcherEventLoop new watch: self
]
