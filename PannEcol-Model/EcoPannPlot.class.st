Class {
	#name : 'EcoPannPlot',
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
EcoPannPlot >> area [

	^ area
]

{ #category : 'accessing' }
EcoPannPlot >> area: anObject [

	area := anObject
]

{ #category : 'accessing' }
EcoPannPlot >> beMangrove [

	state := #mangrove
]

{ #category : 'accessing' }
EcoPannPlot >> beMudflat [

	state := #mudflat
]

{ #category : 'accessing' }
EcoPannPlot >> beSea [

	state := #sea
]

{ #category : 'accessing' }
EcoPannPlot >> beVillage [

	state := #village
]

{ #category : 'save data' }
EcoPannPlot >> collectData [
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
        put: (self occupantsOfClass: EcoPannFisher) size.

    data add: record.
]

{ #category : 'accessing' }
EcoPannPlot >> initialize [ 

	super initialize.
	area := 5000. "m²" "just to avoid problems, but will be overwriten by the grid init method using the accessor area:"
   data := OrderedCollection new.
]

{ #category : 'accessing' }
EcoPannPlot >> isMangrove [

	^ state = #mangrove
]

{ #category : 'accessing' }
EcoPannPlot >> isMudflat [

	^ state = #mudflat
]

{ #category : 'accessing' }
EcoPannPlot >> isSea [

	^ state = #sea
]

{ #category : 'accessing' }
EcoPannPlot >> isVillage [

	^ state = #village
]

{ #category : 'accessing' }
EcoPannPlot >> numberOfShellfishes [ 

	^ self shellfishPopulation numberOfShellfishes.
]

{ #category : 'accessing' }
EcoPannPlot >> pov [ 

	<pov>
	
	state = #sea ifTrue: [ ^ CMPointOfView color: '70EAFF' ].
	state = #village ifTrue: [ ^ CMPointOfView color: '8F1437' ].
	state = #mudflat ifTrue: [ ^ CMPointOfView color: 'FFFCB3' ].
	state = #mangrove ifTrue: [ ^ CMPointOfView color: '0DB370' ].
	
	^ super pov. "if no state, super pov by default"
]

{ #category : 'accessing' }
EcoPannPlot >> sare [
    "Return a sare to which this plot belongs"
    ^ self getAggregateType: EcoPannSare
]

{ #category : 'save data' }
EcoPannPlot >> saveDataToCsv: aFileReference [
    | columnNames |
    data ifEmpty: [ self error: 'Data is empty!' ].
    
    "Data is a collection of dictionaries. Each dictionary represents a row and the keys of each dictionary are column names. So we take the first dictionary, ask for its keys, and those are the column names for our CSV file"
    columnNames := data first keys.

    aFileReference writeStreamDo: [ :stream |
        stream nextPutAll: (',' join: columnNames); cr.
        data do: [ :row | stream nextPutAll: (',' join: row); cr ] ]
]

{ #category : 'accessing' }
EcoPannPlot >> shellfishPopulation [
	"this method returns you the shellfish population in the cell "

	^ (self occupantsOfClass: EcoPannShellfishPopulation) first. "there can only be 1 population of shellfish on the cell, not more, not 0"
		
]

{ #category : 'accessing' }
EcoPannPlot >> state [

	^ state
]

{ #category : 'accessing' }
EcoPannPlot >> state: anObject [

	state := anObject
]
