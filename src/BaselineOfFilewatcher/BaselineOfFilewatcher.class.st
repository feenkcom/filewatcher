Class {
	#name : #BaselineOfFilewatcher,
	#superclass : #BaselineOf,
	#category : #BaselineOfFilewatcher
}

{ #category : #baseline }
BaselineOfFilewatcher >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec
			baseline: 'GToolkitBoxer' with: [
				spec repository: 'github://feenkcom/gtoolkit-boxer:v0.8.51/boxer-bindings' ].
		spec
			baseline: 'GToolkitPhlowForRust' with: [
				spec repository: 'github://feenkcom/gt4phlow-rs:v0.6.3/src' ].

		spec package: 'GToolkit-Filewatcher' with: [
			spec requires: #('GToolkitBoxer' 'GToolkitPhlowForRust') ].
	]
]
