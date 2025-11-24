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
		'driedFleshOfExtractedShellfishToday'
	],
	#category : 'PannEcol-Model',
	#package : 'PannEcol-Model'
}

{ #category : 'as yet unclassified' }
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
EcoPannFisher >> extractShellfish [ 

    | cohorts fishingRate numberOfShellfishToExtractFromThatCohort freshBiomassOfExtractedShellfishTodayFromThatCohort |

	cohorts := self cell shellfishPopulation cohorts.     

	fishingRate := fishingHoursPerDay * fishedAreaPerHour.

	freshBiomassOfExtractedShellfishToday := cohorts sum: [:cohort |
      numberOfShellfishToExtractFromThatCohort := fishingRate * cohort shellfishDensity.
		freshBiomassOfExtractedShellfishTodayFromThatCohort := numberOfShellfishToExtractFromThatCohort * cohort shellfishTotalBiomass. "g"
		freshBiomassOfExtractedShellfishTodayFromThatCohort 
		].

	"driedFleshOfExtractedShellfishToday := (0.02 * (cohort shellfishSize raisedTo: 2.42)) * shellfishToExtractFromCohort." "g"

	numberOfExtractedShellfishToday := cohorts sum: [:cohort |
      numberOfShellfishToExtractFromThatCohort := fishingRate * cohort shellfishDensity.
		cohort removeShellfish: numberOfShellfishToExtractFromThatCohort.
		numberOfShellfishToExtractFromThatCohort
		].
	


]

{ #category : 'fishing activity' }
EcoPannFisher >> fish [
	self goToFishingSpot.
	self extractShellfish.
	self earnMoneyOutOfFishing
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
	

]

{ #category : 'initialization' }
EcoPannFisher >> initialize [ 

	super initialize.
	fishedAreaPerHour := 56. "m²/h"
	numberOfFishingDayPerMbissa := 6.
	fishingHoursPerDay := 4. "h"
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

{ #category : 'initialization' }
EcoPannFisher >> pov [ 
	<pov>
	^ CMPointOfView 
		color: 'FF9D00'
		shape: #triangle 
		size: 0.5
]

{ #category : 'as yet unclassified' }
EcoPannFisher >> shouldFish [
	<playableAction>
	^ self isFishingPeriod and: [ self isMbissa ]
]
