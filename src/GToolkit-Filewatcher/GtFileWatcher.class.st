Class {
	#name : #GtFileWatcher,
	#superclass : #GtBoxerValueBox,
	#category : #'GToolkit-Filewatcher'
}

{ #category : #'library path' }
GtFileWatcher class >> ffiLibrary [
	^ GtFileWatcherLibrary
]

{ #category : #'private - ffi' }
GtFileWatcher class >> primCreate [
	^ self ffiCall: #(void* filewatcher_create_watcher())
]

{ #category : #'private - ffi' }
GtFileWatcher class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	^ self ffiCall: #(void filewatcher_destroy_watcher(void* aHandle))
]

{ #category : #'private - ffi' }
GtFileWatcher >> primReceiveEvent [
	^ self ffiCall: #(GtDebouncedEvent filewatcher_watcher_watch(GtFileWatcher self))
]

{ #category : #'private - ffi' }
GtFileWatcher >> primWatch: aGtBoxerString [
	^ self ffiCall: #(void filewatcher_watcher_watch(GtFileWatcher self, GtBoxerString aGtBoxerString))
]

{ #category : #'private - ffi' }
GtFileWatcher >> receiveEvent [
	^ self primReceiveEvent
]

{ #category : #'private - ffi' }
GtFileWatcher >> watch: aString [
	<return: #String>

	GtBoxerString fromString: aString during: [ :aBoxerString | self primWatch: aBoxerString ]
]
