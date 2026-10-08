Class {
	#name : 'EcoPannSare',
	#superclass : 'CMSpatialEntityAggregate',
	#instVars : [
		'name',
		'recruitCapacity',
		'naturalDeathRate',
		'growthRate',
		'maxShellfishLength',
		'numberOfShellfishesHistory',
		'closed',
		'closureStartDay'
	],
	#category : 'PannEcol-Model',
	#package : 'PannEcol-Model'
}

{ #category : 'charts ' }
EcoPannSare >> buildStockOverTimeChartPlotX: xCollection y: yCollection [
	| x y chart plot |
	
	x := xCollection ifEmpty: [ #(0) ].
	y := yCollection ifEmpty: [ #(0) ].

	chart := RSCompositeChart new.

	plot := RSLinePlot new x: x y: y.
	plot color: CMColor gold.
	plot width: 1.5.
	chart add: plot.

	chart title: 'Évolution du stock de coquillages'.
	chart xlabel: 'Step'.
	chart ylabel: 'Stock (nombre de individus)'.

   ^ chart

]

{ #category : 'closure' }
EcoPannSare >> close [
    closed := true.
    closureStartDay := self cormasModel dayCounter.
]

{ #category : 'accessing' }
EcoPannSare >> growthRate [

	^ growthRate
]

{ #category : 'accessing' }
EcoPannSare >> growthRate: anObject [

	growthRate := anObject
]

{ #category : 'init' }
EcoPannSare >> initialize [ 

	super initialize. 
	
"defining values that will be overwriten"
	name := 'not named'.
	recruitCapacity := 0.
	naturalDeathRate := 0.
	growthRate := 0.
	maxShellfishLength := 0.
	numberOfShellfishesHistory := OrderedCollection new.
	closed := false.
   closureStartDay := 0.
]

{ #category : 'closure' }
EcoPannSare >> isClosed [
    ^ closed
]

{ #category : 'accessing' }
EcoPannSare >> maxShellfishLength [

	^ maxShellfishLength
]

{ #category : 'accessing' }
EcoPannSare >> maxShellfishLength: anObject [

	maxShellfishLength := anObject
]

{ #category : 'accessing' }
EcoPannSare >> name [

	^ name
]

{ #category : 'accessing' }
EcoPannSare >> name: anObject [

	name := anObject
]

{ #category : 'accessing' }
EcoPannSare >> naturalDeathRate [

	^ naturalDeathRate
]

{ #category : 'accessing' }
EcoPannSare >> naturalDeathRate: anObject [

	naturalDeathRate := anObject
]

{ #category : 'accessing' }
EcoPannSare >> numberOfShellfishes [ 

	^ self plots sum: [ : plot | plot numberOfShellfishes ].
]

{ #category : 'closure' }
EcoPannSare >> open [
    closed := false.
    closureStartDay := 0.
]

{ #category : 'accessing' }
EcoPannSare >> plots [ 

	^ self components.
]

{ #category : 'accessing' }
EcoPannSare >> populations [

	| populations |
	populations := self plots collect: #shellfishPopulation.
	
	^ populations.
]

{ #category : 'accessing' }
EcoPannSare >> recruitCapacity [

	^ recruitCapacity
]

{ #category : 'accessing' }
EcoPannSare >> recruitCapacity: anObject [

	recruitCapacity := anObject
]

{ #category : 'charts ' }
EcoPannSare >> showCharts [
	
    | chart |

	chart := self
		buildStockOverTimeChartPlotX: ((1 to: numberOfShellfishesHistory size ) asArray)
		y: (numberOfShellfishesHistory asArray).
		
	chart build.
	chart canvas openWithTitle: self asString
]

{ #category : 'step     ' }
EcoPannSare >> step [

	numberOfShellfishesHistory add: self numberOfShellfishes.
]

{ #category : 'closure' }
EcoPannSare >> updateClosure [
    closed
        ifTrue: [
            self cormasModel dayCounter
                >= closureStartDay + self cormasModel closureDuration
                    ifTrue: [ self open ] ].
]
