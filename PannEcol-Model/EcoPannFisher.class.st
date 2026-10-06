Class {
	#name : 'EcoPannFisher',
	#superclass : 'CMAgent',
	#instVars : [
		'dailyEarnings',
		'fishedAreaPerHour',
		'numberOfFishingDayPerMbissa',
		'fishingHoursPerDay',
		'numberOfExtractedShellfishToday',
		'freshBiomassOfExtractedShellfishToday',
		'driedFleshOfExtractedShellfishToday',
		'earningsHistory'
	],
	#classInstVars : [
		'minShellfishSize',
		'maxShellfishSize'
	],
	#category : 'PannEcol-Model',
	#package : 'PannEcol-Model'
}

{ #category : 'accessing' }
EcoPannFisher class >> maxShellfishSize [
	<parameterIntegerDefault: 1000>

	^ maxShellfishSize
]

{ #category : 'accessing' }
EcoPannFisher class >> maxShellfishSize: anObject [

	maxShellfishSize := anObject
]

{ #category : 'accessing' }
EcoPannFisher class >> minShellfishSize [
	<parameterIntegerDefault: 0>

	^ minShellfishSize
]

{ #category : 'accessing' }
EcoPannFisher class >> minShellfishSize: anObject [

	minShellfishSize := anObject
]

{ #category : 'charts' }
EcoPannFisher >> buildChartBoxPlotX: xCollection y: yCollection [

    | chart plot |

    xCollection ifEmpty: [ ^ RSCompositeChart new ].

    chart := RSCompositeChart new.

    plot := RSLinePlot new
        x: xCollection
        y: yCollection.

    plot color: CMColor black.

    chart add: plot.

    chart title: 'Évolution des revenus'.
    chart xlabel: 'Temps de simulation'.
    chart ylabel: 'Revenu (FCFA)'.

    chart build.

    ^ chart
]

{ #category : 'charts' }
EcoPannFisher >> buildEarningsChart [

	^ self
        buildChartBoxPlotX:
            (earningsHistory collect: [:point | point key])
        y:
            (earningsHistory collect: [:point | point value]).
]

{ #category : 'decisions' }
EcoPannFisher >> chooseSareToFishOn [
	<playableAction>
	^ self selectRandomlyFrom: cormasModel sares
]

{ #category : 'accessing' }
EcoPannFisher >> dailyEarnings [

	^ dailyEarnings
]

{ #category : 'fishing activity' }
EcoPannFisher >> earnMoneyOutOfFishing [

	| weightOfAShellfish weightOfShellfishForOneDriedKilogramOfFlesh priceOfAKgOfDriedShellfishFlesh |
	
	weightOfAShellfish := 10. "g"
	weightOfShellfishForOneDriedKilogramOfFlesh := 40000. "g"
	priceOfAKgOfDriedShellfishFlesh := 3000. "FCFA"
	
	dailyEarnings := ((numberOfExtractedShellfishToday * weightOfAShellfish) / weightOfShellfishForOneDriedKilogramOfFlesh) * priceOfAKgOfDriedShellfishFlesh. "FCFA"
]

{ #category : 'fishing activity' }
EcoPannFisher >> earningsHistory [

	^ earningsHistory
]

{ #category : 'fishing activity' }
EcoPannFisher >> earningsHistory: anObject [

	earningsHistory := anObject
]

{ #category : 'fishing activity' }
EcoPannFisher >> extractShellfish [ 

    | cohorts selectedCohorts numberOfSquareMetersToFish numberOfShellfishToExtractFromThatCohort |

	cohorts := self cell shellfishPopulation cohorts.     

	numberOfSquareMetersToFish := fishingHoursPerDay * fishedAreaPerHour.
	
	freshBiomassOfExtractedShellfishToday := 0.
	numberOfExtractedShellfishToday := 0.
	
	selectedCohorts := cohorts select: [ :cohort |
		cohort shellfishSize 
			between: self class minShellfishSize
			and: self class maxShellfishSize
	].
	
	selectedCohorts do: [ :cohort | 
		numberOfShellfishToExtractFromThatCohort :=
			(numberOfSquareMetersToFish * cohort shellfishDensity)
           min: cohort numberOfShellfishes.

		freshBiomassOfExtractedShellfishToday := freshBiomassOfExtractedShellfishToday +
			(numberOfShellfishToExtractFromThatCohort * cohort oneIndividualTotalBiomass). "g"
			
		numberOfExtractedShellfishToday := numberOfExtractedShellfishToday +
			numberOfShellfishToExtractFromThatCohort.
			
		cohort removeShellfish: numberOfShellfishToExtractFromThatCohort.
		]
]

{ #category : 'fishing activity' }
EcoPannFisher >> fish [
	self goToFishingSpot.
	self extractShellfish.
	self earnMoneyOutOfFishing.

]

{ #category : 'accessing' }
EcoPannFisher >> freshBiomassOfExtractedShellfishToday [

	^ freshBiomassOfExtractedShellfishToday
]

{ #category : 'fishing activity' }
EcoPannFisher >> goToFishingSpot [
	"The fisher go to the fishing spot where she think she will earn the most"

	<action>
	| sare fishingSpot |
	sare := self chooseSareToFishOn.
	fishingSpot := self selectRandomlyFrom: sare plots.

	self moveTo: fishingSpot
]

{ #category : 'initialization' }
EcoPannFisher >> goToVillage [
	"The fisher go to the fishing spot where she think she will earn the most"
	
	<action>
	| village |
	
	village := self selectRandomlyFrom: 
		(cormasModel cells select: [ :c | c state = #village ]).
	
	self moveTo: village.
	
	dailyEarnings := 1000.
	

]

{ #category : 'initialization' }
EcoPannFisher >> initialize [ 

	super initialize.
	fishedAreaPerHour := 56. "m²/h"
	numberOfFishingDayPerMbissa := 6.
	fishingHoursPerDay := 3. "h"
	numberOfExtractedShellfishToday := 0.
	earningsHistory := OrderedCollection new.
]

{ #category : 'charts' }
EcoPannFisher >> inspectorCharts: aBuilder [

    <inspectorPresentationOrder: 10 title: 'Charts'>

	^ (aBuilder instantiate: SpRoassalInspectorPresenter)
		canvas: self buildEarningsChart canvas;
		yourself
]

{ #category : 'time    ' }
EcoPannFisher >> isFishingPeriod [
    "Return true if the current month is within the fishing period (Nov–Jun)"
    ^ (self cormasModel currentMonth >= 11) or: [self cormasModel currentMonth <= 6]
]

{ #category : 'time    ' }
EcoPannFisher >> isMbissa [
    "Return true if the current day is within a mbissa"
 
	| cycleLength mbissaLength cycleDay |
	mbissaLength := numberOfFishingDayPerMbissa.
	cycleLength := 15.
	cycleDay := (self cormasModel dayCounter - 1 \\ cycleLength) + 1.
	^ cycleDay <= mbissaLength
]

{ #category : 'time    ' }
EcoPannFisher >> isNotFishingPeriod [
    "Return true if the current month is within the no-fishing period (Jul–Oct)"
    ^ (self cormasModel currentMonth between: 7 and: 10)
]

{ #category : 'accessing' }
EcoPannFisher >> numberOfExtractedShellfishToday [

	^ numberOfExtractedShellfishToday
]

{ #category : 'initialization' }
EcoPannFisher >> pov [ 
	<pov>
	^ CMPointOfView 
		color: 'FF9D00'
		shape: #triangle 
		size: 0.5
]

{ #category : 'fishing activity' }
EcoPannFisher >> recordEarnings [

    earningsHistory add:
        (self cormasModel dayCounter -> dailyEarnings).
]

{ #category : 'decisions' }
EcoPannFisher >> shouldFish [
	<playableAction>
	^ self isFishingPeriod and: [ self isMbissa ]
]

{ #category : 'step      ' }
EcoPannFisher >> step [
	
	freshBiomassOfExtractedShellfishToday := 0.
   numberOfExtractedShellfishToday := 0.
	dailyEarnings := 0.
	
	self shouldFish
			ifTrue: [ self fish ]
			ifFalse: [ self goToVillage].
			
	self recordEarnings.
]
