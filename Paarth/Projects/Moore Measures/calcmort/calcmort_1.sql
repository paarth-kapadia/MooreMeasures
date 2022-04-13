-- Calculate all-cause mortality

SELECT COUNT (DISTINCT a.[PatientSSN])
FROM [ORD_Singh_202001030D].[Dflt]._ppko_CaP_2017n_OUTPUT_TABLE AS a INNER JOIN Src.SPatient_SPatient AS sp ON a.PatientSSN = CONCAT('''', sp.PatientSSN, '''')
WHERE
	TypeOfDiagnosisEvent = 'REGISTRY ENTRY'
	AND
	a.TypeOfEmergencyEvent = 'INPATIENT'
	AND
	sp.DeathDateTime BETWEEN 
		a.DiagnosticEventDateTime
		AND
		DATEADD(YEAR, 1, a.DiagnosticEventDateTime)
	AND
	a.StageOfCancer = 'I'

SELECT COUNT (DISTINCT a.[PatientSSN])
FROM [ORD_Singh_202001030D].[Dflt]._ppko_CaP_2017n_OUTPUT_TABLE AS a INNER JOIN Src.SPatient_SPatient AS sp ON a.PatientSSN = CONCAT('''', sp.PatientSSN, '''')
WHERE
	TypeOfDiagnosisEvent = 'REGISTRY ENTRY'
	AND
	a.TypeOfEmergencyEvent = 'ED-Treat-and-Release'
	AND
	sp.DeathDateTime BETWEEN 
		a.DiagnosticEventDateTime
		AND
		DATEADD(YEAR, 1, a.DiagnosticEventDateTime)
	AND
	a.StageOfCancer = 'I'

SELECT COUNT (DISTINCT a.[PatientSSN])
FROM [ORD_Singh_202001030D].[Dflt]._ppko_CaP_2017n_OUTPUT_TABLE AS a INNER JOIN Src.SPatient_SPatient AS sp ON a.PatientSSN = CONCAT('''', sp.PatientSSN, '''')
WHERE
	TypeOfDiagnosisEvent = 'REGISTRY ENTRY'
	AND
	sp.DeathDateTime BETWEEN 
		a.DiagnosticEventDateTime
		AND
		DATEADD(YEAR, 1, a.DiagnosticEventDateTime)
	AND
	a.StageOfCancer = 'I'

SELECT COUNT (DISTINCT [PatientSSN])
FROM [ORD_Singh_202001030D].[Dflt]._ppko_CaP_2017n_OUTPUT_TABLE AS a
WHERE
	TypeOfDiagnosisEvent = 'REGISTRY ENTRY'
	AND
	a.StageOfCancer = 'I'

SELECT COUNT (DISTINCT a.[PatientSSN])
FROM [ORD_Singh_202001030D].[Dflt]._ppko_CaP_2017d_OUTPUT_TABLE AS a INNER JOIN Src.SPatient_SPatient AS sp ON a.PatientSSN = CONCAT('''', sp.PatientSSN, '''')
WHERE
	TypeOfDiagnosisEvent = 'REGISTRY ENTRY'
	AND
	a.PatientSSN NOT IN
	(
		SELECT PatientSSN 
		FROM [Dflt]._ppko_CaP_2017n_OUTPUT_TABLE
	) 
	AND 
	sp.DeathDateTime BETWEEN 
		a.DiagnosticEventDateTime
		AND
		DATEADD(YEAR, 1, a.DiagnosticEventDateTime)
	AND
	a.StageOfCancer = 'I'

SELECT COUNT (DISTINCT [PatientSSN])
FROM [ORD_Singh_202001030D].[Dflt]._ppko_CaP_2017d_OUTPUT_TABLE AS a
WHERE
	TypeOfDiagnosisEvent = 'REGISTRY ENTRY'
	AND
	PatientSSN NOT IN
	(
		SELECT PatientSSN 
		FROM [Dflt]._ppko_CaP_2017n_OUTPUT_TABLE
	)
	AND
	a.StageOfCancer = 'I'