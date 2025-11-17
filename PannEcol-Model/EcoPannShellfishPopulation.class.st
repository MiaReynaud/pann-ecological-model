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

{ #category : 'ecological methods  ' }
EcoPannShellfishPopulation >> dailyFishableQuantity [ 

	 ^ 10000. "we estimate that each woman can only cover 400m² per day. She only collects 50% of available shellfish in this area. Since the total area of a mudflat cell is 5000m², the total number of available shellfish in the cell (or in the population, it's the same because a cell has only one population and a population is on only one cell) should be multiplied by (400/5000)*0.5 = 1/25  "
	
	"fishingHoursPerDay * fishedAreaPerHour (56m² that will evolve depending on the fisher eficiency) * self populationFishableDensity"
]

{ #category : 'ecological methods  ' }
EcoPannShellfishPopulation >> extractShellfish [

	| numberOfShellfishesToExtract exctractedFromCohort totalExtracted |
	
	totalExtracted := 0. 
	numberOfShellfishesToExtract := self dailyFishableQuantity.
	
	cohorts reversed do: [ :cohort | "we reverse it so that the fishers take the bigest ones in priority"
		exctractedFromCohort := cohort shellfishDensity min: numberOfShellfishesToExtract.
		cohort shellfishDensity: cohort shellfishDensity - exctractedFromCohort.
		numberOfShellfishesToExtract := numberOfShellfishesToExtract - exctractedFromCohort.
		totalExtracted := totalExtracted + exctractedFromCohort ].
	
	^ totalExtracted
	

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
	
"if broken, add this method to model : 

isRecruitDay

	^ (currentDayOfMonth = 1)  and: (currentMonth = 12)"
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
