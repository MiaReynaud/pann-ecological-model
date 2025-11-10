Class {
	#name : 'PannPopulation',
	#superclass : 'CMAgent',
	#instVars : [
		'cohorts',
		'cohortsCounter'
	],
	#category : 'PannEcol-Model',
	#package : 'PannEcol-Model'
}

{ #category : 'cohort counter ' }
PannPopulation >> actualizeCohortsCounter [
	
	| aliveCohorts |
	
	cohortsCounter := 0.
	aliveCohorts := (self cohorts) select: [ :c | c shellfishDensity > 2 ].
	aliveCohorts do: [ :c | cohortsCounter := cohortsCounter + 1	].
]

{ #category : 'ecological methods  ' }
PannPopulation >> cohortDeath [

	| sparseCohorts |
	sparseCohorts := (self cohorts) select: [ :c | c shellfishDensity < 2 ].
	sparseCohorts do: [ :c | c die	].
]

{ #category : 'accessing' }
PannPopulation >> cohorts [

	^ cohorts
]

{ #category : 'accessing' }
PannPopulation >> cohorts: anObject [

	cohorts := anObject
]

{ #category : 'accessing' }
PannPopulation >> cohortsCounter [

	^ cohortsCounter
]

{ #category : 'accessing' }
PannPopulation >> cohortsCounter: anObject [

	cohortsCounter := anObject
]

{ #category : 'initialization' }
PannPopulation >> initialize [ 

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
PannPopulation >> isRecruitDay [
"send true if its first of december"

	^ (self cormasModel currentDayOfMonth = 1)  and: (self cormasModel currentMonth = 12)
]

{ #category : 'ecological methods  ' }
PannPopulation >> recruit [ 

	self isRecruitDay ifTrue: [
		| newCohort |
		newCohort := ( self cormasModel newEntity: PannCohort )
			shellfishAge: 41; "according to the function a shellfish of 3mm is 41 days old"
			shellfishSize: 3; "in mm"
			shellfishDensity: 250 ; "in ind/m²"
			yourself.
	cohorts add: newCohort.
	].
]
