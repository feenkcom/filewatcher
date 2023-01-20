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
GtFileWatcher class >> primCreateSignaller: aSignaller semaphore: anIndex [
	^ self ffiCall: #(void* filewatcher_create_watcher(void* aSignaller, int anIndex))
]

{ #category : #'private - ffi' }
GtFileWatcher class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	^ self ffiCall: #(void filewatcher_destroy_watcher(void* aHandle))
]

{ #category : #'private - ffi' }
GtFileWatcher class >> primSemaphoreSignaller [
]

{ #category : #'private - ffi' }
GtFileWatcher class >> primitiveGetSemaphoreSignaller [
	<primitive: 'primitiveGetSemaphoreSignaller'>

	^ ExternalAddress null
]

{ #category : #'private - ffi' }
GtFileWatcher class >> signaller: aSignaller semaphore: anIndex [
   ^ self fromNativeHandle: (self primCreateSignaller: aSignaller semaphore: anIndex)
]

{ #category : #'private - ffi' }
GtFileWatcher class >> withSemaphore: aSemaphoreIndex [
   ^ self
    signaller: self primitiveGetSemaphoreSignaller
    semaphore: aSemaphoreIndex
]

{ #category : #'private - ffi' }
GtFileWatcher >> poll [
	^ self primPoll
]

{ #category : #'private - ffi' }
GtFileWatcher >> primPoll [
	^ self ffiCall: #(GtFileWatcherEvent filewatcher_watcher_poll(GtFileWatcher self))
]

{ #category : #'private - ffi' }
GtFileWatcher >> primWatch: aGtBoxerString [
	^ self ffiCall: #(void filewatcher_watcher_watch(GtFileWatcher self, GtBoxerString aGtBoxerString))
]

{ #category : #'private - ffi' }
GtFileWatcher >> watch: aString [
	<return: #String>

	GtBoxerString fromString: aString during: [ :aBoxerString | self primWatch: aBoxerString ]
]
