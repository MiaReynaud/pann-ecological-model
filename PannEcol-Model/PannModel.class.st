Class {
	#name : 'PannModel',
	#superclass : 'CMAbstractModel',
	#instVars : [
		'currentDayOfMonth',
		'currentMonth',
		'dayCounter',
		'annualPopulationGrowthRate',
		'initialNumberOfFishers',
		'closeSare1',
		'closeSare2',
		'closeSare3',
		'closureDurationSare1',
		'closureDurationSare2',
		'closureDurationSare3',
		'biologicalRestEnabled',
		'biologicalRestStartMonth',
		'biologicalRestDuration',
		'seedingEnabled',
		'seedingSourceSareId',
		'seedingDestinationSareId',
		'seedingPending',
		'seedingActive',
		'seedingExecutionDay',
		'totalEarnings',
		'shellfishGrowthRate',
		'recruitmentRateMultiplier',
		'naturalDeathRate',
		'totalFisheableArea'
	],
	#category : 'PannEcol-Model',
	#package : 'PannEcol-Model'
}

{ #category : 'as yet unclassified' }
PannModel class >> modelName [

	^ 'Pann'
]

{ #category : 'accessing' }
PannModel class >> prefix [

	^ 'PE'
]

{ #category : 'init  ' }
PannModel >> addFishers [

	self
		create: initialNumberOfFishers 
		randomlyLocatedEntitiesOfClass: PannFisher
		constrainedBy: [ :aCell | aCell state = #village ]
]

{ #category : 'init  ' }
PannModel >> addShellfishes [


	(self cells select: [ :c | c state = #mudflat ]) do: [ :cell |
		 self newEntity: PannShellfishPopulation locatedAt: cell].
	

]

{ #category : 'social - population growth' }
PannModel >> annualPopulationGrowthRate [
    <parameterFloatDefault: 0.00> "for instance 0.02 = +2 % per year"

    ^ annualPopulationGrowthRate
]

{ #category : 'social - population growth' }
PannModel >> annualPopulationGrowthRate: aValue [

	annualPopulationGrowthRate := aValue
]

{ #category : 'social - population growth' }
PannModel >> applyAnnualPopulationGrowth [
    | currentPopulation newPopulation numberOfNewFishersToCreate |

    currentPopulation := self numberOfFishers.

    newPopulation :=
        (currentPopulation
            * (1 + self annualPopulationGrowthRate))
            rounded.

    numberOfNewFishersToCreate := newPopulation - currentPopulation.

    numberOfNewFishersToCreate > 0
        ifTrue: [
            self createNewFishers: numberOfNewFishersToCreate
        ].
]

{ #category : 'social - population growth' }
PannModel >> applyAnnualPopulationGrowthIfNeeded [
    currentMonth = 1
        ifTrue: [
            currentDayOfMonth = 1
                ifTrue: [
                    self applyAnnualPopulationGrowth
                ]
        ].
]

{ #category : 'management - closure' }
PannModel >> applyClosureForSareId: anId [

    | sare |

    sare := (self @@ PannSare)
        detect: [ :each | each id = anId ]
        ifNone: [ ^ self ].

    sare isClosed ifTrue: [ ^ self ].

    sare closeAtDay: dayCounter.
]

{ #category : 'management - closure' }
PannModel >> applyRequestedClosures [

    1 to: 3 do: [ :id |
        (self shouldCloseSareId: id)
            ifTrue: [
                self applyClosureForSareId: id.
                self setCloseSareId: id to: false
            ]
    ]
]

{ #category : 'init  ' }
PannModel >> applyStatesFromMatrix: aMatrix [

	| rows cols value cell |
    rows := aMatrix size.
    cols := (aMatrix first) size.

    1 to: rows do: [ :i |
        1 to: cols do: [ :j |
            cell := self cellAt: i at: j.
            value := (aMatrix at: i) at: j.

            value = 0 ifTrue: [ cell beSea ].
            value = 1 ifTrue: [ cell beVillage ].
				value = 2 ifTrue: [ cell beMudflat ].
				value = 3 ifTrue: [ cell beMangrove ] ] ].
]

{ #category : 'probes ' }
PannModel >> averageDailyEarningsProbe [

<probeNamed: 'Average daily earnings' color: '0000FF'>

	| result |

	(self currentTimeStep = 0) ifTrue: [ ^ 0 ].
	(self numberOfFishers = 0) ifTrue: [ ^ 0 ].
    
   result := (totalEarnings / self numberOfFishers / self currentTimeStep) asFloat.

	^ result rounded
]

{ #category : 'probes ' }
PannModel >> averageNumberOfCohortsProbe [ 

	<probeNamed: 'Average number of cohorts' color: '00B44C'>
	
    | pops result |

    pops := self @@ PannShellfishPopulation.
    result := (pops collect: [:pop | pop averageNumberOfCohortsProbe]) average.

	^ result roundTo: 0.1
]

{ #category : 'management - biological resting period' }
PannModel >> biologicalRestDuration [
    <parameterIntegerDefault: 4>
    ^ biologicalRestDuration
]

{ #category : 'management - biological resting period' }
PannModel >> biologicalRestDuration: anObject [

	biologicalRestDuration := anObject
]

{ #category : 'management - biological resting period' }
PannModel >> biologicalRestEnabled [
    <parameterBooleanDefault: true>

    ^ biologicalRestEnabled
]

{ #category : 'management - biological resting period' }
PannModel >> biologicalRestEnabled: anObject [

	biologicalRestEnabled := anObject
]

{ #category : 'management - biological resting period' }
PannModel >> biologicalRestEndMonth [
    | endMonth |

    endMonth :=
        self biologicalRestStartMonth
            + self biologicalRestDuration
            - 1.

    ^ endMonth > 12
        ifTrue: [ endMonth - 12 ]
        ifFalse: [ endMonth ]
]

{ #category : 'management - biological resting period' }
PannModel >> biologicalRestStartMonth [
    <parameterIntegerDefault: 7>

    ^ biologicalRestStartMonth
]

{ #category : 'management - biological resting period' }
PannModel >> biologicalRestStartMonth: anObject [

	biologicalRestStartMonth := anObject
]

{ #category : 'init 30x30 cells grid' }
PannModel >> buildSareOf30x30CellsGrid [
	
	self releaseAggregateType: PannSare .
	self
		createAggregates: PannSare 
		from: PannPlot
		verifying: [ :aCell | aCell isMudflat ]
		minimumSize: 1.
		
	(self @@ PannSare) do: [ :agg | "self spaceModel meanCompactness: PannSare"
		agg initNeighbourhood ].
	
	self initialiseSareAttributesOf30x30CellsGrid .
	
]

{ #category : 'init 70x70 cells grid' }
PannModel >> buildSareOf70x70CellsGrid [
	
	self releaseAggregateType: PannSare .
	self
		createAggregates: PannSare 
		from: PannPlot
		verifying: [ :aCell | aCell isMudflat ]
		minimumSize: 1.
		
	(self @@ PannSare) do: [ :agg | "self spaceModel meanCompactness: PannSare"
		agg initNeighbourhood ].
	
	self initialiseSareAttributesOf70x70CellsGrid .
	
]

{ #category : 'init game grid' }
PannModel >> buildSareOfGameGrid [
	
	self releaseAggregateType: PannSare .
	self
		createAggregates: PannSare 
		from: PannPlot
		verifying: [ :aCell | aCell isMudflat ]
		minimumSize: 1.
		
	(self @@ PannSare) do: [ :agg | "self spaceModel meanCompactness: PannSare"
		agg initNeighbourhood ].
	
	self initialiseSareAttributesOfGameGrid .
	
]

{ #category : 'init single cell grid' }
PannModel >> buildSareOfSingleCellGrid [
	
	self releaseAggregateType: PannSare .
	self
		createAggregates: PannSare 
		from: PannPlot
		verifying: [ :aCell | aCell isMudflat ]
		minimumSize: 1.
		
	(self @@ PannSare) do: [ :agg | "self spaceModel meanCompactness: PannSare"
		agg initNeighbourhood ].
	
	self initialiseSareAttributesOfSingleCellGrid.
	
]

{ #category : 'init single cell with village grid' }
PannModel >> buildSareOfSingleCellWithVillageGrid [
	
	self releaseAggregateType: PannSare .
	self
		createAggregates: PannSare 
		from: PannPlot
		verifying: [ :aCell | aCell isMudflat ]
		minimumSize: 1.
		
	(self @@ PannSare) do: [ :agg | "self spaceModel meanCompactness: PannSare"
		agg initNeighbourhood ].
	
	self initialiseSareAttributesOfSingleCellWithVillageGrid.
	
]

{ #category : 'init single sare grid' }
PannModel >> buildSareOfSingleSareGrid [
	
	self releaseAggregateType: PannSare .
	self
		createAggregates: PannSare 
		from: PannPlot
		verifying: [ :aCell | aCell isMudflat ]
		minimumSize: 1.
		
	(self @@ PannSare) do: [ :agg | "self spaceModel meanCompactness: PannSare"
		agg initNeighbourhood ].
	
	self initialiseSareAttributesOfSingleSareGrid.
	
]

{ #category : 'management - seeding' }
PannModel >> checkForSeedingRequest [

    self seedingEnabled
        ifTrue: [
            seedingPending := true
        ].
]

{ #category : 'management - closure' }
PannModel >> closeSare1 [
	<parameterBooleanDefault: false>

	^ closeSare1
]

{ #category : 'management - closure' }
PannModel >> closeSare1: aBoolean [

	closeSare1 := aBoolean
]

{ #category : 'management - closure' }
PannModel >> closeSare2 [
	<parameterBooleanDefault: false>

	^ closeSare2
]

{ #category : 'management - closure' }
PannModel >> closeSare2: aBoolean [

	closeSare2 := aBoolean
]

{ #category : 'management - closure' }
PannModel >> closeSare3 [
	<parameterBooleanDefault: false>

	^ closeSare3
]

{ #category : 'management - closure' }
PannModel >> closeSare3: aBoolean [

	closeSare3 := aBoolean
]

{ #category : 'management - closure' }
PannModel >> closureDurationForSareId: anId [

    anId = 1 ifTrue: [ ^ self closureDurationSare1 ].
    anId = 2 ifTrue: [ ^ self closureDurationSare2 ].
    anId = 3 ifTrue: [ ^ self closureDurationSare3 ].

    ^ 0
]

{ #category : 'management - closure' }
PannModel >> closureDurationSare1 [
	<parameterIntegerDefault: 30>

	^ closureDurationSare1
]

{ #category : 'management - closure' }
PannModel >> closureDurationSare1: anInteger [

	closureDurationSare1 := anInteger
]

{ #category : 'management - closure' }
PannModel >> closureDurationSare2 [
	<parameterIntegerDefault: 30>

	^ closureDurationSare2
]

{ #category : 'management - closure' }
PannModel >> closureDurationSare2: anInteger [

	closureDurationSare2 := anInteger
]

{ #category : 'management - closure' }
PannModel >> closureDurationSare3 [
	<parameterIntegerDefault: 30>

	^ closureDurationSare3
]

{ #category : 'management - closure' }
PannModel >> closureDurationSare3: anInteger [

	closureDurationSare3 := anInteger
]

{ #category : 'accessing' }
PannModel >> cohorts [

	^ self @@ PannShellfishCohort
]

{ #category : 'social - population growth' }
PannModel >> createNewFishers: aValue [

 aValue > 0
        ifTrue: [
            self
                create: aValue
                randomlyLocatedEntitiesOfClass: PannFisher
                constrainedBy: [ :aCell | aCell state = #village ]
        ].
]

{ #category : 'accessing' }
PannModel >> currentDayOfMonth [

	^ currentDayOfMonth
]

{ #category : 'accessing' }
PannModel >> currentMonth [

	^ currentMonth
]

{ #category : 'time   ' }
PannModel >> dayCounter [

	^ dayCounter
]

{ #category : 'probes ' }
PannModel >> densityOfShellfishInFirstCohortProbe [

<probeNamed: 'Density of shellfish in the first cohort of the first population (ind/m²)' color: 'B784FF'>
    
    | cohorts result |
    cohorts := (self @@ PannShellfishCohort).
 
 	result := cohorts
        ifEmpty: [ 0 ]
        ifNotEmpty: [ cohorts first shellfishDensity ].

	^result roundTo: 0.01
]

{ #category : 'probes ' }
PannModel >> densityOfShellfishInFirstPopulationProbe [

<probeNamed: 'Density of shellfish in the first population ind/m²' color: 'F3A5FF'>
    
    | population result |
    population := (self @@ PannShellfishPopulation ).
 
 	result := population 
        ifEmpty: [ 0 ]
        ifNotEmpty: [ population first densityOfShellfishes ].

	^result roundTo: 0.01
]

{ #category : 'accessing' }
PannModel >> fishers [

	^ self @@ PannFisher
]

{ #category : 'probes ' }
PannModel >> freshBiomassOfExtractedShellfishProbe [

<probeNamed: ' Fresh biomass extracted today by all the fishers (g)' color: 'CC2E85'>
    
    | fishers result |
    fishers := self @@ PannFisher.

    result := fishers sum: [ :f | f freshBiomassOfExtractedShellfishToday ifNil: [ 0 ] ].

	^result roundTo: 0.01
]

{ #category : 'init 30x30 cells grid' }
PannModel >> init30x30CellsGrid [
	"This method is used to define the initial environment of a simulation. It will be executed once when the simulation is initialized."

	<init>
	
	currentDayOfMonth := 1.
	currentMonth := 11. "simulation starts in nov"
	dayCounter  := 0.
	
	"create grid"
	self
		createGridNumberOfRows: 30
		numberOfColumns: 30
		neighbourhood: 6
		closed: true.
		
 	self applyStatesFromMatrix: self stateMatrixOf30x30CellsGrid .
	
		self buildSareOf30x30CellsGrid.
		self addShellfishes.	
		self setCellAreaFromTotalFishableArea.
		self addFishers.

]

{ #category : 'init 70x70 cells grid' }
PannModel >> init70x70CellsGrid [
	"This method is used to define the initial environment of a simulation. It will be executed once when the simulation is initialized."

	<init>
	
	currentDayOfMonth := 1.
	currentMonth := 11. "simulation starts in nov"
	dayCounter  := 0.
	
	"create grid"
	self
		createGridNumberOfRows: 70
		numberOfColumns: 70
		neighbourhood: 6
		closed: true.
		
 	self applyStatesFromMatrix: self stateMatrixOf70x70CellsGrid .
		
		self buildSareOf70x70CellsGrid.
		self addShellfishes.	
		self setCellAreaFromTotalFishableArea.
		self addFishers.

]

{ #category : 'init game grid' }
PannModel >> initGameGrid [
	"This method is used to define the initial environment of a simulation. It will be executed once when the simulation is initialized."

	<init>
	
	currentDayOfMonth := 1.
	currentMonth := 11. "simulation starts in nov"
	dayCounter  := 0.
	
	"managment init"
	seedingPending := false.
	seedingActive := false.
	seedingExecutionDay := -1.
	
	"create grid"
	self
		createGridNumberOfRows: 9
		numberOfColumns: 9
		neighbourhood: 6
		closed: true.
		
 	self applyStatesFromMatrix: self stateMatrixOfGameGrid .

	self buildSareOfGameGrid.
	self addShellfishes.
	self setCellAreaFromTotalFishableArea.
	self addFishers.

]

{ #category : 'init single cell grid' }
PannModel >> initSingleCellGrid [
	"This method is used to define the initial environment of a simulation. It will be executed once when the simulation is initialized."

	<init>
	
	currentDayOfMonth := 1.
	currentMonth := 11. "simulation starts in nov"
	dayCounter  := 0.
	
	"create grid"
	self
		createGridNumberOfRows: 1
		numberOfColumns: 1
		neighbourhood: 6
		closed: true.
		
 	self applyStatesFromMatrix: self stateMatrixOfSingleCellGrid.
	
	self buildSareOfSingleCellGrid.
	self addShellfishes.	
	self setCellAreaFromTotalFishableArea.
]

{ #category : 'init single cell with village grid' }
PannModel >> initSingleCellWithVillageGrid [
	"This method is used to define the initial environment of a simulation. It will be executed once when the simulation is initialized."

	<init>
	
	currentDayOfMonth := 1.
	currentMonth := 11. "simulation starts in nov"
	dayCounter  := 0.
	
	"create grid"
	self
		createGridNumberOfRows: 1
		numberOfColumns: 2
		neighbourhood: 6
		closed: true.
		
 	self applyStatesFromMatrix: self stateMatrixOfSingleCellWithVillageGrid.
	
		self buildSareOfSingleCellWithVillageGrid. 
		self addShellfishes.	
		self setCellAreaFromTotalFishableArea.
		self addFishers.

]

{ #category : 'init single sare grid' }
PannModel >> initSingleSareGrid [
	"This method is used to define the initial environment of a simulation. It will be executed once when the simulation is initialized."
	
	<init>
	
	currentDayOfMonth := 1.
	currentMonth := 11. "simulation starts in nov"
	dayCounter  := 0.
	
	"create grid"
	self
		createGridNumberOfRows: 5
		numberOfColumns: 5
		neighbourhood: 6
		closed: true.
		
 	self applyStatesFromMatrix: self stateMatrixOfSingleSareGrid.
	
		self buildSareOfSingleSareGrid. 
		self addShellfishes.	
		self setCellAreaFromTotalFishableArea.
		self addFishers.

]

{ #category : 'init  ' }
PannModel >> initialNumberOfFishers [
	<parameterFloatDefault: 100>

    ^ initialNumberOfFishers
]

{ #category : 'init  ' }
PannModel >> initialNumberOfFishers: aValue [

	initialNumberOfFishers := aValue
]

{ #category : 'init 30x30 cells grid' }
PannModel >> initialiseSareAttributesOf30x30CellsGrid [

	| sare |
	
	sare := ( self @@ PannSare ) detect: [ :each | each id = 1]. 
	sare name: '1'.
	sare recruitCapacity: 100 * recruitmentRateMultiplier. 
	sare naturalDeathRate: naturalDeathRate.
	sare growthRate: shellfishGrowthRate.
	sare maxShellfishLength: 38.
	
	sare := ( self @@ PannSare ) detect: [ :each | each id = 2]. 
	sare name: '2'.
	sare recruitCapacity: 40 * recruitmentRateMultiplier. 
	sare naturalDeathRate: naturalDeathRate.
	sare growthRate: shellfishGrowthRate.
	sare maxShellfishLength: 38.
	
	sare := ( self @@ PannSare ) detect: [ :each | each id = 3]. 
	sare name: '3'.
	sare recruitCapacity: 10 * recruitmentRateMultiplier. 
	sare naturalDeathRate: naturalDeathRate.
	sare growthRate: shellfishGrowthRate.
	sare maxShellfishLength: 38.

]

{ #category : 'init 70x70 cells grid' }
PannModel >> initialiseSareAttributesOf70x70CellsGrid [

	| sare |
	
	sare := ( self @@ PannSare ) detect: [ :each | each id = 1]. 
	sare name: '1'.
	sare recruitCapacity: 100 * recruitmentRateMultiplier. 
	sare naturalDeathRate: naturalDeathRate.
	sare growthRate: shellfishGrowthRate.
	sare maxShellfishLength: 38.
	
	sare := ( self @@ PannSare ) detect: [ :each | each id = 2]. 
	sare name: '2'.
	sare recruitCapacity: 40 * recruitmentRateMultiplier. 
	sare naturalDeathRate: naturalDeathRate.
	sare growthRate: shellfishGrowthRate.
	sare maxShellfishLength: 38.
	
	sare := ( self @@ PannSare ) detect: [ :each | each id = 3]. 
	sare name: '3'.
	sare recruitCapacity: 10 * recruitmentRateMultiplier. 
	sare naturalDeathRate: naturalDeathRate.
	sare growthRate: shellfishGrowthRate.
	sare maxShellfishLength: 38.
	
]

{ #category : 'init game grid' }
PannModel >> initialiseSareAttributesOfGameGrid [

	| sare |
	
	sare := ( self @@ PannSare ) detect: [ :each | each id = 1]. 
	sare name: '1'.
	sare recruitCapacity: 100 * recruitmentRateMultiplier. 
	sare naturalDeathRate: naturalDeathRate.
	sare growthRate: shellfishGrowthRate.
	sare maxShellfishLength: 38.
	
	sare := ( self @@ PannSare ) detect: [ :each | each id = 2]. 
	sare name: '2'.
	sare recruitCapacity: 40 * recruitmentRateMultiplier. 
	sare naturalDeathRate: naturalDeathRate.
	sare growthRate: shellfishGrowthRate.
	sare maxShellfishLength: 38.
	
	sare := ( self @@ PannSare ) detect: [ :each | each id = 3]. 
	sare name: '3'.
	sare recruitCapacity: 10 * recruitmentRateMultiplier. 
	sare naturalDeathRate: naturalDeathRate.
	sare growthRate: shellfishGrowthRate.
	sare maxShellfishLength: 38.
]

{ #category : 'init single cell grid' }
PannModel >> initialiseSareAttributesOfSingleCellGrid [

	| sare |
	
	sare := ( self @@ PannSare ) detect: [ :each | each id = 1]. 
	sare name: 'amacala 1'.
	sare recruitCapacity: 50 * recruitmentRateMultiplier.
	sare naturalDeathRate: naturalDeathRate.
	sare growthRate: shellfishGrowthRate.
	sare maxShellfishLength: 38.
]

{ #category : 'init single cell with village grid' }
PannModel >> initialiseSareAttributesOfSingleCellWithVillageGrid [

	| sare |
	
	sare := ( self @@ PannSare ) detect: [ :each | each id = 1]. 
	sare name: 'amacala 1'.
	sare recruitCapacity: 50 * recruitmentRateMultiplier. 
	sare naturalDeathRate: naturalDeathRate.
	sare growthRate: shellfishGrowthRate.
	sare maxShellfishLength: 38.
]

{ #category : 'init single sare grid' }
PannModel >> initialiseSareAttributesOfSingleSareGrid [

	| sare |
	
	sare := ( self @@ PannSare ) detect: [ :each | each id = 1]. 
	sare name: 'amacala 1'.
	sare recruitCapacity: 50 * recruitmentRateMultiplier.
	sare naturalDeathRate: naturalDeathRate.
	sare growthRate: shellfishGrowthRate.
	sare maxShellfishLength: 38.
]

{ #category : 'initialization' }
PannModel >> initialize [

	super initialize. 
	
	totalEarnings := 0.
]

{ #category : 'management - biological resting period' }
PannModel >> isFishingPeriod [
    | restStart restEnd |

    restStart := self biologicalRestStartMonth.
    restEnd := self biologicalRestEndMonth.

    restStart <= restEnd
        ifTrue: [
            ^ (currentMonth < restStart)
                or: [ currentMonth > restEnd ]
        ]
        ifFalse: [
            ^ (currentMonth > restEnd)
                and: [ currentMonth < restStart ]
        ]
]

{ #category : 'accessing' }
PannModel >> mudflats [

	^ self cells select: [ :each | each isMudflat ]
]

{ #category : 'ecol - natural mortality' }
PannModel >> naturalDeathRate [
    <parameterFloatDefault: 0.00219>

	^ naturalDeathRate
]

{ #category : 'ecol - natural mortality' }
PannModel >> naturalDeathRate: aValue [

	naturalDeathRate := aValue
]

{ #category : 'probes ' }
PannModel >> numberOfExtractedShellfishProbe [

<probeNamed: 'Number of extracted shellfish' color: '00FFF3'>
    
    | fishers result |
    fishers := self @@ PannFisher.

    result := fishers sum: [ :f | f numberOfExtractedShellfishToday ifNil: [ 0 ] ].

	^result rounded
]

{ #category : 'social - population growth' }
PannModel >> numberOfFishers [

    ^ (self @@ PannFisher) size
]

{ #category : 'probes ' }
PannModel >> numberOfFishersProbe [

	<probeNamed: 'Number of fishers' color: '00B44C'>
	
    ^ self numberOfFishers
]

{ #category : 'probes ' }
PannModel >> numberOfShellfishInFirstCohortProbe [

<probeNamed: 'Number of shellfish in the first cohort of the first population' color: '0000FF'>
    
    | cohorts result |
    cohorts := (self @@ PannShellfishCohort).
 
 	result := cohorts
        ifEmpty: [ 0 ]
        ifNotEmpty: [ cohorts first numberOfShellfishes ].

	^ result rounded
]

{ #category : 'probes ' }
PannModel >> numberOfShellfishInFirstPopulationProbe [

<probeNamed: 'Number of shellfish in the first population' color: 'E67E22'>
    
    | population result |
    population := (self @@ PannShellfishPopulation ).
 
 	result := population 
        ifEmpty: [ 0 ]
        ifNotEmpty: [ population first numberOfShellfishes ].

	^result rounded
]

{ #category : 'accessing' }
PannModel >> populations [

	^ self @@ PannShellfishPopulation
]

{ #category : 'ecol - recruitment rate' }
PannModel >> recruitmentRateMultiplier [
    <parameterFloatDefault: 1>

	^ recruitmentRateMultiplier
]

{ #category : 'ecol - recruitment rate' }
PannModel >> recruitmentRateMultiplier: aValue [

	recruitmentRateMultiplier := aValue.
	
	self updateSareBiologicalParameters.
]

{ #category : 'init  ' }
PannModel >> sareNamed: aString [
"to access a sare by his name"

	^ self sares detect: [ :each | each name = aString ]
]

{ #category : 'init  ' }
PannModel >> sares [

	^ self @@ PannSare
]

{ #category : 'collect data' }
PannModel >> saveCellDataToCsv [
    | folder file |
     "Provide the path to a folder where you want to save your data"
    folder := 'D:\data_pann' asFileReference.

   "If your folder does not exist, it will be created"
    folder ensureCreateDirectory.
    
    self cells
        select: [ :each | each isMudflat ]
        thenDo: [ :each |
            file := folder / ('data-mudflat', each id asString, '.csv').
            each saveDataToCsv: file ].
]

{ #category : 'management - seeding' }
PannModel >> seedingActive [

	^ seedingActive
]

{ #category : 'management - seeding' }
PannModel >> seedingActive: anObject [

	seedingActive := anObject
]

{ #category : 'management - seeding' }
PannModel >> seedingDestinationSareId [
    <parameterIntegerDefault: 0>

	^ seedingDestinationSareId
]

{ #category : 'management - seeding' }
PannModel >> seedingDestinationSareId: anInteger [

	seedingDestinationSareId := anInteger
]

{ #category : 'management - seeding' }
PannModel >> seedingEnabled [
    <parameterBooleanDefault: false>

    ^ seedingEnabled
]

{ #category : 'management - seeding' }
PannModel >> seedingEnabled: aBoolean [

    seedingEnabled := aBoolean
]

{ #category : 'management - seeding' }
PannModel >> seedingExecutionDay [

	^ seedingExecutionDay
]

{ #category : 'management - seeding' }
PannModel >> seedingExecutionDay: anObject [

	seedingExecutionDay := anObject
]

{ #category : 'management - seeding' }
PannModel >> seedingPending [

	^ seedingPending
]

{ #category : 'management - seeding' }
PannModel >> seedingPending: anObject [

	seedingPending := anObject
]

{ #category : 'management - seeding' }
PannModel >> seedingSareForId: aSareId [
    ^ (self @@ PannSare)
        detect: [ :each | each id = aSareId ]
        ifNone: [ nil ]
]

{ #category : 'management - seeding' }
PannModel >> seedingSourceSareId [
    <parameterIntegerDefault: 0>

    ^ seedingSourceSareId
]

{ #category : 'management - seeding' }
PannModel >> seedingSourceSareId: anInteger [

    seedingSourceSareId := anInteger
]

{ #category : 'init  ' }
PannModel >> setCellAreaFromTotalFishableArea [

    | mudflatCells cellArea |

    mudflatCells := self cells select: [ :cell |
        cell isMudflat
    ].

    mudflatCells ifEmpty: [ ^ self ].

    cellArea := totalFisheableArea / mudflatCells size.

    mudflatCells do: [ :cell |
        cell area: cellArea
    ].
]

{ #category : 'management - closure' }
PannModel >> setCloseSareId: anId to: aBoolean [

    anId = 1 ifTrue: [
        self closeSare1: aBoolean.
        ^ self
    ].

    anId = 2 ifTrue: [
        self closeSare2: aBoolean.
        ^ self
    ].

    anId = 3 ifTrue: [
        self closeSare3: aBoolean.
        ^ self
    ].
]

{ #category : 'probes ' }
PannModel >> shellfishDensitySare1Probe [
    <probeNamed: 'Shellfish density - Mudflat 1 (ind/m²)' color: 'ef0018'>

    | sare totalIndividuals totalArea result |

    sare := (self @@ PannSare)
        detect: [ :each | each id = 1 ]
        ifNone: [ nil ].

    sare ifNil: [ ^ 0 ].

    totalIndividuals := 0.
    totalArea := 0.

    sare plots do: [ :cell |
        | population |
        population := cell shellfishPopulation.

        totalArea := totalArea + cell area.

        population cohorts do: [ :cohort |
            totalIndividuals := totalIndividuals
                + (cohort shellfishDensity * cell area)
        ]
    ].

    totalArea = 0 ifTrue: [ ^ 0 ].
    
	result := totalIndividuals / totalArea.
	
	^result roundTo: 0.01

]

{ #category : 'probes ' }
PannModel >> shellfishDensitySare2Probe [
    <probeNamed: 'Shellfish density - Mudflat 2 (ind/m²)' color: '00ef60'>

    | sare totalIndividuals totalArea result |

    sare := (self @@ PannSare)
        detect: [ :each | each id = 2 ]
        ifNone: [ nil ].

    sare ifNil: [ ^ 0 ].

    totalIndividuals := 0.
    totalArea := 0.

    sare plots do: [ :cell |
        | population |
        population := cell shellfishPopulation.

        totalArea := totalArea + cell area.

        population cohorts do: [ :cohort |
            totalIndividuals := totalIndividuals
                + (cohort shellfishDensity * cell area)
        ]
    ].

    totalArea = 0 ifTrue: [ ^ 0 ].
    
	result := totalIndividuals / totalArea.
	
	^result roundTo: 0.01

]

{ #category : 'probes ' }
PannModel >> shellfishDensitySare3Probe [
    <probeNamed: 'Shellfish density - Mudflat 3 (ind/m²)' color: 'e6e600'>

    | sare totalIndividuals totalArea result |

    sare := (self @@ PannSare)
        detect: [ :each | each id = 3 ]
        ifNone: [ nil ].

    sare ifNil: [ ^ 0 ].

    totalIndividuals := 0.
    totalArea := 0.

    sare plots do: [ :cell |
        | population |
        population := cell shellfishPopulation.

        totalArea := totalArea + cell area.

        population cohorts do: [ :cohort |
            totalIndividuals := totalIndividuals
                + (cohort shellfishDensity * cell area)
        ]
    ].

    totalArea = 0 ifTrue: [ ^ 0 ].
    
	result := totalIndividuals / totalArea.

	^result roundTo: 0.01

]

{ #category : 'ecol - shellfish growth' }
PannModel >> shellfishGrowthRate [
    <parameterFloatDefault: 0.00203>

    ^ shellfishGrowthRate
]

{ #category : 'ecol - shellfish growth' }
PannModel >> shellfishGrowthRate: aValue [

	shellfishGrowthRate := aValue.
	
	self updateSareBiologicalParameters.
	
]

{ #category : 'management - closure' }
PannModel >> shouldCloseSareId: anId [

    anId = 1 ifTrue: [ ^ self closeSare1 ].
    anId = 2 ifTrue: [ ^ self closeSare2 ].
    anId = 3 ifTrue: [ ^ self closeSare3 ].

    ^ false
]

{ #category : 'probes ' }
PannModel >> sizeOfShellfishInFirstCohortProbe [

<probeNamed: 'Size of the super individual of the cohort (mm)' color: '0000FF'>
    
    | cohorts result |
    cohorts := (self @@ PannShellfishCohort).
 
 	result := cohorts
        ifEmpty: [ 0 ]
        ifNotEmpty: [ cohorts first shellfishSize ].

	^result rounded
]

{ #category : 'init 30x30 cells grid' }
PannModel >> stateMatrixOf30x30CellsGrid [
    "Returns a sample map : 0 = sea, 1 = village, 2 = mudflat, 3 = mangrove."

    ^ #(
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 2 2 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 2 2 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 2 2 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 2 2 0 0 0 0 0 0 0 0 0 3 3 3 3 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 2 0 0 0 0 0 0 3 3 3 3 3 3 3 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 1 2 2 0 0 0 0 0 0 0 3 3 3 3 3 3 3)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 3)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 0 0 0 2 2 0 0 0 3)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 0 0 0 0 0 3 3)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3)
    )
]

{ #category : 'init 70x70 cells grid' }
PannModel >> stateMatrixOf70x70CellsGrid [
    "Returns a sample map : 0 = sea, 1 = village, 2 = mudflat, 3 = mangrove."

    ^ #(
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 0 3 3 3 3 3 3 3 3 3 3 3 0 0 0 0 3 3 3 3 3 3 3 0 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 0 0 3 3 3 3 3 3 3 3 3 3 0 0 0 0 0 3 3 3 3 3 0 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 0 0 3 3 0 3 3 3 3 3 3 0 0 0 0 0 0 0 0 0 0 3 3 0 0 0 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 0 0 0 3 3 3 3 3 3 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 3 3 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 3 3 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 3 3 0 0 0 0 0 0 0 0 0 0 3 3 3 3 0 0 0)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 0 0 0 0 0 0 0 0 0 0 0 0 3 3 0 0 0 0)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
	(0 0 0 0 0 0 0 0 0 2 2 2 2 2 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3)
	(0 0 0 0 0 0 0 0 0 2 2 2 2 2 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 2 2 2 2 2 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 2 2 2 2 2 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 2 2 2 2 2 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 2 2 2 2 2 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 2 2 2 2 2 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 0 0 3 3 3 3 3 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 0 0 3 3 3 3 0 3 0 0 3 3 3 3 3 0 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 0 3 3 3 3 0 3 3 0 3 3 0 0 0 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 0 0 3 3 0 3 3 3 0 3 0 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 0 3 0 3 3 3 3 0 0 3 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 3 3 0 0 3 3 3 3 3 3 3 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 0 0 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 0 0 0 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 0 3 0 0 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 0 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 0 0 3 3 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 0 0 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 0 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 0 0 0 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 0 3 3 3 3 3 0 0 0)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 0 0 3 3 3 3 3 3 3 3 3 3 0 3 3 0 0 0 0 0 0)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 3 3 3 3 3 3 3 3 3 3 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 0 0 0 0 0 0 0 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 2 2 2 2 2 0 0 0 3 3 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 2 2 2 2 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 2 2 2 2 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 2 2 2 2 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 2 2 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 0 0 3 3 3 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 0 0 3 0 3 3 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 0 3 0 0 0 0 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 0 0 3 3 0 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 0 3 0 0)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 0 3 3 3 3 3 3 3 3 3 3 3 3 3 0 3 0 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 0 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 0 0 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 0 0 0 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 2 2 0 0 0 0 0 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 2 2 2 2 0 0 0 0 0 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 2 2 2 2 2 0 0 0 0 0 0 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 3 3 3 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 0 3 3 3 3 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 0 3 3 3 3 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 0 0 3 3 3 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 0 3 3 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 0 0 3 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 0 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3)
	)
]

{ #category : 'init game grid' }
PannModel >> stateMatrixOfGameGrid [
    "Returns a sample map : 0 = sea, 1 = village, 2 = mudflat, 3 = mangrove."
	"9x9 grid"

    ^ #(
		(0 0 0 0 0 0 0 0 3)
		(0 2 2 0 0 0 0 3 3)
		(0 0 2 0 0 0 3 0 3)
		(0 0 0 0 0 3 3 3 3)
		(0 0 0 0 1 0 0 3 3)
		(0 0 0 2 2 0 0 3 3)
		(0 0 3 0 0 0 0 0 3)
		(0 3 0 3 3 0 2 0 3)
		(3 3 3 3 3 3 0 0 3)
    )
]

{ #category : 'init single cell grid' }
PannModel >> stateMatrixOfSingleCellGrid [
    "Returns a sample map : 0 = sea, 1 = village, 2 = mudflat, 3 = mangrove."

    ^ #(
		(2)
    )
]

{ #category : 'init single cell with village grid' }
PannModel >> stateMatrixOfSingleCellWithVillageGrid [
    "Returns a sample map : 0 = sea, 1 = village, 2 = mudflat, 3 = mangrove."

    ^ #(
		(2 1)
    )
]

{ #category : 'init single sare grid' }
PannModel >> stateMatrixOfSingleSareGrid [
    "Returns a sample map : 0 = sea, 1 = village, 2 = mudflat, 3 = mangrove."

    ^ #(
		(0 0 0 0 0)
		(0 1 2 0 0)
		(0 2 2 0 3)
		(0 0 0 0 3)
		(0 0 0 3 3)
    )
]

{ #category : 'step  ' }
PannModel >> step [

	<control>
	
	"time steps"
	self updateDate.
	self updateFishersPopulation.
	
	"managment steps"
	"self updateSeeding."
	self applyRequestedClosures.
    self updateClosures.
	
	"agents steps"	
	self cohorts do: [ :cohort | cohort step ].
	self populations do: [ :population | population step ].
	self sares do: [ :sare | sare step ].
	(self shuffled: self fishers) do: [ :fisher | fisher step ].
	
	"collect data"
	self mudflats do: [ :each | each collectData ].
	totalEarnings := totalEarnings + (self fishers sum: #dailyEarnings).
]

{ #category : 'probes ' }
PannModel >> totalAvailableFreshBiomassProbe [
    <probeNamed: 'Total available fresh biomass (g)' color: '2E86C1'>

    | populations result |

    populations := self @@ PannShellfishPopulation.

    result := populations sum: [ :population |
        | cell |
        cell := population cell.

        population cohorts sum: [ :cohort |
            cohort oneIndividualTotalBiomass
                * cohort shellfishDensity
                * cell area
        ]
    ].

	^result rounded
]

{ #category : 'init  ' }
PannModel >> totalFisheableArea [
	    <parameterFloatDefault: 1572600>

	^ totalFisheableArea
]

{ #category : 'init  ' }
PannModel >> totalFisheableArea: aValue [

	totalFisheableArea := aValue
]

{ #category : 'management - closure' }
PannModel >> updateClosures [

    (self @@ PannSare) do: [ :sare |
        sare isClosed ifTrue: [
            self dayCounter >= (
                sare closureStartDay
                    + (self closureDurationForSareId: sare id)
            )
                ifTrue: [
                    sare open
                ]
        ]
    ]
]

{ #category : 'time   ' }
PannModel >> updateDate [
    "Move forward one day and update the month accordingly"
    | daysInMonth |

	daysInMonth := #(31 28 31 30 31 30 31 31 30 31 30 31).  "Number of day per month"

   currentDayOfMonth := currentDayOfMonth + 1.
	dayCounter := dayCounter + 1.

   (currentDayOfMonth > (daysInMonth at: currentMonth)) ifTrue: [
		currentDayOfMonth := 1.
		currentMonth := (currentMonth \\ 12) + 1.
    ].
]

{ #category : 'social - population growth' }
PannModel >> updateFishersPopulation [
    self applyAnnualPopulationGrowthIfNeeded.
]

{ #category : 'ecol - recruitment rate' }
PannModel >> updateSareBiologicalParameters [

    self sares do: [ :sare |
        sare growthRate: self shellfishGrowthRate.

		  sare naturalDeathRate: self naturalDeathRate.

        sare recruitCapacity:
            (sare id = 1
                ifTrue: [ 100 ]
                ifFalse: [
                    sare id = 2
                        ifTrue: [ 40 ]
                        ifFalse: [ 10 ]
                ]) * self recruitmentRateMultiplier
    ].
]

{ #category : 'management - seeding' }
PannModel >> updateSeeding [
    | source destination |

    "Enregistrer la demande de l'utilisateur"
    self seedingEnabled ifTrue: [
        seedingPending := true.
        self seedingEnabled: false
    ].

    "Une opération déjà commencée reste active pendant sa journée"
    seedingActive ifTrue: [
        dayCounter > seedingExecutionDay ifTrue: [
            seedingActive := false.
            seedingPending := false
        ].
        ^ self
    ].

    seedingPending ifFalse: [ ^ self ].

    "Attendre un jour où la pêche est autorisée"
    self isFishingPeriod ifFalse: [ ^ self ].

    source := self seedingSareForId: self seedingSourceSareId.
    destination := self seedingSareForId: self seedingDestinationSareId.

    source ifNil: [ ^ self ].
    destination ifNil: [ ^ self ].

    source = destination ifTrue: [ ^ self ].
    source isClosed ifTrue: [ ^ self ].

    "Déclencher l'opération pour cette journée"
    seedingActive := true.
    seedingExecutionDay := dayCounter.
]
