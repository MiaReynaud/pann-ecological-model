Class {
	#name : 'EcoPannSare',
	#superclass : 'CMSpatialEntityAggregate',
	#instVars : [
		'name',
		'recruitCapacity',
		'naturalDeathRate'
	],
	#category : 'PannEcol-Model',
	#package : 'PannEcol-Model'
}

{ #category : 'accessing' }
EcoPannSare >> initialize [ 

	super initialize. 
	
"defining values that will be overwriten"
	name := 'not named'.
	recruitCapacity := 0.
	naturalDeathRate := 0.
]

{ #category : 'accessing' }
EcoPannSare >> name [

	^ name
]

{ #category : 'accessing' }
EcoPannSare >> name: anObject [

	name := anObject
]

{ #category : 'accessing' }
EcoPannSare >> naturalDeathRate [

	^ naturalDeathRate
]

{ #category : 'accessing' }
EcoPannSare >> naturalDeathRate: anObject [

	naturalDeathRate := anObject
]

{ #category : 'accessing' }
EcoPannSare >> numberOfShellfishes [ 

	^ self plots sum: [ : plot | plot numberOfShellfishes ].
]

{ #category : 'accessing' }
EcoPannSare >> plots [ 

	^ self components.
]

{ #category : 'accessing' }
EcoPannSare >> recruitCapacity [

	^ recruitCapacity
]

{ #category : 'accessing' }
EcoPannSare >> recruitCapacity: anObject [

	recruitCapacity := anObject
]
