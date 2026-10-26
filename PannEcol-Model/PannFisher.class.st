Class {
	#name : 'PannFisher',
	#superclass : 'CMAgent',
	#instVars : [
		'dailyEarnings',
		'fishedAreaPerHour',
		'numberOfExtractedShellfishToday',
		'freshBiomassOfExtractedShellfishToday',
		'driedFleshOfExtractedShellfishToday',
		'earningsHistory',
		'numberOfBasketsFishedPerHour'
	],
	#classInstVars : [
		'minShellfishSize',
		'maxShellfishSize',
		'numberOfFishingDayPerMbissa',
		'fishingHoursPerDay'
	],
	#category : 'PannEcol-Model',
	#package : 'PannEcol-Model'
}

{ #category : 'accessing' }
PannFisher class >> fishingHoursPerDay [
	<parameterIntegerDefault: 3>

	^ fishingHoursPerDay
]

{ #category : 'accessing' }
PannFisher class >> fishingHoursPerDay: anObject [

	fishingHoursPerDay := anObject
]

{ #category : 'accessing' }
PannFisher class >> maxShellfishSize [
	<parameterIntegerDefault: 1000>

	^ maxShellfishSize
]

{ #category : 'accessing' }
PannFisher class >> maxShellfishSize: anObject [

	maxShellfishSize := anObject
]

{ #category : 'accessing' }
PannFisher class >> minShellfishSize [
	<parameterIntegerDefault: 0>

	^ minShellfishSize
]

{ #category : 'accessing' }
PannFisher class >> minShellfishSize: anObject [

	minShellfishSize := anObject
]

{ #category : 'accessing' }
PannFisher class >> numberOfFishingDayPerMbissa [
	<parameterIntegerDefault: 6>

	^ numberOfFishingDayPerMbissa
]

{ #category : 'accessing' }
PannFisher class >> numberOfFishingDayPerMbissa: anObject [

	numberOfFishingDayPerMbissa := anObject
]

{ #category : 'charts' }
PannFisher >> buildChartBoxPlotX: xCollection y: yCollection [
	| x y chart plot |

	x := xCollection ifEmpty: [ #(0) ].
	y := yCollection ifEmpty: [ #(0) ].

	chart := RSCompositeChart new.
	plot := RSLinePlot new x: x y: y.
	plot color: CMColor azure.
	plot width: 1.5.
	chart add: plot.

	chart title: 'Évolution des revenus'.
	chart xlabel: 'Temps de simulation'.
	chart ylabel: 'Revenu (FCFA)'.

	^ chart
]

{ #category : 'decisions' }
PannFisher >> chooseSareToFishOn [
    <playableAction>
    | openSares |

    openSares := cormasModel sares
        select: [ :sare |
            (sare isClosed not)
                and: [ sare plots notEmpty ]
        ].

    openSares ifEmpty: [ ^ nil ].

    ^ self selectRandomlyFrom: openSares
]

{ #category : 'accessing' }
PannFisher >> dailyEarnings [

	^ dailyEarnings
]

{ #category : 'fishing activity' }
PannFisher >> earnMoneyOutOfFishing [

	| weightOfAShellfish weightOfShellfishForOneDriedKilogramOfFlesh priceOfAKgOfDriedShellfishFlesh earnings |
	
	weightOfAShellfish := 10. "g"
	weightOfShellfishForOneDriedKilogramOfFlesh := 40000. "g"
	priceOfAKgOfDriedShellfishFlesh := 3000. "FCFA"
	
	earnings := ((numberOfExtractedShellfishToday * weightOfAShellfish) / weightOfShellfishForOneDriedKilogramOfFlesh) * priceOfAKgOfDriedShellfishFlesh. "FCFA"
	
	dailyEarnings := earnings rounded.
	
	^ dailyEarnings
]

{ #category : 'fishing activity' }
PannFisher >> earningsHistory [

	^ earningsHistory
]

{ #category : 'fishing activity' }
PannFisher >> earningsHistory: anObject [

	earningsHistory := anObject
]

{ #category : 'fishing activity' }
PannFisher >> extractShellfish [ 

    | cohorts selectedCohorts numberOfSquareMetersToFish numberOfShellfishToExtractFromThatCohort |

	cohorts := self cell shellfishPopulation cohorts.     

	numberOfSquareMetersToFish := self class fishingHoursPerDay * fishedAreaPerHour.
	
	freshBiomassOfExtractedShellfishToday := 0.
	numberOfExtractedShellfishToday := 0.
	numberOfBasketsFishedPerHour := 0.
	
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
		].

    numberOfExtractedShellfishToday := numberOfExtractedShellfishToday rounded.

	self updateNumberOfBasketsFishedPerHour.
]

{ #category : 'fishing activity' }
PannFisher >> fish [
	self goToFishingSpot.
	self extractShellfish.
	self earnMoneyOutOfFishing.

]

{ #category : 'accessing' }
PannFisher >> freshBiomassOfExtractedShellfishToday [

	^ freshBiomassOfExtractedShellfishToday
]

{ #category : 'fishing activity' }
PannFisher >> goToFishingSpot [
	"The fisher goes to an available fishing spot"
	"Need to code : The fisher go to the fishing spot where she think she will earn the most"

	<action>
	
	| openSare fishingSpot |
	
	"self cormasModel seedingActive
        ifTrue: [
            openSare := self cormasModel
                seedingSareForId:
                    self cormasModel seedingSourceSareId.

            openSare ifNil: [
                self workInVillage.
                ^ self
            ].

            openSare isClosed ifTrue: [
                self workInVillage.
                ^ self
            ].

            openSare plots isEmpty ifTrue: [
                self workInVillage.
                ^ self
            ].

            fishingSpot := self
                selectRandomlyFrom: openSare plots.

            self moveTo: fishingSpot.
            ^ self
        ]."
	
	openSare := self chooseSareToFishOn.
	
	openSare ifNil: [
        self workInVillage.
        ^ self
    ].
	
	fishingSpot := self 
			selectRandomlyFrom: openSare plots.

	self moveTo: fishingSpot
]

{ #category : 'initialization' }
PannFisher >> initialize [ 

	super initialize.
	fishedAreaPerHour := 56. "m²/h"
	numberOfExtractedShellfishToday := 0.
	earningsHistory := OrderedCollection new.
]

{ #category : 'time    ' }
PannFisher >> isFishingPeriod [

    ^ self cormasModel isFishingPeriod
]

{ #category : 'time    ' }
PannFisher >> isMbissa [
    "Return true if the current day is within a mbissa"
 
	| cycleLength mbissaLength cycleDay |
	mbissaLength := self class numberOfFishingDayPerMbissa.
	cycleLength := 15.
	cycleDay := (self cormasModel dayCounter - 1 \\ cycleLength) + 1.
	^ cycleDay <= mbissaLength
]

{ #category : 'time    ' }
PannFisher >> isNotFishingPeriod [
    "Return true if the current month is within the no-fishing period (Jul–Oct)"
    ^ (self cormasModel currentMonth between: 7 and: 10)
]

{ #category : 'accessing' }
PannFisher >> numberOfBasketsFishedPerHour [

    self class fishingHoursPerDay = 0
        ifTrue: [ ^ 0 ].

    ^ freshBiomassOfExtractedShellfishToday
        / (40000 * self class fishingHoursPerDay)     "1 basket = 40 kg"
]

{ #category : 'accessing' }
PannFisher >> numberOfExtractedShellfishToday [

	^ numberOfExtractedShellfishToday
]

{ #category : 'initialization' }
PannFisher >> pov [ 
	<pov>
	^ CMPointOfView 
		color: 'FF9D00'
		shape: #triangle 
		size: 0.5
]

{ #category : 'fishing activity' }
PannFisher >> recordEarnings [

    earningsHistory add:
        (self cormasModel dayCounter -> dailyEarnings).
]

{ #category : 'decisions' }
PannFisher >> shouldFish [
	<playableAction>
	^ self isFishingPeriod and: [ self isMbissa ]
]

{ #category : 'charts' }
PannFisher >> showCharts [
	<action>
	
	| chart |
	
	chart := self
		buildChartBoxPlotX: (earningsHistory collect: [ :point | point key ] )
		y: (earningsHistory collect: [ :point | point value ] ).
	
	chart build.
	chart canvas openWithTitle: self asString
]

{ #category : 'step      ' }
PannFisher >> step [
	
	freshBiomassOfExtractedShellfishToday := 0.
   numberOfExtractedShellfishToday := 0.
	numberOfBasketsFishedPerHour := 0.
	dailyEarnings := 0.
	
	self shouldFish
			ifTrue: [ self fish ]
			ifFalse: [ self workInVillage]. 
			
	self recordEarnings.
]

{ #category : 'fishing activity' }
PannFisher >> updateNumberOfBasketsFishedPerHour [

    self class fishingHoursPerDay = 0
        ifTrue: [
            numberOfBasketsFishedPerHour := 0.
            ^ self
        ].

    numberOfBasketsFishedPerHour :=
        freshBiomassOfExtractedShellfishToday
            / (40000 * self class fishingHoursPerDay).

	freshBiomassOfExtractedShellfishToday := freshBiomassOfExtractedShellfishToday rounded.
]

{ #category : 'village activity' }
PannFisher >> workInVillage [
	"The fisher go to the fishing spot where she think she will earn the most"
	
	<action>
	| village earningFromAWorkingDayInVillage |
	
	earningFromAWorkingDayInVillage := 500.
	
	village := self selectRandomlyFrom: 
		(cormasModel cells select: [ :c | c state = #village ]).
	
	self moveTo: village.
	
	dailyEarnings := earningFromAWorkingDayInVillage.
	

]
