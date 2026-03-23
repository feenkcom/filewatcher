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
				spec repository: 'github://feenkcom/gtoolkit-boxer:v0.8.60/boxer-bindings' ].

		spec package: 'GToolkit-Filewatcher' with: [
			spec requires: #(#GToolkitBoxer) ].
	]
]
