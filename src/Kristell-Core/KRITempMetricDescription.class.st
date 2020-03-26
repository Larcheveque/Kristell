Class {
	#name : #KRITempMetricDescription,
	#superclass : #Object,
	#instVars : [
		'name',
		'unit',
		'time'
	],
	#category : #'Kristell-Core'
}

{ #category : #accessing }
KRITempMetricDescription >> name [
	^ name
]

{ #category : #accessing }
KRITempMetricDescription >> name: anObject [
	name := anObject
]

{ #category : #testing }
KRITempMetricDescription >> shouldBeIgnored [
	^ false
]

{ #category : #accessing }
KRITempMetricDescription >> time [
	^ time
]

{ #category : #accessing }
KRITempMetricDescription >> time: anObject [
	time := anObject
]

{ #category : #accessing }
KRITempMetricDescription >> unit [
	^ unit
]

{ #category : #accessing }
KRITempMetricDescription >> unit: anObject [
	unit := anObject
]
