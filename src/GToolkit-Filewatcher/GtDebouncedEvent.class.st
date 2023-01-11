Class {
	#name : #GtDebouncedEvent,
	#superclass : #GtBoxerValueBox,
	#category : #'GToolkit-Filewatcher'
}

{ #category : #'library path' }
GtDebouncedEvent class >> ffiLibrary [
	^ GtFileWatcherLibrary
]

{ #category : #'private - ffi' }
GtDebouncedEvent class >> primRelease: aHandle [	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	^ self ffiCall: #(void filewatcher_destroy_event(void* aHandle))
]

{ #category : #accessing }
GtDebouncedEvent >> getPath [
	<return: #String>

	^ GtBoxerString getStringFrom: [ :aBoxerString | self primGetPath: aBoxerString ]
]

{ #category : #accessing }
GtDebouncedEvent >> getType [
	<return: #String>

	^ GtBoxerString getStringFrom: [ :aBoxerString | self primGetType: aBoxerString ]
]

{ #category : #accessing }
GtDebouncedEvent >> primGetPath: aGtBoxerString [
	^ self ffiCall: #(void filewatcher_event_path(GtDebouncedEvent self, GtBoxerString aGtBoxerString))
]

{ #category : #accessing }
GtDebouncedEvent >> primGetType: aGtBoxerString [
	^ self ffiCall: #(void filewatcher_event_type(GtDebouncedEvent self, GtBoxerString aGtBoxerString))
]
