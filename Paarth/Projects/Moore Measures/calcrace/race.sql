USE ORD_Singh_202001030D

-- NUMERATOR
-- ********************************************************************************************************************************************************************************

IF (OBJECT_ID('Dflt._ppko_CaP_2020n_DEMOGRAPHIC_TABLE') IS NOT NULL)
	BEGIN
		DROP TABLE Dflt._ppko_CaP_2020n_DEMOGRAPHIC_TABLE
	END

CREATE TABLE Dflt._ppko_CaP_2020n_DEMOGRAPHIC_TABLE
(
	PatientSSN VARCHAR(100)
	,DiagnosticEventDateTime DATE
	,DiagnosisEventLocation VARCHAR(200)
	,TypeOfCancer VARCHAR(300)
	,StageOfCancer VARCHAR(100)
	,TypeOfDiagnosisEvent VARCHAR(50)
	,EmergencyEventDate DATE
	,EmergencyEventLocation VARCHAR(200)
	,TypeOfEmergencyEvent VARCHAR(50)
	,DeathDateTime DATETIME2
	,PatientSex VARCHAR(100)
	,PatientAge INT
	,PatientRace VARCHAR(100)
)

INSERT INTO Dflt._ppko_CaP_2020n_DEMOGRAPHIC_TABLE
SELECT DISTINCT
	a.PatientSSN
	,a.DiagnosticEventDateTime
	,a.DiagnosisEventLocation
	,a.TypeOfCancer
	,a.StageOfCancer
	,a.TypeOfDiagnosisEvent
	,a.EmergencyEventDate
	,a.EmergencyEventLocation
	,a.TypeOfEmergencyEvent
	,sp.DeathDateTime
	,sp.Gender	
	,DATEDIFF(YEAR, sp.BirthDateTime, a.DiagnosticEventDateTime)
	,'HISPANIC'
FROM [ORD_Singh_202001030D].[Dflt]._ppko_CaP_2020n_OUTPUT_TABLE AS a INNER JOIN Src.SPatient_SPatient AS sp ON a.PatientSSN = CONCAT('''', sp.PatientSSN, '''') INNER JOIN Src.PatSub_PatientRace AS pr ON sp.PatientSID = pr.PatientSID INNER JOIN Src.PatSub_PatientEthnicity AS pe ON sp.PatientSID = pe.PatientSID
WHERE
	TypeOfDiagnosisEvent = 'REGISTRY ENTRY'
	AND
	pe.Ethnicity = 'HISPANIC OR LATINO'

INSERT INTO Dflt._ppko_CaP_2020n_DEMOGRAPHIC_TABLE
SELECT DISTINCT
	a.PatientSSN
	,a.DiagnosticEventDateTime
	,a.DiagnosisEventLocation
	,a.TypeOfCancer
	,a.StageOfCancer
	,a.TypeOfDiagnosisEvent
	,a.EmergencyEventDate
	,a.EmergencyEventLocation
	,a.TypeOfEmergencyEvent
	,sp.DeathDateTime
	,sp.Gender	
	,DATEDIFF(YEAR, sp.BirthDateTime, a.DiagnosticEventDateTime)
	,'WHITE, NOT HISPANIC'
FROM [ORD_Singh_202001030D].[Dflt]._ppko_CaP_2020n_OUTPUT_TABLE AS a INNER JOIN Src.SPatient_SPatient AS sp ON a.PatientSSN = CONCAT('''', sp.PatientSSN, '''') INNER JOIN Src.PatSub_PatientRace AS pr ON sp.PatientSID = pr.PatientSID INNER JOIN Src.PatSub_PatientEthnicity AS pe ON sp.PatientSID = pe.PatientSID 
WHERE
	TypeOfDiagnosisEvent = 'REGISTRY ENTRY'
	AND
	(pr.Race = 'WHITE' OR pr.Race = 'WHITE NOT OF HISP ORIG')
	AND
	pe.Ethnicity != 'HISPANIC OR LATINO'
	AND 
	a.PatientSSN NOT IN 
	(
		SELECT DISTINCT b.PatientSSN
		FROM Dflt._ppko_CaP_2020n_DEMOGRAPHIC_TABLE AS b
	)

INSERT INTO Dflt._ppko_CaP_2020n_DEMOGRAPHIC_TABLE
SELECT DISTINCT
	a.PatientSSN
	,a.DiagnosticEventDateTime
	,a.DiagnosisEventLocation
	,a.TypeOfCancer
	,a.StageOfCancer
	,a.TypeOfDiagnosisEvent
	,a.EmergencyEventDate
	,a.EmergencyEventLocation
	,a.TypeOfEmergencyEvent
	,sp.DeathDateTime
	,sp.Gender	
	,DATEDIFF(YEAR, sp.BirthDateTime, a.DiagnosticEventDateTime)
	,'BLACK'
FROM [ORD_Singh_202001030D].[Dflt]._ppko_CaP_2020n_OUTPUT_TABLE AS a INNER JOIN Src.SPatient_SPatient AS sp ON a.PatientSSN = CONCAT('''', sp.PatientSSN, '''') INNER JOIN Src.PatSub_PatientRace AS pr ON sp.PatientSID = pr.PatientSID INNER JOIN Src.PatSub_PatientEthnicity AS pe ON sp.PatientSID = pe.PatientSID
WHERE
	TypeOfDiagnosisEvent = 'REGISTRY ENTRY'
	AND
	(pr.Race = 'BLACK OR AFRICAN AMERICAN')
	AND
	pe.Ethnicity != 'HISPANIC OR LATINO'
	AND 
	a.PatientSSN NOT IN 
	(
		SELECT DISTINCT b.PatientSSN
		FROM Dflt._ppko_CaP_2020n_DEMOGRAPHIC_TABLE AS b
	)

INSERT INTO Dflt._ppko_CaP_2020n_DEMOGRAPHIC_TABLE
SELECT DISTINCT
	a.PatientSSN
	,a.DiagnosticEventDateTime
	,a.DiagnosisEventLocation
	,a.TypeOfCancer
	,a.StageOfCancer
	,a.TypeOfDiagnosisEvent
	,a.EmergencyEventDate
	,a.EmergencyEventLocation
	,a.TypeOfEmergencyEvent
	,sp.DeathDateTime
	,sp.Gender	
	,DATEDIFF(YEAR, sp.BirthDateTime, a.DiagnosticEventDateTime)
	,'OTHER'
FROM [ORD_Singh_202001030D].[Dflt]._ppko_CaP_2020n_OUTPUT_TABLE AS a INNER JOIN Src.SPatient_SPatient AS sp ON a.PatientSSN = CONCAT('''', sp.PatientSSN, '''') INNER JOIN Src.PatSub_PatientRace AS pr ON sp.PatientSID = pr.PatientSID INNER JOIN Src.PatSub_PatientEthnicity AS pe ON sp.PatientSID = pe.PatientSID
WHERE
	TypeOfDiagnosisEvent = 'REGISTRY ENTRY'
	AND
	(pr.Race != 'BLACK OR AFRICAN AMERICAN' AND pr.Race != 'WHITE' AND pr.Race != 'WHITE NOT OF HISP ORIG')
	AND
	pe.Ethnicity != 'HISPANIC OR LATINO'
	AND 
	a.PatientSSN NOT IN 
	(
		SELECT DISTINCT b.PatientSSN
		FROM Dflt._ppko_CaP_2020n_DEMOGRAPHIC_TABLE AS b
	)

SELECT COUNT(DISTINCT b.PatientSSN)
FROM Dflt._ppko_CaP_2020n_DEMOGRAPHIC_TABLE AS b

SELECT COUNT (DISTINCT a.[PatientSSN])
FROM [ORD_Singh_202001030D].[Dflt]._ppko_CaP_2020n_OUTPUT_TABLE AS a INNER JOIN Src.SPatient_SPatient AS sp ON a.PatientSSN = CONCAT('''', sp.PatientSSN, '''') INNER JOIN Src.PatSub_PatientRace AS pr ON sp.PatientSID = pr.PatientSID INNER JOIN Src.PatSub_PatientEthnicity AS pe ON sp.PatientSID = pe.PatientSID
WHERE
	TypeOfDiagnosisEvent = 'REGISTRY ENTRY'



-- DENOMINATOR
-- ********************************************************************************************************************************************************************************

IF (OBJECT_ID('Dflt._ppko_CaP_2020d_DEMOGRAPHIC_TABLE') IS NOT NULL)
	BEGIN
		DROP TABLE Dflt._ppko_CaP_2020d_DEMOGRAPHIC_TABLE
	END

CREATE TABLE Dflt._ppko_CaP_2020d_DEMOGRAPHIC_TABLE
(
	PatientSSN VARCHAR(100)
	,DiagnosticEventDateTime DATE
	,DiagnosisEventLocation VARCHAR(200)
	,TypeOfCancer VARCHAR(300)
	,StageOfCancer VARCHAR(100)
	,TypeOfDiagnosisEvent VARCHAR(50)
	,DeathDateTime DATETIME2
	,PatientSex VARCHAR(100)
	,PatientAge INT
	,PatientRace VARCHAR(100)
)

INSERT INTO Dflt._ppko_CaP_2020d_DEMOGRAPHIC_TABLE
SELECT DISTINCT
	a.PatientSSN
	,a.DiagnosticEventDateTime
	,a.DiagnosisEventLocation
	,a.TypeOfCancer
	,a.StageOfCancer
	,a.TypeOfDiagnosisEvent
	,sp.DeathDateTime
	,sp.Gender	
	,DATEDIFF(YEAR, sp.BirthDateTime, a.DiagnosticEventDateTime)
	,'HISPANIC'
FROM [ORD_Singh_202001030D].[Dflt]._ppko_CaP_2020d_OUTPUT_TABLE AS a INNER JOIN Src.SPatient_SPatient AS sp ON a.PatientSSN = CONCAT('''', sp.PatientSSN, '''') INNER JOIN Src.PatSub_PatientRace AS pr ON sp.PatientSID = pr.PatientSID INNER JOIN Src.PatSub_PatientEthnicity AS pe ON sp.PatientSID = pe.PatientSID
WHERE
	TypeOfDiagnosisEvent = 'REGISTRY ENTRY'
	AND
	pe.Ethnicity = 'HISPANIC OR LATINO'

INSERT INTO Dflt._ppko_CaP_2020d_DEMOGRAPHIC_TABLE
SELECT DISTINCT
	a.PatientSSN
	,a.DiagnosticEventDateTime
	,a.DiagnosisEventLocation
	,a.TypeOfCancer
	,a.StageOfCancer
	,a.TypeOfDiagnosisEvent
	,sp.DeathDateTime
	,sp.Gender	
	,DATEDIFF(YEAR, sp.BirthDateTime, a.DiagnosticEventDateTime)
	,'WHITE, NOT HISPANIC'
FROM [ORD_Singh_202001030D].[Dflt]._ppko_CaP_2020d_OUTPUT_TABLE AS a INNER JOIN Src.SPatient_SPatient AS sp ON a.PatientSSN = CONCAT('''', sp.PatientSSN, '''') INNER JOIN Src.PatSub_PatientRace AS pr ON sp.PatientSID = pr.PatientSID INNER JOIN Src.PatSub_PatientEthnicity AS pe ON sp.PatientSID = pe.PatientSID
WHERE
	TypeOfDiagnosisEvent = 'REGISTRY ENTRY'
	AND
	(pr.Race = 'WHITE' OR pr.Race = 'WHITE NOT OF HISP ORIG')
	AND
	pe.Ethnicity != 'HISPANIC OR LATINO'
	AND 
	a.PatientSSN NOT IN 
	(
		SELECT DISTINCT b.PatientSSN
		FROM Dflt._ppko_CaP_2020d_DEMOGRAPHIC_TABLE AS b
	)

INSERT INTO Dflt._ppko_CaP_2020d_DEMOGRAPHIC_TABLE
SELECT DISTINCT
	a.PatientSSN
	,a.DiagnosticEventDateTime
	,a.DiagnosisEventLocation
	,a.TypeOfCancer
	,a.StageOfCancer
	,a.TypeOfDiagnosisEvent
	,sp.DeathDateTime
	,sp.Gender	
	,DATEDIFF(YEAR, sp.BirthDateTime, a.DiagnosticEventDateTime)
	,'BLACK'
FROM [ORD_Singh_202001030D].[Dflt]._ppko_CaP_2020d_OUTPUT_TABLE AS a INNER JOIN Src.SPatient_SPatient AS sp ON a.PatientSSN = CONCAT('''', sp.PatientSSN, '''') INNER JOIN Src.PatSub_PatientRace AS pr ON sp.PatientSID = pr.PatientSID INNER JOIN Src.PatSub_PatientEthnicity AS pe ON sp.PatientSID = pe.PatientSID
WHERE
	TypeOfDiagnosisEvent = 'REGISTRY ENTRY'
	AND
	(pr.Race = 'BLACK OR AFRICAN AMERICAN')
	AND
	pe.Ethnicity != 'HISPANIC OR LATINO'
	AND 
	a.PatientSSN NOT IN 
	(
		SELECT DISTINCT b.PatientSSN
		FROM Dflt._ppko_CaP_2020d_DEMOGRAPHIC_TABLE AS b
	)

INSERT INTO Dflt._ppko_CaP_2020d_DEMOGRAPHIC_TABLE
SELECT DISTINCT
	a.PatientSSN
	,a.DiagnosticEventDateTime
	,a.DiagnosisEventLocation
	,a.TypeOfCancer
	,a.StageOfCancer
	,a.TypeOfDiagnosisEvent
	,sp.DeathDateTime
	,sp.Gender	
	,DATEDIFF(YEAR, sp.BirthDateTime, a.DiagnosticEventDateTime)
	,'OTHER'
FROM [ORD_Singh_202001030D].[Dflt]._ppko_CaP_2020d_OUTPUT_TABLE AS a INNER JOIN Src.SPatient_SPatient AS sp ON a.PatientSSN = CONCAT('''', sp.PatientSSN, '''') INNER JOIN Src.PatSub_PatientRace AS pr ON sp.PatientSID = pr.PatientSID INNER JOIN Src.PatSub_PatientEthnicity AS pe ON sp.PatientSID = pe.PatientSID
WHERE
	TypeOfDiagnosisEvent = 'REGISTRY ENTRY'
	AND
	(pr.Race != 'BLACK OR AFRICAN AMERICAN' AND pr.Race != 'WHITE' AND pr.Race != 'WHITE NOT OF HISP ORIG')
	AND
	pe.Ethnicity != 'HISPANIC OR LATINO'
	AND 
	a.PatientSSN NOT IN 
	(
		SELECT DISTINCT b.PatientSSN
		FROM Dflt._ppko_CaP_2020d_DEMOGRAPHIC_TABLE AS b
	)

SELECT COUNT(DISTINCT b.PatientSSN)
FROM Dflt._ppko_CaP_2020d_DEMOGRAPHIC_TABLE AS b

SELECT COUNT (DISTINCT a.[PatientSSN])
FROM [ORD_Singh_202001030D].[Dflt]._ppko_CaP_2020d_OUTPUT_TABLE AS a INNER JOIN Src.SPatient_SPatient AS sp ON a.PatientSSN = CONCAT('''', sp.PatientSSN, '''') INNER JOIN Src.PatSub_PatientRace AS pr ON sp.PatientSID = pr.PatientSID INNER JOIN Src.PatSub_PatientEthnicity AS pe ON sp.PatientSID = pe.PatientSID
WHERE
	TypeOfDiagnosisEvent = 'REGISTRY ENTRY'