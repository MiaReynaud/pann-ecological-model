Class {
	#name : 'EcoPannPopulationChartsPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'data',
		'populationsList',
		'chart'
	],
	#category : 'PannEcol-Model',
	#package : 'PannEcol-Model'
}

{ #category : 'examples' }
EcoPannPopulationChartsPresenter class >> example [

	self new open
]

{ #category : 'layout' }
EcoPannPopulationChartsPresenter >> defaultLayout [

	^ SpBoxLayout newLeftToRight
		add: populationsList width: 100;
		add: chart;
		yourself.
]

{ #category : 'public' }
EcoPannPopulationChartsPresenter >> drawChart [

	| chartBuilder size x |
	
	chartBuilder := CMR3ChartBuilder new
		plotWidth: 0.5;
		yourself.
		
	"data
		ifEmpty: [ chartBuilder addPlotX: { 0 } y: { 0 } color: Color black ]
		ifNotEmpty: [
			size := data size / numberOfRepetitions.
			
			x := data
				select: [ :row | (row at: 'Repetition') = 1 ]
				thenCollect: [ :row | row at: 'Parameter value' ].
				
			chartBuilder maxChartValueX: x max.
	
			measurementNames do: [ :each |
				self
					drawChartForMeasurementNamed: each
					chartBuilder: chartBuilder
					x: x ] ]."
	chartBuilder addPlotX: #(1 2 3) y: #(3 2 1) color: Color red.

	chartBuilder chart build.
	chart canvas: chartBuilder chart container.
]

{ #category : 'examples' }
EcoPannPopulationChartsPresenter >> example [
	<script: 'self example'>
]

{ #category : 'initialization' }
EcoPannPopulationChartsPresenter >> initializePresenters [
	
	chart := SpRoassalInspectorPresenter new.
	
	populationsList := self newTable
		hideColumnHeaders;
		addColumn: (SpStringTableColumn
			evaluated: [ :population | 'Population ', population id asString ])
		yourself.
	
	self drawChart
]
