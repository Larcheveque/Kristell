Class {
	#name : #KRIMetric,
	#superclass : #Object,
	#instVars : [
		'name',
		'unit',
		'valueByTime'
	],
	#category : #'Kristell-Core'
}

{ #category : #definition }
KRIMetric >> defineValue: aStringValue forTime: aTime [
	self valueByTime
		at: aTime
		ifPresent: [ :data | 
			data
				ifNotNil: [ self assert: data = aStringValue ]
				ifNil: [ self valueByTime at: aTime put: aStringValue ] ]
		ifAbsentPut: [ aStringValue ]
]

{ #category : #accessing }
KRIMetric >> initialize [
	self valueByTime: Dictionary new
]

{ #category : #accessing }
KRIMetric >> name [
	^ name
]

{ #category : #accessing }
KRIMetric >> name: anObject [
	name := anObject
]

{ #category : #printing }
KRIMetric >> printOn: s [
	super printOn: s.
	s space.
	s << name.
	s space.
	unit ifNil: [ s << 'NO DEFINED UNIT' ] ifNotNil: [ s << unit ]
]

{ #category : #accessing }
KRIMetric >> unit [
	^ unit
]

{ #category : #accessing }
KRIMetric >> unit: anObject [
	unit := anObject
]

{ #category : #accessing }
KRIMetric >> valueByTime [
	^ valueByTime
]

{ #category : #accessing }
KRIMetric >> valueByTime: anObject [
	valueByTime := anObject
]
