Class {
	#name : #GtFileWatcherEvent,
	#superclass : #GtBoxerValueBox,
	#category : #'GToolkit-Filewatcher'
}

{ #category : #'private - ffi' }
GtFileWatcherEvent class >> primRelease: aHandle [
	"Plain pointers must be deleted using delete(), all users must implement a specific method"

	^ self ffiCall: #(void filewatcher_destroy_event #(void * aHandle))
]

{ #category : #accessing }
GtFileWatcherEvent >> kind [
	^ self primKind
]

{ #category : #accessing }
GtFileWatcherEvent >> pathAt: anIndex [
	^ GtBoxerString
		fromString: ''
		during: [ :aBoxerString | 
			self primPathAt: anIndex - 1 withString: aBoxerString.
			aBoxerString string ]
]

{ #category : #accessing }
GtFileWatcherEvent >> pathSize [
	^ self primPathSize
]

{ #category : #accessing }
GtFileWatcherEvent >> paths [
	| size res |
	size := self pathSize.
	res := Array new: size.
	1 to: size do: [:idx |
		res at: 1 put: (self pathAt: idx)
	].
	^ res
]

{ #category : #'private - ffi' }
GtFileWatcherEvent >> primKind [
	^ self ffiCall: #(GtFileWatcherEventKind filewatcher_event_kind(self))
]

{ #category : #'private - ffi' }
GtFileWatcherEvent >> primPathAt: anIndex withString: aBoxerString [
	self ffiCall: #(void filewatcher_event_path_size(self, BoxerString aBoxerString, int anIndex))
]

{ #category : #'private - ffi' }
GtFileWatcherEvent >> primPathSize [
	^ self ffiCall: #(int filewatcher_event_path_size(self))
]
