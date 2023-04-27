Class {
	#name : #BaselineOfFilewatcher,
	#superclass : #BaselineOf,
	#category : #BaselineOfFilewatcher
}

{ #category : #accessing }
BaselineOfFilewatcher >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec 
			baseline: 'GToolkitBoxer' with: [
				spec repository: 'github://feenkcom/gtoolkit-boxer:main/boxer-bindings' ];
			baseline: 'GToolkitPhlowForRust' with: [
				spec repository: 'github://feenkcom/gt4phlow-rs:main/src' ].

		spec package: 'GToolkit-Filewatcher' with: [
				spec requires: #('GToolkitBoxer' 'GToolkitPhlowForRust'). ]. ]
]
