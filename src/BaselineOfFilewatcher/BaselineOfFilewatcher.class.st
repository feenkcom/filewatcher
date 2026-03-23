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
				spec repository: 'github://feenkcom/gtoolkit-boxer:main/boxer-bindings' ].

		spec package: 'GToolkit-Filewatcher' with: [
				spec requires: #('GToolkitBoxer'). ]. ]
]
