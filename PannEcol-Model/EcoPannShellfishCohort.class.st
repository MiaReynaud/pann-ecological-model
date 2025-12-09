Class {
	#name : 'EcoPannShellfishCohort',
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
EcoPannShellfishCohort >> aging [ 

	shellfishAge := shellfishAge + 1.
]

{ #category : 'ecological methods  ' }
EcoPannShellfishCohort >> growBiomass [

	| a b |
	
	a := 0.08.
	b := 2.72.

	oneIndividualTotalBiomass := ((a * shellfishSize) raisedTo: b). "g"

]

{ #category : 'ecological methods  ' }
EcoPannShellfishCohort >> growSize [

	| maxLength growthRate theoriticalInitialAge |
	
	maxLength := self sare maxShellfishLength.      "LInfinity"     "in mm"
	growthRate := self sare growthRate.             "K"
	theoriticalInitialAge := 0.0.      				  "t0"
	
	shellfishSize := maxLength * (1 - ((growthRate negated * (shellfishAge - theoriticalInitialAge)) exp)).

]

{ #category : 'initialize  ' }
EcoPannShellfishCohort >> initialize [ 

	| a b |

	super initialize.
	shellfishAge := 41. "according to the function a shellfish of 3mm is 41 days old"
	shellfishSize := 3. "in mm"
	
	a := 0.08.
	b := 2.72.
	oneIndividualTotalBiomass := ((a * shellfishSize) raisedTo: b). "g"
]

{ #category : 'ecological methods  ' }
EcoPannShellfishCohort >> naturalDeath [

	| initialDensity dailyMortalityRate cohortAge |
	
	initialDensity :=  self sare recruitCapacity.    "N0"
	dailyMortalityRate := self sare naturalDeathRate.	"M" 	"Comes from Abdou Karim data analysed with TropFishR"
	cohortAge := shellfishAge.         "t"
	
shellfishDensity := initialDensity * ((dailyMortalityRate * cohortAge) negated exp). 
]

{ #category : 'initialize  ' }
EcoPannShellfishCohort >> numberOfShellfishes [
	^ population cell area * shellfishDensity.
]

{ #category : 'accessing' }
EcoPannShellfishCohort >> oneIndividualTotalBiomass [

	^ oneIndividualTotalBiomass
]

{ #category : 'accessing' }
EcoPannShellfishCohort >> population: anObject [

	population := anObject
]

{ #category : 'fishing methods ' }
EcoPannShellfishCohort >> removeShellfish: aNumber [
 "remove this number of shellfishes from the cohort"

	shellfishDensity := shellfishDensity - (aNumber / population cell area).

]

{ #category : 'ecological methods  ' }
EcoPannShellfishCohort >> sare [ 

	^ population cell sare.
]

{ #category : 'accessing' }
EcoPannShellfishCohort >> shellfishAge [

	^ shellfishAge
]

{ #category : 'accessing' }
EcoPannShellfishCohort >> shellfishAge: anObject [

	shellfishAge := anObject
]

{ #category : 'accessing' }
EcoPannShellfishCohort >> shellfishDensity [

	^ shellfishDensity
]

{ #category : 'accessing' }
EcoPannShellfishCohort >> shellfishDensity: anObject [

	shellfishDensity := anObject
]

{ #category : 'accessing' }
EcoPannShellfishCohort >> shellfishSize [

	^ shellfishSize
]

{ #category : 'accessing' }
EcoPannShellfishCohort >> shellfishSize: anObject [

	shellfishSize := anObject
]

{ #category : 'step   ' }
EcoPannShellfishCohort >> step [ 

	self aging.
	self growSize.
	self growBiomass.
	self naturalDeath.
]
