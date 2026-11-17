Class {
	#name : 'BaselineOfPannEcolModel',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfPannEcolModel',
	#package : 'BaselineOfPannEcolModel'
}

{ #category : 'baselines' }
BaselineOfPannEcolModel >> baseline: spec [

	<baseline>
	spec for: #common do: [
		spec
			package: 'PannEcol-Model';
		
			package: 'PannEcol-Model-Charts'
			with: [ spec requires: #('PannEcol-Model') ] ]
]
