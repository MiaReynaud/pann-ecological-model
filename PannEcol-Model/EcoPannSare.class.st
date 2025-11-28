Class {
	#name : 'EcoPannSare',
	#superclass : 'CMSpatialEntityAggregate',
	#instVars : [
		'name',
		'recruitCapacity',
		'naturalDeathRate',
		'growthRate',
		'maxShellfishLength',
		'numberOfShellfishesHistory'
	],
	#category : 'PannEcol-Model',
	#package : 'PannEcol-Model'
}

{ #category : 'charts ' }
EcoPannSare >> buildStockOverTimeChart [
	
    ^ self
		buildChartBoxPlotX: ((1 to: numberOfShellfishesHistory size ) asArray)
		y: (numberOfShellfishesHistory asArray).
]

{ #category : 'charts ' }
EcoPannSare >> buildStockOverTimeChartPlotX: xCollection y: yCollection [

    | chart plot |

    xCollection ifEmpty: [ ^ RSCompositeChart new ].

    chart := RSCompositeChart new.

    plot := RSLinePlot new
        x: xCollection
        y: yCollection.

    plot color: CMColor black.

    chart add: plot.

    chart title: 'Évolution du stock de coquillages'.
    chart xlabel: 'Step'.
    chart ylabel: 'Stock (nombre de individus)'.

    chart build.


    plot points @ RSPopup.

    ^ chart

]

{ #category : 'accessing' }
EcoPannSare >> growthRate [

	^ growthRate
]

{ #category : 'accessing' }
EcoPannSare >> growthRate: anObject [

	growthRate := anObject
]

{ #category : 'accessing' }
EcoPannSare >> initialize [ 

	super initialize. 
	
"defining values that will be overwriten"
	name := 'not named'.
	recruitCapacity := 0.
	naturalDeathRate := 0.
	growthRate := 0.
	maxShellfishLength := 0.
	numberOfShellfishesHistory := OrderedCollection new.
]

{ #category : 'charts ' }
EcoPannSare >> inspectorCharts: aBuilder [

	<inspectorPresentationOrder: 10 title: 'Charts'>
	
	^ (aBuilder instantiate: SpRoassalInspectorPresenter)
		canvas: self buildStockOverTimeChart canvas;
		yourself
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

{ #category : 'step     ' }
EcoPannSare >> step [

	numberOfShellfishesHistory add: self numberOfShellfishes.
]
