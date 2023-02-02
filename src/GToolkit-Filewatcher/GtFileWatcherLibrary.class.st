Class {
	#name : #GtFileWatcherLibrary,
	#superclass : #FFILibrary,
	#traits : 'TGtWithStringBox',
	#classTraits : 'TGtWithStringBox classTrait',
	#classInstVars : [
		'MouseWheelScrollSpeed'
	],
	#category : #'GToolkit-Filewatcher'
}

{ #category : #'library path' }
GtFileWatcherLibrary class >> ffiLibraryName [
	^ self
]

{ #category : #'class initialization' }
GtFileWatcherLibrary class >> initEnvLogger [
	self uniqueInstance initEnvLogger
]

{ #category : #'class initialization' }
GtFileWatcherLibrary class >> startUp: isANewSession [
	isANewSession
		ifTrue: [ self initEnvLogger ]
]

{ #category : #'api - library' }
GtFileWatcherLibrary >> detectLibrary: aFileName [
	"Pharo9 introduced a platform specific FFILibraryFinder which should be used instead of this custom implementation"

	^ ({ Smalltalk imageDirectory . Smalltalk vmDirectory . Smalltalk vmBinary parent / 'Plugins'. FileSystem workingDirectory }
		collect: [ :aPath | aPath asFileReference / aFileName ])
			detect: #exists
			ifFound: #fullName
			ifNone: [ aFileName ]
]

{ #category : #testing }
GtFileWatcherLibrary >> hasModule [
	"Return if there is a loadable and working Glutin library installed, false otherwise"
	<return: #Boolean>
	| aResult |

	aResult := nil.
	
	[ aResult := self primTest ]
		on: Error
		do: [ :e | aResult := false ].

	^ aResult ifNil: [ false ]
]

{ #category : #'api - logger' }
GtFileWatcherLibrary >> initEnvLogger [
	[ self primInitEnvLogger ]
		on: Error
		do: [ :e | NonInteractiveTranscript stdout nextPutAll: '[FileWatcher] Could not init env logger'; cr ]
]

{ #category : #'api - library' }
GtFileWatcherLibrary >> macLibraryName [
	^ self class environment
		at: #FFIMacLibraryFinder
		ifPresent: [ :aLibraryFinder | aLibraryFinder findLibrary: 'libfilewatcher.dylib' ]
		ifAbsent: [ self detectLibrary: 'libfilewatcher.dylib' ]
]

{ #category : #'private - ffi' }
GtFileWatcherLibrary >> primInitEnvLogger [
	^ self ffiCall: #(void filewatcher_init_env_logger())
]

{ #category : #'private - ffi' }
GtFileWatcherLibrary >> primTest [
	^ self ffiCall: #(bool filewatcher_test())
]

{ #category : #'api - library' }
GtFileWatcherLibrary >> unix32LibraryName [
	^ self class environment
		at: #FFIUnix32LibraryFinder
		ifPresent: [ :aLibraryFinder | aLibraryFinder findLibrary: 'libfilewatcher.so' ]
		ifAbsent: [ self detectLibrary: 'libfilewatcher.so' ]
]

{ #category : #'api - library' }
GtFileWatcherLibrary >> unix64LibraryName [
	^ self class environment
		at: #FFIUnix64LibraryFinder
		ifPresent: [ :aLibraryFinder | aLibraryFinder findLibrary: 'libfilewatcher.so' ]
		ifAbsent: [ self detectLibrary: 'libfilewatcher.so' ]
]

{ #category : #'api - library' }
GtFileWatcherLibrary >> win32LibraryName [
	^ self class environment
		at: #FFIWindowsLibraryFinder
		ifPresent: [ :aLibraryFinder | aLibraryFinder findAnyLibrary: #('filewatcher.dll' 'libfilewatcher.dll') ]
		ifAbsent: [ self detectLibrary: 'libfilewatcher.dll' ]
]
