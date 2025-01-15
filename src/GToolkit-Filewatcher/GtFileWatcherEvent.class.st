Class {
	#name : #GtFileWatcherEvent,
	#superclass : #GtBoxerValueBox,
	#category : #'GToolkit-Filewatcher-Core'
}

{ #category : #'library path' }
GtFileWatcherEvent class >> ffiLibrary [
	^ GtFileWatcherLibrary uniqueInstance
]

{ #category : #'private - ffi' }
GtFileWatcherEvent class >> primRelease: aHandle [
	"Plain pointers must be deleted using delete(), all users must implement a specific method"

	^ self ffiCall: #(void filewatcher_destroy_event #(void * aHandle))
]

{ #category : #accessing }
GtFileWatcherEvent >> gtKindFor: aView [
	<gtView>
	^ aView forward
		title: 'Kind';
		priority: 1;
		object: [ self kind ];
		view: #gtNameFor:
]

{ #category : #accessing }
GtFileWatcherEvent >> gtPathsFor: aView [
	<gtView>
	^ aView list
		title: 'Paths';
		priority: 2;
		items: [ self paths ]
]

{ #category : #accessing }
GtFileWatcherEvent >> kind [
	^ self primKind
]

{ #category : #accessing }
GtFileWatcherEvent >> pathAt: anIndex [
	^ self ffiLibrary
		getStringFrom: [ :aBoxerString | 
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

{ #category : #accessing }
GtFileWatcherEvent >> pathsDo: aBlock [
	| size |
	size := self pathSize.
	1 to: size do: [ :idx | aBlock value: (self pathAt: idx) ]
]

{ #category : #'private - ffi' }
GtFileWatcherEvent >> primKind [
	^ self ffiCall: #(GtFileWatcherEventKind filewatcher_event_kind(self))
]

{ #category : #'private - ffi' }
GtFileWatcherEvent >> primPathAt: anIndex withString: aBoxerString [
	self ffiCall: #(void filewatcher_event_path_at(self, GtBoxerString aBoxerString, int anIndex))
]

{ #category : #'private - ffi' }
GtFileWatcherEvent >> primPathSize [
	^ self ffiCall: #(int filewatcher_event_path_size(self))
]
