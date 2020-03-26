Class {
	#name : #KRICohort,
	#superclass : #Object,
	#instVars : [
		'patients',
		'metrics'
	],
	#category : #'Kristell-Core'
}

{ #category : #'as yet unclassified' }
KRICohort class >> generateCohort [
	<script>
	| cohort |
	cohort := KRICohort new.
	cohort numberOfPatients: 13.
	cohort
		injectDatafrom:
			'/Users/larcheveque/Downloads/recueil de données - T0M3.csv'
				asFileReference.
	cohort
		injectDatafrom:
			'/Users/larcheveque/Downloads/recueil de données - T0M6.csv'
				asFileReference.
	cohort
		injectDatafrom:
			'/Users/larcheveque/Downloads/recueil de données - T0M12.csv'
				asFileReference.
	cohort
		injectMixedDatafrom:
			'/Users/larcheveque/Downloads/recueil de données - T0Récentes.csv'
				asFileReference.
	cohort
		exportAsCSVIn: '/Users/larcheveque/Downloads/RecueilDonnees.csv' asFileReference.
	cohort inspect.
	^ cohort
]

{ #category : #accessing }
KRICohort >> checkMetricsFromHeader: anHeaderArray [
	"the first is nil because of patient name"

	"this method willl return the time for this document"

	| time unit metricName timeDetected |
	time := ('T0' asParser / ($M asParser , #digit asParser plus))
		flatten.
	unit := ($( asParser , $) asParser negate plus flatten , $) asParser)
		==> [ :res | res second trim ].
	metricName := (time , (#space asParser , unit) optional) negate plus
		flatten.
	timeDetected := nil.
	anHeaderArray allButFirst
		doWithIndex: [ :aMetric :index | 
			((metricName , time trim , unit optional)
				==> [ :data | 
					self assert: (self metrics at: index) name = data first trim.
					data second trim = 'T0'
						ifFalse: [ timeDetected
								ifNil: [ timeDetected := data second trim ]
								ifNotNil: [ self assert: timeDetected = data second trim ] ].
					self
						assert: (self metrics at: index) unit = data third;
						yourself ]) parse: aMetric ].
	^ timeDetected
]

{ #category : #creation }
KRICohort >> createMetricsForPatients [
	self patients
		do: [ :patient | 
			patient
				metrics: (self metrics select: #isT0 thenCollect: #copyAsPatientMetric) ]
]

{ #category : #accessing }
KRICohort >> createMetricsFromHeader: anHeaderArray [
	"the first is nil because of patient name"

	"this method willl return the time for this document"

	| time unit metricName timeDetected |
	time := ('T0' asParser / ($M asParser , #digit asParser plus))
		flatten.
	unit := ($( asParser , $) asParser negate plus flatten , $) asParser)
		==> [ :res | res second trim ].
	metricName := (time , (#space asParser , unit) optional) negate plus
		flatten.
	anHeaderArray
		allButFirstDo: [ :aMetric | 
			self metrics
				add:
					((metricName , time trim , unit optional)
						==> [ :data | 
							data second trim = 'T0'
								ifFalse: [ timeDetected
										ifNil: [ timeDetected := data second trim ]
										ifNotNil: [ self assert: timeDetected = data second trim ] ].
							KRIMetricDescription new
								name: data first trim;
								unit: data third;
								isT0: data second trim = 'T0';
								yourself ] parse: aMetric) ].
	self createMetricsForPatients.
	^ timeDetected
]

{ #category : #export }
KRICohort >> exportAsCSVIn: aFileReference [
	| times writer |
	times := #(T0 M3 M6 M12 récent).
	aFileReference
		writeStreamDo: [ :writeStream | 
			writer := NeoCSVWriter on: writeStream.
			writer
				writeHeader:
					#('Reference')
						,
							(self patients anyOne metrics
								flatCollect: [ :metric | 
									times
										collect: [ :t | 
											metric name , ' ' , t , ' ('
												, (metric unit ifNil: [ 'UNIT NOT DEFINED' ] ifNotNil: [metric unit]) , ')' ] ]).
			self patients
				do: [ :patient | 
					writer
						writeFieldsUsingDo:
							{patient name}
								,
									(patient metrics
										flatCollect: [ :m | times collect: [ :t | m valueByTime at: t ] ]).
					writer writeEndOfLine ] ]
]

{ #category : #accessing }
KRICohort >> initialize [
	self patients: OrderedCollection new.
	self metrics: OrderedCollection new
]

{ #category : #accessing }
KRICohort >> injectDatafrom: fileReference [
	| reader time index |
	reader := NeoCSVReader on: fileReference readStream.
	time := self metrics
		ifEmpty: [ self createMetricsFromHeader: reader readHeader ]
		ifNotEmpty: [ self checkMetricsFromHeader: reader readHeader ].
	index := 1.
	[ reader atEnd ]
		whileFalse: [ | records patient |
			records := reader readNextRecordAsArray.
			patient := self patients at: index.
			index := index + 1.
			records allButFirst
				doWithIndex: [ :data :metricIndex | 
					| metric |
					metric := self metrics at: metricIndex.
					(patient metricCorrespondingTo: metric)
						defineValue: data
						forTime:
							(metric isT0
								ifTrue: 'T0'
								ifFalse: time) ] ]
]

{ #category : #accessing }
KRICohort >> injectMixedDatafrom: fileReference [
	| reader index tempMetrics |
	reader := NeoCSVReader on: fileReference readStream.
	tempMetrics := self obtainTempMetricsFromHeader: reader readHeader.
	index := 1.
	[ reader atEnd ]
		whileFalse: [ | records patient |
			records := reader readNextRecordAsArray.
			patient := self patients at: index.
			index := index + 1.
			records allButFirst
				doWithIndex: [ :data :metricIndex | 
					| metric |
					metric := tempMetrics at: metricIndex.
					metric shouldBeIgnored
						ifFalse: [ (patient metricCorrespondingTo: metric)
								defineValue: data
								forTime: metric time ] ] ]
]

{ #category : #accessing }
KRICohort >> metrics [
	^ metrics
]

{ #category : #accessing }
KRICohort >> metrics: anObject [
	metrics := anObject
]

{ #category : #creation }
KRICohort >> numberOfPatients: anInteger [
	1 to: anInteger do: [ :i | 
		self patients
			addLast:
				(KRIPatient new
					name: 'Patient ' , i asString;
					yourself) ]
]

{ #category : #header }
KRICohort >> obtainTempMetricsFromHeader: anHeaderArray [
	| time unit metricName tempMetrics |
	tempMetrics := OrderedCollection new.
	time := ('T0' asParser / 'récent' asParser / ($M asParser , #digit asParser plus))
		flatten.
	unit := ($( asParser , $) asParser negate plus flatten , $) asParser)
		==> [ :res | res second trim ].
	metricName := (time , (#space asParser , unit) optional) negate plus
		flatten.
	anHeaderArray
		allButFirstDo: [ :aMetric | 
			aMetric
				ifNil: [ tempMetrics add: KRIEmptyColumn new ]
				ifNotNil: [ tempMetrics
						add:
							((metricName , time trim , unit optional)
								==> [ :data | 
									KRITempMetricDescription new
										name: data first trim;
										unit: data third;
										time: data second trim;
										yourself ] parse: aMetric) ] ].
	^ tempMetrics
]

{ #category : #accessing }
KRICohort >> patients [
	^ patients
]

{ #category : #accessing }
KRICohort >> patients: anObject [
	patients := anObject
]
