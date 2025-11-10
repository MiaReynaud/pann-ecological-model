Class {
	#name : 'EcoPannShellfishPopulation',
	#superclass : 'CMAgent',
	#instVars : [
		'cohorts',
		'cohortsCounter'
	],
	#category : 'PannEcol-Model',
	#package : 'PannEcol-Model'
}

{ #category : 'cohort counter ' }
EcoPannShellfishPopulation >> actualizeCohortsCounter [
	
	| aliveCohorts |
	
	cohortsCounter := 0.
	aliveCohorts := (self cohorts) select: [ :c | c shellfishDensity > 2 ].
	aliveCohorts do: [ :c | cohortsCounter := cohortsCounter + 1	].
]

{ #category : 'ecological methods  ' }
EcoPannShellfishPopulation >> cohortDeath [

	| sparseCohorts |
	sparseCohorts := (self cohorts) select: [ :c | c shellfishDensity < 2 ].
	sparseCohorts do: [ :c | c die	].
]

{ #category : 'accessing' }
EcoPannShellfishPopulation >> cohorts [

	^ cohorts
]

{ #category : 'accessing' }
EcoPannShellfishPopulation >> cohorts: anObject [

	cohorts := anObject
]

{ #category : 'accessing' }
EcoPannShellfishPopulation >> cohortsCounter [

	^ cohortsCounter
]

{ #category : 'accessing' }
EcoPannShellfishPopulation >> cohortsCounter: anObject [

	cohortsCounter := anObject
]

{ #category : 'initialization' }
EcoPannShellfishPopulation >> initialize [ 

	super initialize .

	cohorts := OrderedCollection new.
	
	cohortsCounter := 0 .



"	cohorts := (1 to: 7 by: 1) asOrderedCollection collect: [ :size |
  		( self cormasModel newEntity: PannShellfishCohort )
    		shellfishSize: size;
    		shellfishDensity: 2500000; ""we estimate that there is one shellfish of each cohort in 20cm², so it's 2 500 000 shellfish of each cohort in 0,5 ha""
    		yourself ]."
]

{ #category : 'cohort counter ' }
EcoPannShellfishPopulation >> isRecruitDay [
"send true if its first of december"

	^ (self cormasModel currentDayOfMonth = 1)  and: (self cormasModel currentMonth = 12)
]

{ #category : 'accessing' }
EcoPannShellfishPopulation >> numberOfShellfishes [ 

	^ cohorts sum: [ : each | each numberOfShellfishes ].
]

{ #category : 'ecological methods  ' }
EcoPannShellfishPopulation >> recruit [ 

	self isRecruitDay ifTrue: [
		| newCohort |
		newCohort := ( self cormasModel newEntity: EcoPannShellfishCohort )
			population: self;
			yourself.
	cohorts add: newCohort.
	].
]
