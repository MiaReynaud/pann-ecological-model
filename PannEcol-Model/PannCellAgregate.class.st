Class {
	#name : 'PannCellAgregate',
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
PannCellAgregate >> name [

	^ name
]

{ #category : 'accessing' }
PannCellAgregate >> name: anObject [

	name := anObject
]

{ #category : 'accessing' }
PannCellAgregate >> naturalDeathRate [

	^ naturalDeathRate
]

{ #category : 'accessing' }
PannCellAgregate >> naturalDeathRate: anObject [

	naturalDeathRate := anObject
]

{ #category : 'accessing' }
PannCellAgregate >> recruitCapacity [

	^ recruitCapacity
]

{ #category : 'accessing' }
PannCellAgregate >> recruitCapacity: anObject [

	recruitCapacity := anObject
]
