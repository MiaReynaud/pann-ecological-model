Class {
	#name : 'PannPlo',
	#superclass : 'CMCell',
	#instVars : [
		'state'
	],
	#category : 'PannEcol-Model',
	#package : 'PannEcol-Model'
}

{ #category : 'accessing' }
PannPlo >> beMudflat [

	state := #mudflat
]

{ #category : 'accessing' }
PannPlo >> initialize [ 

	super initialize.
]

{ #category : 'accessing' }
PannPlo >> isMudflat [

	^ state = #mudflat
]

{ #category : 'accessing' }
PannPlo >> pov [ 

	<pov>
	
	state = #mudflat ifTrue: [ ^ CMPointOfView color: 'FFFCB3' ].

	
	^ super pov. "if no state, super pov by default"
]

{ #category : 'accessing' }
PannPlo >> sare [
    "Return a sare to which this plot belongs"
    ^ self getAggregateType: PannSar
]

{ #category : 'accessing' }
PannPlo >> shellfishPopulation [
	"this method returns you the shellfish population in the cell "

	^ (self occupantsOfClass: PannShellfishPop) first. "there can only be 1 population of shellfish on the cell, not more, not 0"
		
]

{ #category : 'accessing' }
PannPlo >> state [

	^ state
]

{ #category : 'accessing' }
PannPlo >> state: anObject [

	state := anObject
]
