Class {
	#name : 'PannCohort',
	#superclass : 'CMAgent',
	#instVars : [
		'shellfishAge',
		'shellfishSize',
		'shellfishDensity',
		'sare'
	],
	#category : 'PannEcol-Model',
	#package : 'PannEcol-Model'
}

{ #category : 'accessing' }
PannCohort >> aging [ 

	shellfishAge := shellfishAge + 1.
]

{ #category : 'accessing' }
PannCohort >> death [

	| M N0 t sare |
	
"	sare := ( self cell @@ PannSar )."
	
	N0 :=  "sare recruitCapacity" 250 .             "initial density"
	M := 0.00219 .     			 	"daily mortality rate. Comes from Abdou Karim data analysed with TropFishR"
	t := shellfishAge.            "cohort age"
	
shellfishDensity := N0 * ((M * t) negated exp). 
]

{ #category : 'accessing' }
PannCohort >> grow [

	| LInfinity K t0 |
	
	LInfinity := 38.      "in mm"
	K := 0.00203.             "growth rate"
	t0 := 0.0.            "theoritical initial age"
	
	shellfishSize := LInfinity * (1 - ((K negated * (shellfishAge - t0)) exp)).

]

{ #category : 'accessing' }
PannCohort >> naturalDeath [




]

{ #category : 'accessing' }
PannCohort >> sare [

	^ sare
]

{ #category : 'accessing' }
PannCohort >> sare: anObject [

	sare := anObject
]

{ #category : 'accessing' }
PannCohort >> shellfishAge [

	^ shellfishAge
]

{ #category : 'accessing' }
PannCohort >> shellfishAge: anObject [

	shellfishAge := anObject
]

{ #category : 'accessing' }
PannCohort >> shellfishDensity [

	^ shellfishDensity
]

{ #category : 'accessing' }
PannCohort >> shellfishDensity: anObject [

	shellfishDensity := anObject
]

{ #category : 'accessing' }
PannCohort >> shellfishSize [

	^ shellfishSize
]

{ #category : 'accessing' }
PannCohort >> shellfishSize: anObject [

	shellfishSize := anObject
]
