Class {
	#name : 'PannSare',
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
PannSare >> buildStockOverTimeChartPlotX: xCollection y: yCollection [
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
PannSare >> closeAtDay: aDay [
    closed := true.
    closureStartDay := aDay
]

{ #category : 'closure' }
PannSare >> closed: anObject [

	closed := anObject
]

{ #category : 'closure' }
PannSare >> closureStartDay [

	^ closureStartDay
]

{ #category : 'accessing' }
PannSare >> growthRate [

	^ growthRate
]

{ #category : 'accessing' }
PannSare >> growthRate: anObject [

	growthRate := anObject
]

{ #category : 'init' }
PannSare >> initialize [ 

	super initialize. 
	
"defining values that will be overwriten"
	name := 'not named'.
	recruitCapacity := 0.
	naturalDeathRate := 0.
	growthRate := 0.
	maxShellfishLength := 0.
	numberOfShellfishesHistory := OrderedCollection new.
	
	"managment init"
	closed := false.
   closureStartDay := 0
]

{ #category : 'closure' }
PannSare >> isClosed [
    ^ closed
]

{ #category : 'accessing' }
PannSare >> maxShellfishLength [

	^ maxShellfishLength
]

{ #category : 'accessing' }
PannSare >> maxShellfishLength: anObject [

	maxShellfishLength := anObject
]

{ #category : 'accessing' }
PannSare >> name [

	^ name
]

{ #category : 'accessing' }
PannSare >> name: anObject [

	name := anObject
]

{ #category : 'accessing' }
PannSare >> naturalDeathRate [

	^ naturalDeathRate
]

{ #category : 'accessing' }
PannSare >> naturalDeathRate: anObject [

	naturalDeathRate := anObject
]

{ #category : 'accessing' }
PannSare >> numberOfShellfishes [ 

	^ self plots sum: [ : plot | plot numberOfShellfishes ].
]

{ #category : 'closure' }
PannSare >> open [
    closed := false.
    closureStartDay := 0.
]

{ #category : 'accessing' }
PannSare >> plots [ 

	^ self components.
]

{ #category : 'accessing' }
PannSare >> populations [

	| populations |
	populations := self plots collect: #shellfishPopulation.
	
	^ populations.
]

{ #category : 'accessing' }
PannSare >> recruitCapacity [

	^ recruitCapacity
]

{ #category : 'accessing' }
PannSare >> recruitCapacity: anObject [

	recruitCapacity := anObject
]

{ #category : 'charts ' }
PannSare >> showCharts [
	
    | chart |

	chart := self
		buildStockOverTimeChartPlotX: ((1 to: numberOfShellfishesHistory size ) asArray)
		y: (numberOfShellfishesHistory asArray).
		
	chart build.
	chart canvas openWithTitle: self asString
]

{ #category : 'step     ' }
PannSare >> step [

	numberOfShellfishesHistory add: self numberOfShellfishes.
]
