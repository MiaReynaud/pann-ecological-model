Class {
	#name : 'PannSar',
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
PannSar >> name [

	^ name
]

{ #category : 'accessing' }
PannSar >> name: anObject [

	name := anObject
]

{ #category : 'accessing' }
PannSar >> naturalDeathRate [

	^ naturalDeathRate
]

{ #category : 'accessing' }
PannSar >> naturalDeathRate: anObject [

	naturalDeathRate := anObject
]

{ #category : 'accessing' }
PannSar >> recruitCapacity [

	^ recruitCapacity
]

{ #category : 'accessing' }
PannSar >> recruitCapacity: anObject [

	recruitCapacity := anObject
]
