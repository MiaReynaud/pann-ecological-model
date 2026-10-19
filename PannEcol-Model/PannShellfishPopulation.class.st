Class {
	#name : 'PannShellfishPopulation',
	#superclass : 'CMAgent',
	#instVars : [
		'cohorts'
	],
	#category : 'PannEcol-Model',
	#package : 'PannEcol-Model'
}

{ #category : 'cohort counter ' }
PannShellfishPopulation >> averageNumberOfCohorts [

	^ self cohorts size.
]

{ #category : 'charts' }
PannShellfishPopulation >> buildChartBoxPlotX: xCollection y: yCollection [
	
	| x y chart plot |
	
	x := xCollection ifEmpty: [ #(0) ].
	y := yCollection ifEmpty: [ #(0) ].
	
	chart := RSCompositeChart new.
			
	plot := RSBarPlot new x: x y: y.
	plot color: CMColor azure.
	plot barSize: 10.
	chart add: plot.
	
	chart title: 'Distribution des tailles'.
	chart xlabel: 'Taille (mm)'.
	chart ylabel: 'Densité (individus/m²)'.
	
	^ chart
]

{ #category : 'ecological methods  ' }
PannShellfishPopulation >> cohortDeath [

	| cohortsToBeKilled densityLimitToKillCohort |
	
	densityLimitToKillCohort := 0.01.
	
	cohortsToBeKilled :=	cohorts select: [ :c | c shellfishDensity < densityLimitToKillCohort ].
	cohortsToBeKilled do: [ :c |
			c die.
			cohorts remove: c ]
]

{ #category : 'accessing' }
PannShellfishPopulation >> cohorts [

	^ cohorts
]

{ #category : 'initial cohorts' }
PannShellfishPopulation >> createInitialCohorts [

    | cohortSizes cohortAges cohortDensities |

    cohortSizes := #(36.20 34.21 30.06 21.33).
    cohortAges := #(1501 1136 771 406).

    cohortDensities := self initialCohortDensitiesForSare.

    cohorts := OrderedCollection new.

    1 to: cohortSizes size do: [ :i |

        | density newCohort |

        density := cohortDensities at: i.

        "A density of 0 means that this cohort is not present
        in the initial population."

        density > 0 ifTrue: [

            newCohort :=
                self cormasModel newEntity: PannShellfishCohort.

            newCohort
                population: self;
                shellfishSize: (cohortSizes at: i);
                shellfishAge: (cohortAges at: i);
                shellfishDensity: density.

            cohorts add: newCohort
        ]
    ].
]

{ #category : 'ecological methods  ' }
PannShellfishPopulation >> dailyFishableQuantity [ 

	 "^ 10000." 
	"we estimate that each woman can only cover 400m² per day. She only collects 50% of available shellfish in this area. Since the total area of a mudflat cell is 5000m², the total number of available shellfish in the cell (or in the population, it's the same because a cell has only one population and a population is on only one cell) should be multiplied by (400/5000)*0.5 = 1/25  "
	
	"In the end, will have to replace with : ^ fishingHoursPerDay * fishedAreaPerHour (56m² that will evolve depending on the fisher eficiency) * self populationFishableDensity"
]

{ #category : 'accessing' }
PannShellfishPopulation >> densityOfShellfishes [ 

	^ self numberOfShellfishes / self cell area .
]

{ #category : 'initial cohorts' }
PannShellfishPopulation >> initialCohortDensitiesForSare [

    self sare id = 1 ifTrue: [
        ^ #(0.06 0.53 4.47 38.42)
    ].

    self sare id = 2 ifTrue: [
        ^ #(0.02 0.20 1.68 14.84)
    ].

    self sare id = 3 ifTrue: [
        ^ #(0 0.05 0.42 3.84)
    ].

    ^ #(0 0 0 0)
]

{ #category : 'cohort counter ' }
PannShellfishPopulation >> isRecruitDay [
"send true if its first of december"

	^ (self cormasModel currentDayOfMonth = 1)  
			and: (self cormasModel currentMonth = 12)
	
"if broken, add this method to model : 

isRecruitDay

	^ (currentDayOfMonth = 1)  and: (currentMonth = 12)"
]

{ #category : 'moving' }
PannShellfishPopulation >> moveTo: aCell [

	super moveTo: aCell.
	
	self createInitialCohorts.
]

{ #category : 'accessing' }
PannShellfishPopulation >> numberOfShellfishes [ 

	^ cohorts sum: [ : each | each numberOfShellfishes ].
]

{ #category : 'ecological methods  ' }
PannShellfishPopulation >> recruit [ 

	self isRecruitDay ifTrue: [
		| newCohort recruitDensity |
		recruitDensity := self sare recruitCapacity.
		newCohort := ( self cormasModel newEntity: PannShellfishCohort )
			population: self;
			shellfishDensity: recruitDensity; "in ind/m²"
			yourself.
	cohorts add: newCohort.
	].
]

{ #category : 'ecological methods  ' }
PannShellfishPopulation >> sare [ 

	^ self cell sare.
]

{ #category : 'charts' }
PannShellfishPopulation >> showCharts [
	<action> 
	
	| sortedCohorts chart |

	sortedCohorts := cohorts asSortedCollection:
		[ :a :b | a shellfishSize < b shellfishSize ].

	chart := self
		buildChartBoxPlotX: (sortedCohorts collect: [ :c | c shellfishSize ] )
		y: (sortedCohorts collect: [ :c | c shellfishDensity ] ).
		
	chart build.
	chart canvas openWithTitle: self asString
]

{ #category : 'step    ' }
PannShellfishPopulation >> step [ 

	self recruit.
	self cohortDeath.
]
