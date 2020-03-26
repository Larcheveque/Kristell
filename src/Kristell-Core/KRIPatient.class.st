Class {
	#name : #KRIPatient,
	#superclass : #Object,
	#instVars : [
		'metrics',
		'name'
	],
	#category : #'Kristell-Core'
}

{ #category : #accessing }
KRIPatient >> createMetricsFromHeader: anHeaderArray [
	"the first is nil because of patient name"

	| time unit metricName |
	time := ('T0' asParser / ($M asParser , #digit asParser plus))
		flatten.
	unit := ($( asParser , $) asParser negate plus flatten , $) asParser)
		==> [ :res | res second trim ].
	metricName := (time , #space asParser , unit) negate plus flatten.
	anHeaderArray
		allButFirstDo: [ :aMetric | 
			self metrics
				add:
					((metricName , time trim , unit) end
						==> [ :data | 
							KRIMetric new
								name: data first trim;
								unit: data third trim;
								yourself ] parse: aMetric) ]
]

{ #category : #accessing }
KRIPatient >> initialize [
	self metrics: OrderedCollection new
]

{ #category : #finding }
KRIPatient >> metricCorrespondingTo: aKRIMetricDescription [
	^ self metrics
		detect: [ :aMetric | aMetric name = aKRIMetricDescription name ]
]

{ #category : #accessing }
KRIPatient >> metrics [
	^ metrics
]

{ #category : #accessing }
KRIPatient >> metrics: anObject [
	metrics := anObject
]

{ #category : #accessing }
KRIPatient >> name [
	^ name
]

{ #category : #accessing }
KRIPatient >> name: anObject [
	name := anObject
]
