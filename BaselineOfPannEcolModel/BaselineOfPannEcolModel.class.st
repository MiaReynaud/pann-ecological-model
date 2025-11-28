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
			baseline: 'CormasGameServer'
			with: [ spec repository: 'github://cormas/cormas-game-server:main' ].
		
		spec
			package: 'PannEcol-Model'
			with: [ spec requires: #('CormasGameServer') ];
		
			package: 'PannEcol-Model-Charts'
			with: [ spec requires: #('PannEcol-Model') ] ]
]
