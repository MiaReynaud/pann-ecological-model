Class {
	#name : 'EcoPannPlot',
	#superclass : 'CMCell',
	#instVars : [
		'state',
		'area'
	],
	#category : 'PannEcol-Model',
	#package : 'PannEcol-Model'
}

{ #category : 'accessing' }
EcoPannPlot >> area [

	^ area
]

{ #category : 'accessing' }
EcoPannPlot >> area: anObject [

	area := anObject
]

{ #category : 'accessing' }
EcoPannPlot >> beMangrove [

	state := #mangrove
]

{ #category : 'accessing' }
EcoPannPlot >> beMudflat [

	state := #mudflat
]

{ #category : 'accessing' }
EcoPannPlot >> beSea [

	state := #sea
]

{ #category : 'accessing' }
EcoPannPlot >> beVillage [

	state := #village
]

{ #category : 'accessing' }
EcoPannPlot >> initialize [ 

	super initialize.
	area := 1. "m²" "just to avoid problems, but will be overwriten by the grid init method using the accessor area:"
]

{ #category : 'accessing' }
EcoPannPlot >> isMangrove [

	^ state = #mangrove
]

{ #category : 'accessing' }
EcoPannPlot >> isMudflat [

	^ state = #mudflat
]

{ #category : 'accessing' }
EcoPannPlot >> isSea [

	^ state = #sea
]

{ #category : 'accessing' }
EcoPannPlot >> isVillage [

	^ state = #village
]

{ #category : 'accessing' }
EcoPannPlot >> numberOfShellfishes [ 

	^ self shellfishPopulation numberOfShellfishes.
]

{ #category : 'accessing' }
EcoPannPlot >> pov [ 

	<pov>
	
	state = #sea ifTrue: [ ^ CMPointOfView color: '70EAFF' ].
	state = #village ifTrue: [ ^ CMPointOfView color: '8F1437' ].
	state = #mudflat ifTrue: [ ^ CMPointOfView color: 'FFFCB3' ].
	state = #mangrove ifTrue: [ ^ CMPointOfView color: '0DB370' ].
	
	^ super pov. "if no state, super pov by default"
]

{ #category : 'accessing' }
EcoPannPlot >> sare [
    "Return a sare to which this plot belongs"
    ^ self getAggregateType: EcoPannSare
]

{ #category : 'accessing' }
EcoPannPlot >> shellfishPopulation [
	"this method returns you the shellfish population in the cell "

	^ (self occupantsOfClass: EcoPannShellfishPopulation) first. "there can only be 1 population of shellfish on the cell, not more, not 0"
		
]

{ #category : 'accessing' }
EcoPannPlot >> state [

	^ state
]

{ #category : 'accessing' }
EcoPannPlot >> state: anObject [

	state := anObject
]
