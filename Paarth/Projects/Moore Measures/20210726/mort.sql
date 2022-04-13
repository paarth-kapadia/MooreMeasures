SELECT COUNT(DISTINCT a.PatientSSN) FROM [ORD_Singh_202001030D].[Dflt].[_ppkt_CRC_2016to2019n_OUTPUT_TABLE] AS a WHERE a.TypeOfDiagnosisEvent = 'REGISTRY ENTRY' AND a.PatientRace = 'OTHER'

SELECT COUNT(DISTINCT a.PatientSSN) FROM [ORD_Singh_202001030D].[Dflt].[_ppkt_CRC_2016to2019d_OUTPUT_TABLE] AS a WHERE a.TypeOfDiagnosisEvent = 'REGISTRY ENTRY' AND a.PatientRace = 'OTHER'

SELECT COUNT(DISTINCT a.PatientSSN) FROM [ORD_Singh_202001030D].[Dflt].[_ppkt_CRC_2016to2019n_OUTPUT_TABLE] AS a WHERE a.TypeOfDiagnosisEvent = 'REGISTRY ENTRY' AND a.PatientRace = 'OTHER'  AND
	a.DeathDateTime BETWEEN 
		a.DiagnosticEventDateTime
		AND
		DATEADD(YEAR, 1, a.DiagnosticEventDateTime)

SELECT COUNT(DISTINCT a.PatientSSN) FROM [ORD_Singh_202001030D].[Dflt].[_ppkt_CRC_2016to2019d_OUTPUT_TABLE] AS a WHERE a.TypeOfDiagnosisEvent = 'REGISTRY ENTRY' AND a.PatientRace = 'OTHER' AND
	a.DeathDateTime BETWEEN 
		a.DiagnosticEventDateTime
		AND
		DATEADD(YEAR, 1, a.DiagnosticEventDateTime)
	AND
	a.PatientSSN NOT IN (SELECT DISTINCT b.PatientSSN FROM [ORD_Singh_202001030D].[Dflt].[_ppkt_CRC_2016to2019n_OUTPUT_TABLE] AS b WHERE b.TypeOfDiagnosisEvent = 'REGISTRY ENTRY' AND b.PatientRace = 'OTHER')