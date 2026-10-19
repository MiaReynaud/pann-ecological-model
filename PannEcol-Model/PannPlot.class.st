Class {
	#name : 'PannPlot',
	#superclass : 'CMCell',
	#instVars : [
		'state',
		'area',
		'data'
	],
	#category : 'PannEcol-Model',
	#package : 'PannEcol-Model'
}

{ #category : 'accessing' }
PannPlot >> area [

	^ area
]

{ #category : 'accessing' }
PannPlot >> area: anObject [

	area := anObject
]

{ #category : 'state' }
PannPlot >> beMangrove [

	state := #mangrove
]

{ #category : 'state' }
PannPlot >> beMudflat [

	state := #mudflat
]

{ #category : 'state' }
PannPlot >> beSea [

	state := #sea
]

{ #category : 'state' }
PannPlot >> beVillage [

	state := #village
]

{ #category : 'save data' }
PannPlot >> collectData [
    | record sortedCohorts numbersAsWords |
    "Each record represents a row in a data table. It is a dictionary where key is a column name and value is the value (measurement) for that column. Using an OrderedDictionary ensures that columns are in the same order as we add them"
    record := OrderedDictionary new.

    record at: 'Sare name' put: self sare name.
    record at: 'Actual month' put: cormasModel currentMonth.
    record at: 'Actual day of the month' put: cormasModel currentDayOfMonth.
    
    "We use sorted and not sort to make sure that we get a copy and don't change the original cohorts collection"
    "sortedCohorts := self shellfishPopulation cohorts
        sorted: [ :a :b | a shellfishSize < b shellfishSize ].

    ""You want words - I give you words :)""
    numbersAsWords := #(first second third fourth fifth sixth seventh).

    (1 to: 7) do: [ :i |
        | cohort word |
        cohort := sortedCohorts at: i.
        word := numbersAsWords at: i.

        record
            at: ('Shellfish density of ', word, ' smallest cohort')
            put: cohort shellfishDensity ]."

     record
        at: 'Number of shellfish in population'
        put: self shellfishPopulation numberOfShellfishes.

    record
        at: 'Number of fishers on the cell'
        put: (self occupantsOfClass: PannFisher) size.

    data add: record.
]

{ #category : 'init' }
PannPlot >> initialize [ 

	super initialize.
	area := 5000. "m²" "just to avoid problems, but will be overwriten by the grid init method using the accessor area:"
   data := OrderedCollection new.
]

{ #category : 'state' }
PannPlot >> isMangrove [

	^ state = #mangrove
]

{ #category : 'state' }
PannPlot >> isMudflat [

	^ state = #mudflat
]

{ #category : 'state' }
PannPlot >> isSea [

	^ state = #sea
]

{ #category : 'state' }
PannPlot >> isVillage [

	^ state = #village
]

{ #category : 'accessing' }
PannPlot >> numberOfShellfishes [ 

	^ self shellfishPopulation numberOfShellfishes.
]

{ #category : 'pov' }
PannPlot >> pov [ 

	<pov>
	
	state = #sea ifTrue: [ ^ CMPointOfView color: '70EAFF' ].
	state = #village ifTrue: [ ^ CMPointOfView color: '8F1437' ].
	state = #mudflat ifTrue: [ ^ CMPointOfView color: 'FFFCB3' ].
	state = #mangrove ifTrue: [ ^ CMPointOfView color: '0DB370' ].
	
	^ super pov. "if no state, super pov by default"
]

{ #category : 'accessing' }
PannPlot >> sare [
    "Return a sare to which this plot belongs"
    ^ self getAggregateType: PannSare
]

{ #category : 'save data' }
PannPlot >> saveDataToCsv: aFileReference [
    | columnNames |
    data ifEmpty: [ self error: 'Data is empty!' ].
    
    "Data is a collection of dictionaries. Each dictionary represents a row and the keys of each dictionary are column names. So we take the first dictionary, ask for its keys, and those are the column names for our CSV file"
    columnNames := data first keys.

    aFileReference writeStreamDo: [ :stream |
        stream nextPutAll: (',' join: columnNames); cr.
        data do: [ :row | stream nextPutAll: (',' join: row); cr ] ]
]

{ #category : 'accessing' }
PannPlot >> shellfishPopulation [
	"this method returns you the shellfish population in the cell "

	^ (self occupantsOfClass: PannShellfishPopulation) first. "there can only be 1 population of shellfish on the cell, not more, not 0"
		
]

{ #category : 'as yet unclassified' }
PannPlot >> showSareCharts [
	<action>
	
	self sare ifNotNil: [ :sare | sare showCharts ]
]

{ #category : 'accessing' }
PannPlot >> state [

	^ state
]

{ #category : 'accessing' }
PannPlot >> state: anObject [

	state := anObject
]
