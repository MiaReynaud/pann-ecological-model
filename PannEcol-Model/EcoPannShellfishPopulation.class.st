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

{ #category : 'charts' }
EcoPannShellfishPopulation >> buildChartBoxPlotX: xCollection y: yCollection [
	
	| chart plot |
	
	xCollection ifEmpty: [ ^ RSCompositeChart new ].
	
	chart := RSCompositeChart new.
			
	plot := RSBarPlot new x: xCollection y: yCollection.
	plot color: CMColor black.
	plot barSize: 10.
	chart add: plot.
	
	chart title: 'Distribution des tailles'.
	chart xlabel: 'Taille (mm)'.
	chart ylabel: 'Densité (individus/m²)'.

	chart build.
	plot bars @ RSPopup.
	
	^ chart
]

{ #category : 'charts' }
EcoPannShellfishPopulation >> buildSizeDistributionChart [

	| sortedCohorts |

	sortedCohorts := cohorts asSortedCollection:
		[:a :b | a shellfishSize < b shellfishSize ].

	^ self
		buildChartBoxPlotX: (sortedCohorts collect: [:c | c shellfishSize])
		y: (sortedCohorts collect: [:c | c shellfishDensity]).
]

{ #category : 'ecological methods  ' }
EcoPannShellfishPopulation >> cohortDeath [

	| cohortsToBeKilled |
	
	cohortsToBeKilled :=	cohorts select: [ :c | c shellfishDensity < 2 ].
	cohortsToBeKilled do: [ :c |
			c die.
			cohorts remove: c ]
]

{ #category : 'accessing' }
EcoPannShellfishPopulation >> cohorts [

	^ cohorts
]

{ #category : 'accessing' }
EcoPannShellfishPopulation >> cohortsCounter [

	^ cohortsCounter
]

{ #category : 'ecological methods  ' }
EcoPannShellfishPopulation >> dailyFishableQuantity [ 

	 ^ 10000. "we estimate that each woman can only cover 400m² per day. She only collects 50% of available shellfish in this area. Since the total area of a mudflat cell is 5000m², the total number of available shellfish in the cell (or in the population, it's the same because a cell has only one population and a population is on only one cell) should be multiplied by (400/5000)*0.5 = 1/25  "
	
	"In the end, will have to replace with : ^ fishingHoursPerDay * fishedAreaPerHour (56m² that will evolve depending on the fisher eficiency) * self populationFishableDensity"
]

{ #category : 'accessing' }
EcoPannShellfishPopulation >> densityOfShellfishes [ 

	^ self numberOfShellfishes / self cell area .
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

{ #category : 'charts' }
EcoPannShellfishPopulation >> inspectorCharts: aBuilder [

	<inspectorPresentationOrder: 10 title: 'Charts'>
	
	^ (aBuilder instantiate: SpRoassalInspectorPresenter)
		canvas: self buildSizeDistributionChart canvas;
		yourself
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
		| newCohort recruitDensity |
		recruitDensity := self sare recruitCapacity.
		newCohort := ( self cormasModel newEntity: EcoPannShellfishCohort )
			population: self;
			shellfishDensity: recruitDensity; "in ind/m²"
			yourself.
	cohorts add: newCohort.
	].
]

{ #category : 'ecological methods  ' }
EcoPannShellfishPopulation >> sare [ 

	^ self cell sare.
]

{ #category : 'step    ' }
EcoPannShellfishPopulation >> step [ 

	self recruit.
	self cohortDeath.
	self actualizeCohortsCounter.
]
