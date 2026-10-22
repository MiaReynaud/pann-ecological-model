Class {
	#name : 'PannShellfishCohort',
	#superclass : 'CMAgent',
	#instVars : [
		'shellfishAge',
		'shellfishSize',
		'oneIndividualTotalBiomass',
		'shellfishDensity',
		'population'
	],
	#category : 'PannEcol-Model',
	#package : 'PannEcol-Model'
}

{ #category : 'ecological methods  ' }
PannShellfishCohort >> aging [ 

	shellfishAge := shellfishAge + 1.
]

{ #category : 'ecological methods  ' }
PannShellfishCohort >> growBiomass [

	| a b |
	
	a := 0.08.
	b := 2.72.

	oneIndividualTotalBiomass := ((a * shellfishSize) raisedTo: b). "g"

	oneIndividualTotalBiomass := oneIndividualTotalBiomass rounded.
]

{ #category : 'ecological methods  ' }
PannShellfishCohort >> growSize [

	| maxLength growthRate theoriticalInitialAge |
	
	maxLength := self sare maxShellfishLength.      "LInfinity"     "in mm"
	growthRate := self sare growthRate.             "K"
	theoriticalInitialAge := 0.0.      				  "t0"
	
	shellfishSize := maxLength * (1 - ((growthRate negated * (shellfishAge - theoriticalInitialAge)) exp)).

	shellfishSize := shellfishSize rounded.
]

{ #category : 'initialize  ' }
PannShellfishCohort >> initialize [ 

	| a b |

	super initialize.
	shellfishAge := 41. "according to the function a shellfish of 3mm is 41 days old"
	shellfishSize := 3. "in mm"
	
	a := 0.08.
	b := 2.72.
	oneIndividualTotalBiomass := ((a * shellfishSize) raisedTo: b). "g"
]

{ #category : 'ecological methods  ' }
PannShellfishCohort >> naturalDeath [

	| dailyMortalityRate |
	
	dailyMortalityRate := self sare naturalDeathRate.	"M" 	"Comes from Abdou Karim data analysed with TropFishR"

    shellfishDensity := shellfishDensity * (dailyMortalityRate negated exp).

	shellfishDensity := shellfishDensity roundTo: 0.0001.
]

{ #category : 'initialize  ' }
PannShellfishCohort >> numberOfShellfishes [
	^ population cell area * shellfishDensity.
]

{ #category : 'accessing' }
PannShellfishCohort >> oneIndividualTotalBiomass [

	^ oneIndividualTotalBiomass
]

{ #category : 'accessing' }
PannShellfishCohort >> population: anObject [

	population := anObject
]

{ #category : 'fishing methods ' }
PannShellfishCohort >> removeShellfish: aNumber [
 "remove this number of shellfishes from the cohort"

	shellfishDensity := shellfishDensity - (aNumber / population cell area).

	shellfishDensity := shellfishDensity roundTo: 0.0001
]

{ #category : 'ecological methods  ' }
PannShellfishCohort >> sare [ 

	^ population cell sare.
]

{ #category : 'accessing' }
PannShellfishCohort >> shellfishAge [

	^ shellfishAge
]

{ #category : 'accessing' }
PannShellfishCohort >> shellfishAge: anObject [

	shellfishAge := anObject
]

{ #category : 'accessing' }
PannShellfishCohort >> shellfishDensity [

	^ shellfishDensity
]

{ #category : 'accessing' }
PannShellfishCohort >> shellfishDensity: anObject [

	shellfishDensity := anObject
]

{ #category : 'accessing' }
PannShellfishCohort >> shellfishSize [

	^ shellfishSize
]

{ #category : 'accessing' }
PannShellfishCohort >> shellfishSize: anObject [

	shellfishSize := anObject
]

{ #category : 'step   ' }
PannShellfishCohort >> step [ 

	self aging.
	self growSize.
	self growBiomass.
	self naturalDeath.
]
