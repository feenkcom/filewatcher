Class {
	#name : #GtFileWatcherEventKind,
	#superclass : #GtBoxerValueBox,
	#category : #'GToolkit-Filewatcher'
}

{ #category : #'private - ffi' }
GtFileWatcherEventKind class >> primRelease: aHandle [
	"Plain pointers must be deleted using delete(), all users must implement a specific method"

	^ self ffiCall: #(void filewatcher_destroy_eventkind #(void * aHandle))
]
