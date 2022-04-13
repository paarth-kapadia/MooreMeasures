USE ORD_Singh_202001030D

IF (OBJECT_ID('Dflt._ppko_LCA_2019_MA_TABLE1') IS NOT NULL)
	BEGIN
		DROP TABLE Dflt._ppko_LCA_2019_MA_TABLE1
	END

CREATE TABLE Dflt._ppko_LCA_2019_MA_TABLE1
(
	PatientSSN VARCHAR(100)
	,PatientAge INT
	,PatientSex VARCHAR(100)
	,PatientRace VARCHAR(100)
	,StageOfCancer VARCHAR(100)
	,EmergencyStatus VARCHAR(100)
	,DxEventDateTime DATETIME2
)

INSERT INTO Dflt._ppko_LCA_2019_MA_TABLE1
SELECT DISTINCT
	SUBSTRING(a.PatientSSN, 2, 9)
	,a.PatientAge
	,a.PatientSex
	,a.PatientRace
	,a.StageOfCancer
	,'EP'
	,a.DiagnosticEventDateTime
FROM Dflt._ppko_LCA_2019d_DEMOGRAPHIC_TABLE AS a INNER JOIN Dflt._ppko_LCA_2019n_DEMOGRAPHIC_TABLE AS b ON a.PatientSSN = b.PatientSSN AND a.DiagnosticEventDateTime = b.DiagnosticEventDateTime

INSERT INTO Dflt._ppko_LCA_2019_MA_TABLE1
SELECT DISTINCT
	SUBSTRING(a.PatientSSN, 2, 9)
	,a.PatientAge
	,a.PatientSex
	,a.PatientRace
	,a.StageOfCancer
	,'Non-EP'
	,a.DiagnosticEventDateTime
FROM Dflt._ppko_LCA_2019d_DEMOGRAPHIC_TABLE AS a WHERE a.PatientSSN NOT IN (SELECT b.PatientSSN FROM Dflt._ppko_LCA_2019n_DEMOGRAPHIC_TABLE AS b WHERE a.DiagnosticEventDateTime = b.DiagnosticEventDateTime)

IF (OBJECT_ID('Dflt._ppko_LCA_2019_MA_TABLE2') IS NOT NULL)
	BEGIN
		DROP TABLE Dflt._ppko_LCA_2019_MA_TABLE2
	END

CREATE TABLE Dflt._ppko_LCA_2019_MA_TABLE2
(
	PatientSSN VARCHAR(100)
	,PatientSID INT
	,PatientAge INT
	,PatientSex VARCHAR(100)
	,PatientRace VARCHAR(100)
	,StageOfCancer VARCHAR(100)
	,EmergencyStatus VARCHAR(100)
	,DxEventDateTime DATETIME2
)

INSERT INTO Dflt._ppko_LCA_2019_MA_TABLE2
SELECT
	a.PatientSSN
	,sp.PatientSID
	,a.PatientAge
	,a.PatientSex
	,a.PatientRace
	,a.StageOfCancer
	,a.EmergencyStatus
	,a.DxEventDateTime
FROM Dflt._ppko_LCA_2019_MA_TABLE1 AS a INNER JOIN Src.SPatient_SPatient AS sp ON a.PatientSSN = sp.PatientSSN

IF (OBJECT_ID('Dflt._ppko_LCA_2019_MA_TABLE3') IS NOT NULL)
	BEGIN
		DROP TABLE Dflt._ppko_LCA_2019_MA_TABLE3
	END

CREATE TABLE Dflt._ppko_LCA_2019_MA_TABLE3
(
	PatientSSN VARCHAR(100)
	,PatientSID INT
	,PatientAge INT
	,PatientSex VARCHAR(100)
	,PatientRace VARCHAR(100)
	,StageOfCancer VARCHAR(100)
	,EmergencyStatus VARCHAR(100)
	,DxEventDateTime DATETIME2
	,EncounterSID BIGINT
	,EncounterDateTime DATETIME2
)

INSERT INTO Dflt._ppko_LCA_2019_MA_TABLE3
SELECT
	x.*
	,inp.InpatientSID
	,inp.AdmitDateTime
FROM Src.Inpat_Inpatient AS inp INNER JOIN Dflt._ppko_LCA_2019_MA_TABLE2 AS x ON inp.PatientSID = x.PatientSID
WHERE inp.AdmitDateTime BETWEEN '01-01-2019' AND '01-01-2021'

INSERT INTO Dflt._ppko_LCA_2019_MA_TABLE3
SELECT
	x.*
	,oup.VisitSID
	,oup.VisitDateTime
FROM Src.Outpat_Workload AS oup INNER JOIN Dflt._ppko_LCA_2019_MA_TABLE2 AS x ON oup.PatientSID = x.PatientSID
WHERE oup.VisitDateTime BETWEEN '01-01-2019' AND '01-01-2021'








IF (OBJECT_ID('Dflt._ppko_LCA_2019_MA_TABLE4_90') IS NOT NULL)
	BEGIN
		DROP TABLE Dflt._ppko_LCA_2019_MA_TABLE4_90
	END

CREATE TABLE Dflt._ppko_LCA_2019_MA_TABLE4_90
(
	PatientSSN VARCHAR(100)
	,PatientSID INT
	,PatientAge INT
	,PatientSex VARCHAR(100)
	,PatientRace VARCHAR(100)
	,StageOfCancer VARCHAR(100)
	,EmergencyStatus VARCHAR(100)
	,DxEventDateTime DATETIME2
	,Encounter90SID BIGINT
	,Encounter90DateTime DATETIME2
)

INSERT INTO Dflt._ppko_LCA_2019_MA_TABLE4_90
SELECT a.*
FROM Dflt._ppko_LCA_2019_MA_TABLE3 AS a WHERE a.EncounterDateTime BETWEEN a.DxEventDateTime AND DATEADD (DAY, 90, a.DxEventDateTime)

IF (OBJECT_ID('Dflt._ppko_LCA_2019_MA_TABLE5_90') IS NOT NULL)
	BEGIN
		DROP TABLE Dflt._ppko_LCA_2019_MA_TABLE5_90
	END

CREATE TABLE Dflt._ppko_LCA_2019_MA_TABLE5_90
(
	PatientSSN VARCHAR(100)
	,PatientSID INT
	,PatientAge INT
	,PatientSex VARCHAR(100)
	,PatientRace VARCHAR(100)
	,StageOfCancer VARCHAR(100)
	,EmergencyStatus VARCHAR(100)
	,DxEventDateTime DATETIME2
	,Encounter90SID BIGINT
	,Encounter90DateTime DATETIME2
)

INSERT INTO Dflt._ppko_LCA_2019_MA_TABLE5_90
SELECT a.*
FROM Dflt._ppko_LCA_2019_MA_TABLE4_90 AS a WHERE a.Encounter90SID =
(
	SELECT TOP 1 x.Encounter90SID
	FROM Dflt._ppko_LCA_2019_MA_TABLE4_90 AS x
	WHERE a.PatientSSN = x.PatientSSN
	ORDER BY x.Encounter90DateTime DESC
)





IF (OBJECT_ID('Dflt._ppko_LCA_2019_MA_TABLE4_180') IS NOT NULL)
	BEGIN
		DROP TABLE Dflt._ppko_LCA_2019_MA_TABLE4_180
	END

CREATE TABLE Dflt._ppko_LCA_2019_MA_TABLE4_180
(
	PatientSSN VARCHAR(100)
	,PatientSID INT
	,PatientAge INT
	,PatientSex VARCHAR(100)
	,PatientRace VARCHAR(100)
	,StageOfCancer VARCHAR(100)
	,EmergencyStatus VARCHAR(100)
	,DxEventDateTime DATETIME2
	,Encounter90SID BIGINT
	,Encounter90DateTime DATETIME2
)

INSERT INTO Dflt._ppko_LCA_2019_MA_TABLE4_180
SELECT a.*
FROM Dflt._ppko_LCA_2019_MA_TABLE3 AS a WHERE a.EncounterDateTime BETWEEN a.DxEventDateTime AND DATEADD (DAY, 90, a.DxEventDateTime)

IF (OBJECT_ID('Dflt._ppko_LCA_2019_MA_TABLE5_180') IS NOT NULL)
	BEGIN
		DROP TABLE Dflt._ppko_LCA_2019_MA_TABLE5_180
	END

CREATE TABLE Dflt._ppko_LCA_2019_MA_TABLE5_180
(
	PatientSSN VARCHAR(100)
	,PatientSID INT
	,PatientAge INT
	,PatientSex VARCHAR(100)
	,PatientRace VARCHAR(100)
	,StageOfCancer VARCHAR(100)
	,EmergencyStatus VARCHAR(100)
	,DxEventDateTime DATETIME2
	,Encounter90SID BIGINT
	,Encounter90DateTime DATETIME2
)

INSERT INTO Dflt._ppko_LCA_2019_MA_TABLE5_180
SELECT a.*
FROM Dflt._ppko_LCA_2019_MA_TABLE4_90 AS a WHERE a.Encounter90SID =
(
	SELECT TOP 1 x.Encounter90SID
	FROM Dflt._ppko_LCA_2019_MA_TABLE4_90 AS x
	WHERE a.PatientSSN = x.PatientSSN
	ORDER BY x.Encounter90DateTime DESC
)












IF (OBJECT_ID('Dflt._ppko_LCA_2019_MA_TABLE6') IS NOT NULL)
	BEGIN
		DROP TABLE Dflt._ppko_LCA_2019_MA_TABLE6
	END

CREATE TABLE Dflt._ppko_LCA_2019_MA_TABLE6
(
	PatientSSN VARCHAR(100)
	,PatientAge INT
	,PatientSex VARCHAR(100)
	,PatientRace VARCHAR(100)
	,StageOfCancer VARCHAR(100)
	,EmergencyStatus VARCHAR(100)
	,DxEventDateTime DATETIME2
	,EncounterDateTime DATETIME2
	,DeathDate DATETIME2
)

INSERT INTO Dflt._ppko_LCA_2019_MA_TABLE6
SELECT DISTINCT
	a.PatientSSN
	,a.PatientAge
	,a.PatientSex
	,a.PatientRace
	,a.StageOfCancer
	,a.EmergencyStatus
	,a.DxEventDateTime
	,a.EncounterDateTime
	,vsm.DOD
FROM Dflt._ppko_LCA_2019_MA_TABLE5 AS a INNER JOIN [ORD_Singh_202001030D].[Src].SPatient_SPatient AS sp ON a.PatientSSN = sp.PatientSSN
	INNER JOIN [ORD_Singh_202001030D].[Src].[VitalStatus_Mini] AS VSM ON sp.ScrSSN = vsm.SCRSSN

IF (OBJECT_ID('Dflt._ppko_LCA_2019_MA_TABLE7') IS NOT NULL)
	BEGIN
		DROP TABLE Dflt._ppko_LCA_2019_MA_TABLE7
	END

CREATE TABLE Dflt._ppko_LCA_2019_MA_TABLE7
(
	PatientAge INT
	,PatientSex VARCHAR(100)
	,PatientRace VARCHAR(100)
	,StageOfCancer VARCHAR(100)
	,EmergencyStatus VARCHAR(100)
	,Death3Mo INT
	,Death6Mo INT
	,Death12Mo INT
)

INSERT INTO Dflt._ppko_LCA_2019_MA_TABLE7
SELECT
	a.PatientAge
	,a.PatientSex
	,a.PatientRace
	,a.StageOfCancer
	,a.EmergencyStatus
	,CASE
		WHEN a.DeathDate IS NULL THEN 0
		WHEN a.DeathDate BETWEEN a.DxEventDateTime AND DATEADD(MONTH, 3, DxEventDateTime) THEN 1
		ELSE 0
	 END
	,CASE
		WHEN a.DeathDate IS NULL THEN 0
		WHEN a.DeathDate BETWEEN a.DxEventDateTime AND DATEADD(MONTH, 6, DxEventDateTime) THEN 1
		ELSE 0
	 END
	,CASE
		WHEN a.DeathDate IS NULL THEN 0
		WHEN a.DeathDate BETWEEN a.DxEventDateTime AND DATEADD(MONTH, 12, DxEventDateTime) THEN 1
		ELSE 0
	 END
FROM Dflt._ppko_LCA_2019_MA_TABLE6 AS a

SELECT * FROM Dflt._ppko_LCA_2019_MA_TABLE7

DROP TABLE Dflt._ppko_LCA_2019_MA_TABLE1

DROP TABLE Dflt._ppko_LCA_2019_MA_TABLE2

DROP TABLE Dflt._ppko_LCA_2019_MA_TABLE3

DROP TABLE Dflt._ppko_LCA_2019_MA_TABLE4

DROP TABLE Dflt._ppko_LCA_2019_MA_TABLE5

DROP TABLE Dflt._ppko_LCA_2019_MA_TABLE6

DROP TABLE Dflt._ppko_LCA_2019_MA_TABLE7