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
EcoPannShellfishCohort >> death [

	| M N0 t |
	
	N0 :=  self sare recruitCapacity.             "initial density"
	M := self sare naturalDeathRate.     			 	"daily mortality rate. Comes from Abdou Karim data analysed with TropFishR"
	t := shellfishAge.            "cohort age"
	
shellfishDensity := N0 * ((M * t) negated exp). 
]

{ #category : 'ecological methods  ' }
EcoPannShellfishCohort >> grow [

	| LInfinity K t0 |
	
	LInfinity := 38.      "in mm"
	K := 0.00203.             "growth rate"
	t0 := 0.0.            "theoritical initial age"
	
	shellfishSize := LInfinity * (1 - ((K negated * (shellfishAge - t0)) exp)).

]

{ #category : 'initialize  ' }
EcoPannShellfishCohort >> initialize [ 
	super initialize.
	shellfishAge := 41. "according to the function a shellfish of 3mm is 41 days old"
	shellfishSize := 3. "in mm"
	shellfishDensity := 250. "in ind/m²"
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
