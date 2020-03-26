Class {
	#name : #KRIMetricDescription,
	#superclass : #Object,
	#instVars : [
		'name',
		'unit',
		'isT0'
	],
	#category : #'Kristell-Core'
}

{ #category : #creation }
KRIMetricDescription >> copyAsPatientMetric [
	^ KRIMetric new
		name: self name;
		unit: self unit;
		yourself
]

{ #category : #accessing }
KRIMetricDescription >> isT0 [
	^ isT0
]

{ #category : #accessing }
KRIMetricDescription >> isT0: anObject [
	isT0 := anObject
]

{ #category : #accessing }
KRIMetricDescription >> name [
	^ name
]

{ #category : #accessing }
KRIMetricDescription >> name: anObject [
	name := anObject
]

{ #category : #printing }
KRIMetricDescription >> printOn: s [
	super printOn: s.
	s space.
	s << name.
	s space.
	unit ifNil: [ s << 'NO DEFINED UNIT' ] ifNotNil: [ s << unit ]
]

{ #category : #accessing }
KRIMetricDescription >> unit [
	^ unit
]

{ #category : #accessing }
KRIMetricDescription >> unit: anObject [
	unit := anObject
]
