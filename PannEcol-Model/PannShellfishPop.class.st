Class {
	#name : 'PannShellfishPop',
	#superclass : 'CMAgent',
	#instVars : [
		'cohorts',
		'cohortsCounter'
	],
	#category : 'PannEcol-Model',
	#package : 'PannEcol-Model'
}

{ #category : 'initialization' }
PannShellfishPop >> actualizeCohortsCounter [
	
	| aliveCohorts |
	
	cohortsCounter := 0.
	aliveCohorts := (self cohorts) select: [ :c | c shellfishDensity > 2 ].
	aliveCohorts do: [ :c | cohortsCounter := cohortsCounter + 1	].
]

{ #category : 'initialization' }
PannShellfishPop >> cohortDeath [

	| sparseCohorts |
	sparseCohorts := (self cohorts) select: [ :c | c shellfishDensity < 2 ].
	sparseCohorts do: [ :c | c die	].
]

{ #category : 'accessing' }
PannShellfishPop >> cohorts [

	^ cohorts
]

{ #category : 'accessing' }
PannShellfishPop >> cohorts: anObject [

	cohorts := anObject
]

{ #category : 'accessing' }
PannShellfishPop >> cohortsCounter [

	^ cohortsCounter
]

{ #category : 'accessing' }
PannShellfishPop >> cohortsCounter: anObject [

	cohortsCounter := anObject
]

{ #category : 'initialization' }
PannShellfishPop >> initialize [ 

	super initialize .

	cohorts := OrderedCollection new.
	
	cohortsCounter := 0 .



"	cohorts := (1 to: 7 by: 1) asOrderedCollection collect: [ :size |
  		( self cormasModel newEntity: PannShellfishCohort )
    		shellfishSize: size;
    		shellfishDensity: 2500000; ""we estimate that there is one shellfish of each cohort in 20cm², so it's 2 500 000 shellfish of each cohort in 0,5 ha""
    		yourself ]."
]

{ #category : 'initialization' }
PannShellfishPop >> isRecruitDay [
"send true if its first of december"

	^ (self cormasModel currentDayOfMonth = 1)  and: (self cormasModel currentMonth = 12)
]

{ #category : 'initialization' }
PannShellfishPop >> recruit [ 

	self isRecruitDay ifTrue: [
		| newCohort |
		newCohort := ( self cormasModel newEntity: PannCohort )
			shellfishAge: 0;
			shellfishSize: 3; "in mm"
			shellfishDensity: 250 ; "in ind/m²"
			yourself.
	cohorts add: newCohort.
	].
	
	
"The code bellow was the recruit method when there where classes of cohorts"	
"	| numberOfNewborns |
	
	numberOfNewborns := self cell sare recruitCapacity.
	
	cohorts first densityOfShellfish: cohorts first densityOfShellfish + numberOfNewborns."
]
