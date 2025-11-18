Class {
	#name : 'EcoPannModel',
	#superclass : 'CMAbstractModel',
	#instVars : [
		'currentDayOfMonth',
		'currentMonth',
		'dayCounter'
	],
	#category : 'PannEcol-Model',
	#package : 'PannEcol-Model'
}

{ #category : 'as yet unclassified' }
EcoPannModel class >> modelName [

	^ 'PannEcol'
]

{ #category : 'accessing' }
EcoPannModel class >> prefix [

	^ 'PE'
]

{ #category : 'init  ' }
EcoPannModel >> addFishers [

	self
		createN: 1
		randomlyLocatedEntities: EcoPannFisher 
		constrainedBy: [ :aCell | aCell state = #village ].
]

{ #category : 'init  ' }
EcoPannModel >> addShellfishes [

	(self cells select: [ :c | c state = #mudflat ]) do: [ :cell |
		self newEntity: EcoPannShellfishPopulation locatedAt: cell ].
]

{ #category : 'init  ' }
EcoPannModel >> applyStatesFromMatrix: aMatrix [

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

{ #category : 'init 30x30 cells grid' }
EcoPannModel >> buildSareOf30x30CellsGrid [
	
	self releaseAggregateType: EcoPannSare .
	self
		createAggregates: EcoPannSare 
		from: EcoPannPlot
		verifying: [ :aCell | aCell isMudflat ]
		minimumSize: 1.
		
	(self @@ EcoPannSare) do: [ :agg | "self spaceModel meanCompactness: PannSare"
		agg initNeighbourhood ].
	
	self initialiseSareAttributesOf30x30CellsGrid .
	
]

{ #category : 'init 70x70 cells grid' }
EcoPannModel >> buildSareOf70x70CellsGrid [
	
	self releaseAggregateType: EcoPannSare .
	self
		createAggregates: EcoPannSare 
		from: EcoPannPlot
		verifying: [ :aCell | aCell isMudflat ]
		minimumSize: 1.
		
	(self @@ EcoPannSare) do: [ :agg | "self spaceModel meanCompactness: PannSare"
		agg initNeighbourhood ].
	
	self initialiseSareAttributesOf70x70CellsGrid .
	
]

{ #category : 'init single cell grid' }
EcoPannModel >> buildSareOfSingleCellGrid [
	
	self releaseAggregateType: EcoPannSare .
	self
		createAggregates: EcoPannSare 
		from: EcoPannPlot
		verifying: [ :aCell | aCell isMudflat ]
		minimumSize: 1.
		
	(self @@ EcoPannSare) do: [ :agg | "self spaceModel meanCompactness: PannSare"
		agg initNeighbourhood ].
	
	self initialiseSareAttributesOfSingleCellGrid.
	
]

{ #category : 'init single cell with village grid' }
EcoPannModel >> buildSareOfSingleCellWithVillageGrid [
	
	self releaseAggregateType: EcoPannSare .
	self
		createAggregates: EcoPannSare 
		from: EcoPannPlot
		verifying: [ :aCell | aCell isMudflat ]
		minimumSize: 1.
		
	(self @@ EcoPannSare) do: [ :agg | "self spaceModel meanCompactness: PannSare"
		agg initNeighbourhood ].
	
	self initialiseSareAttributesOfSingleCellWithVillageGrid.
	
]

{ #category : 'init single sare grid' }
EcoPannModel >> buildSareOfSingleSareGrid [
	
	self releaseAggregateType: EcoPannSare .
	self
		createAggregates: EcoPannSare 
		from: EcoPannPlot
		verifying: [ :aCell | aCell isMudflat ]
		minimumSize: 1.
		
	(self @@ EcoPannSare) do: [ :agg | "self spaceModel meanCompactness: PannSare"
		agg initNeighbourhood ].
	
	self initialiseSareAttributesOfSingleSareGrid.
	
]

{ #category : 'accessing' }
EcoPannModel >> currentDayOfMonth [

	^ currentDayOfMonth
]

{ #category : 'accessing' }
EcoPannModel >> currentMonth [

	^ currentMonth
]

{ #category : 'accessing' }
EcoPannModel >> dayCounter [

	^ dayCounter
]

{ #category : 'init 30x30 cells grid' }
EcoPannModel >> init30x30CellsGrid [
	"This method is used to define the initial environment of a simulation. It will be executed once when the simulation is initialized."
	
	"In this grid, one cell is 1m²"

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
		
	self cells do: [ : each | each area: 1]. "define the size of a cell to 1m²"
		
 	self applyStatesFromMatrix: self stateMatrixOf30x30CellsGrid .
	
		self addShellfishes.	
		self buildSareOf30x30CellsGrid . 

]

{ #category : 'init 70x70 cells grid' }
EcoPannModel >> init70x70CellsGrid [
	"This method is used to define the initial environment of a simulation. It will be executed once when the simulation is initialized."
	
	"In this grid, one cell is 1m²"

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
		
	self cells do: [ : each | each area: 1]. "define the size of a cell to 1m²"
		
 	self applyStatesFromMatrix: self stateMatrixOf70x70CellsGrid .
	
	"add shellfish on every mudflat cell"
	(self cells select: [ :c | c state = #mudflat ]) do: [ :cell |
		self newEntity: EcoPannShellfishPopulation locatedAt: cell ].
	
		self buildSareOf70x70CellsGrid . 

]

{ #category : 'init single cell grid' }
EcoPannModel >> initSingleCellGrid [
	"This method is used to define the initial environment of a simulation. It will be executed once when the simulation is initialized."
	
	"In this grid, one cell is 1m²"

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
		
	self cells do: [ : each | each area: 500000]. "define the size of a cell to 500 000 m²"
		
 	self applyStatesFromMatrix: self stateMatrixOfSingleCellGrid.
	
	"add shellfish on every mudflat cell"
	(self cells select: [ :c | c state = #mudflat ]) do: [ :cell |
		self newEntity: EcoPannShellfishPopulation locatedAt: cell ].
	
		self buildSareOfSingleCellGrid. 

		self addFishers.

]

{ #category : 'init single cell with village grid' }
EcoPannModel >> initSingleCellWithVillageGrid [
	"This method is used to define the initial environment of a simulation. It will be executed once when the simulation is initialized."
	
	"In this grid, one cell is 1m²"

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
		
	self cells do: [ : each | each area: 500000]. "define the size of a cell to 500 000 m²"
		
 	self applyStatesFromMatrix: self stateMatrixOfSingleCellWithVillageGrid.
	
	"add shellfish on every mudflat cell"
	(self cells select: [ :c | c state = #mudflat ]) do: [ :cell |
		self newEntity: EcoPannShellfishPopulation locatedAt: cell ].
	
		self buildSareOfSingleCellWithVillageGrid. 

		self addFishers.

]

{ #category : 'init single sare grid' }
EcoPannModel >> initSingleSareGrid [
	"This method is used to define the initial environment of a simulation. It will be executed once when the simulation is initialized."
	
	"In this grid, one cell is 1m²"

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
		
	self cells do: [ : each | each area: 1]. "define the size of a cell to 1m²"
		
 	self applyStatesFromMatrix: self stateMatrixOfSingleSareGrid.
	
	"add shellfish on every mudflat cell"
	(self cells select: [ :c | c state = #mudflat ]) do: [ :cell |
		self newEntity: EcoPannShellfishPopulation locatedAt: cell ].
	
		self buildSareOfSingleSareGrid. 

]

{ #category : 'init 30x30 cells grid' }
EcoPannModel >> initialiseSareAttributesOf30x30CellsGrid [

	| sare |
	
	sare := ( self @@ EcoPannSare ) detect: [ :each | each id = 1]. 
	sare name: 'amacala 1'.
	sare recruitCapacity: 200. 
	sare naturalDeathRate: 0.00219.
	sare growthRate: 0.00203.
	sare maxShellfishLength: 38.
	
	sare := ( self @@ EcoPannSare ) detect: [ :each | each id = 2]. 
	sare name: 'anewanew 1'.
	sare recruitCapacity: 175. 
	sare naturalDeathRate: 0.00219.
	sare growthRate: 0.00203.
	sare maxShellfishLength: 38.
	
	sare := ( self @@ EcoPannSare ) detect: [ :each | each id = 3]. 
	sare name: 'mbina'.
	sare recruitCapacity: 150. 
	sare naturalDeathRate: 0.00219.
	sare growthRate: 0.00203.
	sare maxShellfishLength: 38.
	
	sare := ( self @@ EcoPannSare ) detect: [ :each | each id = 4]. 
	sare name: 'anewanew 2'.
	sare recruitCapacity: 125. 
	sare naturalDeathRate: 0.00219.
	sare growthRate: 0.00203.
	sare maxShellfishLength: 38.
	
	sare := ( self @@ EcoPannSare ) detect: [ :each | each id = 5]. 
	sare name: 'amacala 2'.
	sare recruitCapacity: 100. 
	sare naturalDeathRate: 0.00219.
	sare growthRate: 0.00203.
	sare maxShellfishLength: 38.
]

{ #category : 'init 70x70 cells grid' }
EcoPannModel >> initialiseSareAttributesOf70x70CellsGrid [

	| sare |
	
	sare := ( self @@ EcoPannSare ) detect: [ :each | each id = 1]. 
	sare name: 'amacala 1'.
	sare recruitCapacity: 200. 
	sare naturalDeathRate: 0.00219.
	sare growthRate: 0.00203.
	sare maxShellfishLength: 38.
	
	sare := ( self @@ EcoPannSare ) detect: [ :each | each id = 2]. 
	sare name: 'anewanew 1'.
	sare recruitCapacity: 175. 
	sare naturalDeathRate: 0.00219.
	sare growthRate: 0.00203.
	sare maxShellfishLength: 38.
	
	sare := ( self @@ EcoPannSare ) detect: [ :each | each id = 3]. 
	sare name: 'mbina'.
	sare recruitCapacity: 150. 
	sare naturalDeathRate: 0.00219.
	sare growthRate: 0.00203.
	sare maxShellfishLength: 38.
	
	sare := ( self @@ EcoPannSare ) detect: [ :each | each id = 4]. 
	sare name: 'anewanew 2'.
	sare recruitCapacity: 125. 
	sare naturalDeathRate: 0.00219.
	sare growthRate: 0.00203.
	sare maxShellfishLength: 38.
	
	sare := ( self @@ EcoPannSare ) detect: [ :each | each id = 5]. 
	sare name: 'amacala 2'.
	sare recruitCapacity: 100. 
	sare naturalDeathRate: 0.00219.
	sare growthRate: 0.00203.
	sare maxShellfishLength: 38.
]

{ #category : 'init single cell grid' }
EcoPannModel >> initialiseSareAttributesOfSingleCellGrid [

	| sare |
	
	sare := ( self @@ EcoPannSare ) detect: [ :each | each id = 1]. 
	sare name: 'amacala 1'.
	sare recruitCapacity: 200.
	sare naturalDeathRate: 0.00219.
	sare growthRate: 0.00203.
	sare maxShellfishLength: 38.
]

{ #category : 'init single cell with village grid' }
EcoPannModel >> initialiseSareAttributesOfSingleCellWithVillageGrid [

	| sare |
	
	sare := ( self @@ EcoPannSare ) detect: [ :each | each id = 1]. 
	sare name: 'amacala 1'.
	sare recruitCapacity: 50.
	sare naturalDeathRate: 0.00219.
	sare growthRate: 0.00203.
	sare maxShellfishLength: 38.
]

{ #category : 'init single sare grid' }
EcoPannModel >> initialiseSareAttributesOfSingleSareGrid [

	| sare |
	
	sare := ( self @@ EcoPannSare ) detect: [ :each | each id = 1]. 
	sare name: 'amacala 1'.
	sare recruitCapacity: 200.
	sare naturalDeathRate: 0.00219.
	sare growthRate: 0.00203.
	sare maxShellfishLength: 38.
]

{ #category : 'probes ' }
EcoPannModel >> numberOfCohorts [ 

	<probeNamed: 'Number of cohorts' color: '00B44C'>
	
	| pop |
	pop := (self @@ EcoPannShellfishPopulation) first.
	^ pop cohortsCounter .
]

{ #category : 'init  ' }
EcoPannModel >> sareNamed: aString [
"to access a sare by his name"

	^(self @@ EcoPannSare) detect: [ :each | each name = aString ]
]

{ #category : 'probes ' }
EcoPannModel >> sizeOfCohorts [

"<probeNamed: 'Size of the super individual of the cohort (mm)' color: '0000FF'>
    
    | cohorts |
    cohorts := (self @@ PannCohort).
    ^ cohorts first shellfishSize."
]

{ #category : 'init 30x30 cells grid' }
EcoPannModel >> stateMatrixOf30x30CellsGrid [
    "Returns a sample map : 0 = sea, 1 = village, 2 = mudflat, 3 = mangrove."

    ^ #(
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 2 2 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 2 2 2 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 2 2 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 2 2 0 0 0 0 0 0 0 3 3 3 3 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 2 2 2 0 0 0 0 3 3 3 3 3 3 3 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 1 2 2 2 0 0 0 0 0 0 3 3 3 3 3 3 3)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 0 0 0 0 0 0 0 3 3 3)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 0 0 0 0 0 3 3 3 3 3)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 3)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 2 2 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 2 2 2 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 0 0 0 2 2 2 0 0 3)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 0 0 0 0 0 3 3)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3)
    )
]

{ #category : 'init 70x70 cells grid' }
EcoPannModel >> stateMatrixOf70x70CellsGrid [
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
	(0 0 0 0 0 0 0 0 0 2 2 2 2 2 2 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3)
	(0 0 0 0 0 0 0 0 0 2 2 2 2 2 2 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 2 2 2 2 2 2 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 2 2 2 2 2 2 2 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 2 2 2 2 2 2 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 2 2 2 2 2 2 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 2 2 2 2 2 2 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3)
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
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 2 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 0 0 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 2 2 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 0 0 0 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 2 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 0 3 0 0 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 0 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 0 0 3 3 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 0 0 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 0 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 0 0 0 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 0 3 3 3 3 3 0 0 0)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 0 0 3 3 3 3 3 3 3 3 3 3 0 3 3 0 0 0 0 0 0)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 3 3 3 3 3 3 3 3 3 3 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 0 0 0 0 0 0 0 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 2 2 2 2 2 2 0 0 0 0 3 3 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 2 2 2 2 2 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 2 2 2 2 2 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 2 2 2 2 2 2 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 2 2 2 2 2 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 2 2 2 2 2 2 0 0 0 0 0 0 0 0 0 0 0 0 2 2 2 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 2 2 2 2 2 2 0 0 0 0 0 0 0 0 0 0 0 0 2 2 2 2 0 0 0 0 0 3 3 3 3 3 3 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 2 2 0 0 0 0 0 0 3 0 0 3 3 3 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 0 0 3 0 3 3 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 0 3 0 0 0 0 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 0 0 3 3 0 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 0 3 0 0)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 0 3 3 3 3 3 3 3 3 3 3 3 3 3 0 3 0 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 0 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 0 0 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 0 0 0 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 0 2 2 2 2 2 2 2 0 0 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 0 0 0 0 2 2 2 2 2 2 2 0 0 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 2 2 2 2 2 2 0 0 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 2 2 2 2 2 2 2 0 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 2 2 2 2 2 2 0 0 3 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 2 2 2 2 2 2 0 0 0 3 3 3 3 3)
	(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 2 2 2 2 2 2 0 0 0 0 3 3 3 3)
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

{ #category : 'init single cell grid' }
EcoPannModel >> stateMatrixOfSingleCellGrid [
    "Returns a sample map : 0 = sea, 1 = village, 2 = mudflat, 3 = mangrove."

    ^ #(
		(2)
    )
]

{ #category : 'init single cell with village grid' }
EcoPannModel >> stateMatrixOfSingleCellWithVillageGrid [
    "Returns a sample map : 0 = sea, 1 = village, 2 = mudflat, 3 = mangrove."

    ^ #(
		(2 1)
    )
]

{ #category : 'init single sare grid' }
EcoPannModel >> stateMatrixOfSingleSareGrid [
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
EcoPannModel >> step [
	"one simulation day"
	
	<control>
	
	self updateDate.

	self @@ EcoPannShellfishCohort do: [:s | 
		s aging.
		s growSize.
		s growBiomass.
		s naturalDeath.
		 ].
	
	self @@ EcoPannShellfishPopulation do: [:s | 
		s recruit.
		s cohortDeath.
		s actualizeCohortsCounter.
		].
	
	(self shuffled: (self @@ EcoPannFisher)) do: [ :s |
		s fish.
		].
	
"	(self isFishingPeriod and: [ self isMbissa ]) ifTrue: [ 
		(self shuffled: (self @@ EcoPannFisher))
			do: #goToFishingSpot;
			do: #fish.
		] ifFalse: [
		(self shuffled: (self @@ EcoPannFisher))
			do: #goToVillage.
		]."
	
]

{ #category : 'time   ' }
EcoPannModel >> updateDate [
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
