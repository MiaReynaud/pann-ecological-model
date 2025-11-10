Class {
	#name : 'PannCell',
	#superclass : 'CMCell',
	#instVars : [
		'state'
	],
	#category : 'PannEcol-Model',
	#package : 'PannEcol-Model'
}

{ #category : 'accessing' }
PannCell >> beMudflat [

	state := #mudflat
]

{ #category : 'accessing' }
PannCell >> initialize [ 

	super initialize.
]

{ #category : 'accessing' }
PannCell >> isMudflat [

	^ state = #mudflat
]

{ #category : 'accessing' }
PannCell >> pov [ 

	<pov>
	
	state = #mudflat ifTrue: [ ^ CMPointOfView color: 'FFFCB3' ].

	
	^ super pov. "if no state, super pov by default"
]

{ #category : 'accessing' }
PannCell >> sare [
    "Return a sare to which this plot belongs"
    ^ self getAggregateType: PannCellAgregate
]

{ #category : 'accessing' }
PannCell >> shellfishPopulation [
	"this method returns you the shellfish population in the cell "

	^ (self occupantsOfClass: PannPopulation) first. "there can only be 1 population of shellfish on the cell, not more, not 0"
		
]

{ #category : 'accessing' }
PannCell >> state [

	^ state
]

{ #category : 'accessing' }
PannCell >> state: anObject [

	state := anObject
]
