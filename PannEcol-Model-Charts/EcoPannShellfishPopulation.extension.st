Extension { #name : 'EcoPannShellfishPopulation' }

{ #category : '*PannEcol-Model-Charts' }
EcoPannShellfishPopulation >> buildChart [

	| sortedCohorts |

	sortedCohorts := cohorts asSortedCollection:
		[:a :b | a shellfishSize < b shellfishSize ].

	^ self
		buildChartX: (sortedCohorts collect: [:c | c shellfishSize])
		y: (sortedCohorts collect: [:c | c shellfishDensity]).
]

{ #category : '*PannEcol-Model-Charts' }
EcoPannShellfishPopulation >> buildChartX: xCollection y: yCollection [
	
	| chart plot |
	
	xCollection ifEmpty: [ ^ RSCompositeChart new ].
	
	chart := RSCompositeChart new.
			
	plot := RSBarPlot new x: xCollection y: yCollection.
	plot color: CMColor olympic.
	plot barSize: 10.
	chart add: plot.

	chart build.
	plot bars @ RSPopup.
	
	^ chart
]

{ #category : '*PannEcol-Model-Charts' }
EcoPannShellfishPopulation >> inspectorCharts: aBuilder [

	<inspectorPresentationOrder: 10 title: 'Charts'>
	
	^ (aBuilder instantiate: SpRoassalInspectorPresenter)
		canvas: self buildChart canvas;
		yourself
]
