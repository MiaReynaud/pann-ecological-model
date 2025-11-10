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
EcoPannModel >> applyStatesFromMatrix: aMatrix [

	| rows cols value cell |
    rows := aMatrix size.
    cols := (aMatrix first) size.

    1 to: rows do: [ :i |
        1 to: cols do: [ :j |
            cell := self cellAt: i at: j.
            value := (aMatrix at: i) at: j.
        
           
				value = 2 ifTrue: [ cell beMudflat ] ] ].
]

{ #category : 'init  ' }
EcoPannModel >> buildSare1 [
	
	self releaseAggregateType: EcoPannSare .
	self
		createAggregates: EcoPannSare 
		from: EcoPannPlot
		verifying: [ :aCell | aCell isMudflat ]
		minimumSize: 1.
		
	(self @@ EcoPannSare) do: [ :agg | "self spaceModel meanCompactness: PannSare"
		agg initNeighbourhood ].
	
	self initialiseSareAttributes1.
	
]

{ #category : 'accessing' }
EcoPannModel >> currentDayOfMonth [

	^ currentDayOfMonth
]

{ #category : 'accessing' }
EcoPannModel >> currentDayOfMonth: anObject [

	currentDayOfMonth := anObject
]

{ #category : 'accessing' }
EcoPannModel >> currentMonth [

	^ currentMonth
]

{ #category : 'accessing' }
EcoPannModel >> currentMonth: anObject [

	currentMonth := anObject
]

{ #category : 'accessing' }
EcoPannModel >> dayCounter [

	^ dayCounter
]

{ #category : 'accessing' }
EcoPannModel >> dayCounter: anObject [

	dayCounter := anObject
]

{ #category : 'init  ' }
EcoPannModel >> initMatrix1 [
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
		
	self cells do: [ : each | each area: 1]. "define the size of a cell in m²"
		
 	self applyStatesFromMatrix: self stateMatrix1.
	
	"add shellfish on every mudflat cell"
	(self cells select: [ :c | c state = #mudflat ]) do: [ :cell |
		self newEntity: EcoPannShellfishPopulation locatedAt: cell ].
	
		self buildSare1. 

]

{ #category : 'init  ' }
EcoPannModel >> initialiseSareAttributes1 [

	| sare |
	
	sare := ( self @@ EcoPannSare ) detect: [ :each | each id = 1]. 
	sare name: 'amacala 1'.
	sare recruitCapacity: 200. "20 000 1cm shellfishes are recruited every year, so 109 every two days "
	sare naturalDeathRate: 0.00219.
]

{ #category : 'time   ' }
EcoPannModel >> isRecruitDay [

	^ (currentDayOfMonth = 1)  and: (currentMonth = 12)
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

{ #category : 'init  ' }
EcoPannModel >> stateMatrix1 [
    "Returns a sample map : 0 = sea, 1 = village, 2 = mudflat, 3 = mangrove."

    ^ #(
		(2)
    )
]

{ #category : 'step  ' }
EcoPannModel >> step [
	"one simulation day"
	
	<control>
	
	self updateDate.

	self @@ EcoPannShellfishCohort do: [:s | 
		s aging.
		s grow.
		s death.
		 ].
	
	self @@ EcoPannShellfishPopulation do: [:s | 
		s recruit.
		s cohortDeath.
		s actualizeCohortsCounter.
		 ].
	
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
