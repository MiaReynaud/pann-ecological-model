Class {
	#name : 'EcoPannShellfishCohort',
	#superclass : 'CMAgent',
	#instVars : [
		'shellfishAge',
		'shellfishSize',
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
EcoPannShellfishCohort >> grow [

	| maxLength growthRate theoriticalInitialAge |
	
	maxLength := self sare maxShellfishLength.      		 		 "LInfinity"     "in mm"
	growthRate := self sare growthRate.             "K"
	theoriticalInitialAge := 0.0.      "t0"
	
	shellfishSize := maxLength * (1 - ((growthRate negated * (shellfishAge - theoriticalInitialAge)) exp)).

]

{ #category : 'initialize  ' }
EcoPannShellfishCohort >> initialize [ 
	super initialize.
	shellfishAge := 41. "according to the function a shellfish of 3mm is 41 days old"
	shellfishSize := 3. "in mm"
	shellfishDensity := 250. "in ind/m²"
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
EcoPannShellfishCohort >> population: anObject [

	population := anObject
]

{ #category : 'ecological methods  ' }
EcoPannShellfishCohort >> sare [ 

	^ population cell sare.
]

{ #category : 'accessing' }
EcoPannShellfishCohort >> shellfishDensity [

	^ shellfishDensity
]
