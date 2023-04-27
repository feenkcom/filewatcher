Class {
	#name : #GtFileWatcherEventKind,
	#superclass : #GtBoxerValueBox,
	#category : #'GToolkit-Filewatcher-Core'
}

{ #category : #'library path' }
GtFileWatcherEventKind class >> ffiLibrary [
	^ GtFileWatcherLibrary uniqueInstance
]

{ #category : #'private - ffi' }
GtFileWatcherEventKind class >> primRelease: aHandle [
	"Plain pointers must be deleted using delete(), all users must implement a specific method"

	^ self ffiCall: #(void filewatcher_destroy_eventkind #(void * aHandle))
]

{ #category : #accessing }
GtFileWatcherEventKind >> gtName [
	self isAccess ifTrue: [ ^ 'Access' ]. 
	self isCreate ifTrue: [ ^ 'Creation' ]. 
	self isModify ifTrue: [ ^ 'Modification' ]. 
	self isRemove ifTrue: [ ^ 'Removal' ]. 
	self isAny ifTrue: [ ^ 'Any' ]. 
	self isOther ifTrue: [ ^ 'Other' ]. 
]

{ #category : #accessing }
GtFileWatcherEventKind >> gtNameFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Name';
		priority: 1;
		text: [ self gtName ]
]

{ #category : #accessing }
GtFileWatcherEventKind >> isAccess [
	^ self primIsAccess
]

{ #category : #accessing }
GtFileWatcherEventKind >> isAny [
	^ self primIsAny
]

{ #category : #accessing }
GtFileWatcherEventKind >> isCreate [
	^ self primIsCreate
]

{ #category : #accessing }
GtFileWatcherEventKind >> isModify [
	^ self primIsModify
]

{ #category : #accessing }
GtFileWatcherEventKind >> isOther [
	^ self primIsOther
]

{ #category : #accessing }
GtFileWatcherEventKind >> isRemove [
	^ self primIsRemove
]

{ #category : #accessing }
GtFileWatcherEventKind >> primIsAccess [
	^ self ffiCall: #(bool filewatcher_eventkind_is_access #(self))
]

{ #category : #accessing }
GtFileWatcherEventKind >> primIsAny [
	^ self ffiCall: #(bool filewatcher_eventkind_is_any #(self))
]

{ #category : #accessing }
GtFileWatcherEventKind >> primIsCreate [
	^ self ffiCall: #(bool filewatcher_eventkind_is_create #(self))
]

{ #category : #accessing }
GtFileWatcherEventKind >> primIsModify [
	^ self ffiCall: #(bool filewatcher_eventkind_is_modify #(self))
]

{ #category : #accessing }
GtFileWatcherEventKind >> primIsOther [
	^ self ffiCall: #(bool filewatcher_eventkind_is_other #(self))
]

{ #category : #accessing }
GtFileWatcherEventKind >> primIsRemove [
	^ self ffiCall: #(bool filewatcher_eventkind_is_remove #(self))
]
