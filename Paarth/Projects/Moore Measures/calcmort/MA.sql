USE ORD_Singh_202001030D


-- Pull all the data from demographic tables from MM2 script
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


-- Add SSN
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


-- Add future encounters +2 years ahead
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
WHERE inp.AdmitDateTime >= '01-01-2019'

INSERT INTO Dflt._ppko_LCA_2019_MA_TABLE3
SELECT
	x.*
	,oup.VisitSID
	,oup.VisitDateTime
FROM Src.Outpat_Workload AS oup INNER JOIN Dflt._ppko_LCA_2019_MA_TABLE2 AS x ON oup.PatientSID = x.PatientSID
WHERE oup.VisitDateTime >= '01-01-2019'


-- Select for only encounters within 90 days
IF (OBJECT_ID('Dflt._ppko_LCA_2019_MA_TABLE4') IS NOT NULL)
	BEGIN
		DROP TABLE Dflt._ppko_LCA_2019_MA_TABLE4
	END

CREATE TABLE Dflt._ppko_LCA_2019_MA_TABLE4
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

INSERT INTO Dflt._ppko_LCA_2019_MA_TABLE4
SELECT a.*
FROM Dflt._ppko_LCA_2019_MA_TABLE3 AS a WHERE a.EncounterDateTime BETWEEN a.DxEventDateTime AND DATEADD (DAY, 90, a.DxEventDateTime)


-- Select for only the most recent encounter within the last 90 days
IF (OBJECT_ID('Dflt._ppko_LCA_2019_MA_TABLE5') IS NOT NULL)
	BEGIN
		DROP TABLE Dflt._ppko_LCA_2019_MA_TABLE5
	END

CREATE TABLE Dflt._ppko_LCA_2019_MA_TABLE5
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

INSERT INTO Dflt._ppko_LCA_2019_MA_TABLE5
SELECT a.*
FROM Dflt._ppko_LCA_2019_MA_TABLE4 AS a WHERE a.Encounter90SID =
(
	SELECT TOP 1 x.Encounter90SID
	FROM Dflt._ppko_LCA_2019_MA_TABLE4 AS x
	WHERE a.PatientSSN = x.PatientSSN
	ORDER BY x.Encounter90DateTime DESC
)


-- Select for only encounters within 180 days
IF (OBJECT_ID('Dflt._ppko_LCA_2019_MA_TABLE6') IS NOT NULL)
	BEGIN
		DROP TABLE Dflt._ppko_LCA_2019_MA_TABLE6
	END

CREATE TABLE Dflt._ppko_LCA_2019_MA_TABLE6
(
	PatientSSN VARCHAR(100)
	,PatientSID INT
	,PatientAge INT
	,PatientSex VARCHAR(100)
	,PatientRace VARCHAR(100)
	,StageOfCancer VARCHAR(100)
	,EmergencyStatus VARCHAR(100)
	,DxEventDateTime DATETIME2
	,Encounter180SID BIGINT
	,Encounter180DateTime DATETIME2
)

INSERT INTO Dflt._ppko_LCA_2019_MA_TABLE6
SELECT a.*
FROM Dflt._ppko_LCA_2019_MA_TABLE3 AS a WHERE a.EncounterDateTime BETWEEN a.DxEventDateTime AND DATEADD (DAY, 180, a.DxEventDateTime)


-- Select for only the most recent encounter within the last 180 days
IF (OBJECT_ID('Dflt._ppko_LCA_2019_MA_TABLE7') IS NOT NULL)
	BEGIN
		DROP TABLE Dflt._ppko_LCA_2019_MA_TABLE7
	END

CREATE TABLE Dflt._ppko_LCA_2019_MA_TABLE7
(
	PatientSSN VARCHAR(100)
	,PatientSID INT
	,PatientAge INT
	,PatientSex VARCHAR(100)
	,PatientRace VARCHAR(100)
	,StageOfCancer VARCHAR(100)
	,EmergencyStatus VARCHAR(100)
	,DxEventDateTime DATETIME2
	,Encounter180SID BIGINT
	,Encounter180DateTime DATETIME2
)

INSERT INTO Dflt._ppko_LCA_2019_MA_TABLE7
SELECT a.*
FROM Dflt._ppko_LCA_2019_MA_TABLE6 AS a WHERE a.Encounter180SID =
(
	SELECT TOP 1 x.Encounter180SID
	FROM Dflt._ppko_LCA_2019_MA_TABLE6 AS x
	WHERE a.PatientSSN = x.PatientSSN
	ORDER BY x.Encounter180DateTime DESC
)


-- Select for only encounters within 365 days
IF (OBJECT_ID('Dflt._ppko_LCA_2019_MA_TABLE8') IS NOT NULL)
	BEGIN
		DROP TABLE Dflt._ppko_LCA_2019_MA_TABLE8
	END

CREATE TABLE Dflt._ppko_LCA_2019_MA_TABLE8
(
	PatientSSN VARCHAR(100)
	,PatientSID INT
	,PatientAge INT
	,PatientSex VARCHAR(100)
	,PatientRace VARCHAR(100)
	,StageOfCancer VARCHAR(100)
	,EmergencyStatus VARCHAR(100)
	,DxEventDateTime DATETIME2
	,Encounter365SID BIGINT
	,Encounter365DateTime DATETIME2
)

INSERT INTO Dflt._ppko_LCA_2019_MA_TABLE8
SELECT a.*
FROM Dflt._ppko_LCA_2019_MA_TABLE3 AS a WHERE a.EncounterDateTime BETWEEN a.DxEventDateTime AND DATEADD (DAY, 365, a.DxEventDateTime)


-- Select for only the most recent encounter within the last 365 days
IF (OBJECT_ID('Dflt._ppko_LCA_2019_MA_TABLE9') IS NOT NULL)
	BEGIN
		DROP TABLE Dflt._ppko_LCA_2019_MA_TABLE9
	END

CREATE TABLE Dflt._ppko_LCA_2019_MA_TABLE9
(
	PatientSSN VARCHAR(100)
	,PatientSID INT
	,PatientAge INT
	,PatientSex VARCHAR(100)
	,PatientRace VARCHAR(100)
	,StageOfCancer VARCHAR(100)
	,EmergencyStatus VARCHAR(100)
	,DxEventDateTime DATETIME2
	,Encounter365SID BIGINT
	,Encounter365DateTime DATETIME2
)

INSERT INTO Dflt._ppko_LCA_2019_MA_TABLE9
SELECT a.*
FROM Dflt._ppko_LCA_2019_MA_TABLE8 AS a WHERE a.Encounter365SID =
(
	SELECT TOP 1 x.Encounter365SID
	FROM Dflt._ppko_LCA_2019_MA_TABLE8 AS x
	WHERE a.PatientSSN = x.PatientSSN
	ORDER BY x.Encounter365DateTime DESC
)


-- Put 90, 180, 365 day followups with the cancer diagnoses
IF (OBJECT_ID('Dflt._ppko_LCA_2019_MA_TABLE_A') IS NOT NULL)
	BEGIN
		DROP TABLE Dflt._ppko_LCA_2019_MA_TABLE_A
	END

CREATE TABLE Dflt._ppko_LCA_2019_MA_TABLE_A
(
	PatientSSN VARCHAR(100)
	,PatientAge INT
	,PatientSex VARCHAR(100)
	,PatientRace VARCHAR(100)
	,StageOfCancer VARCHAR(100)
	,EmergencyStatus VARCHAR(100)
	,DxEventDateTime DATETIME2
	,Encounter90DateTime DATETIME2
	,Encounter180DateTime DATETIME2
	,Encounter365DateTime DATETIME2
)

INSERT INTO Dflt._ppko_LCA_2019_MA_TABLE_A
SELECT DISTINCT
	a.PatientSSN
	,a.PatientAge
	,a.PatientSex
	,a.PatientRace
	,a.StageOfCancer
	,a.EmergencyStatus
	,a.DxEventDateTime
	,a.Encounter90DateTime
	,b.Encounter180DateTime
	,c.Encounter365DateTime
FROM Dflt._ppko_LCA_2019_MA_TABLE5 AS a INNER JOIN Dflt._ppko_LCA_2019_MA_TABLE7 AS b ON a.PatientSSN = b.PatientSSN AND a.DxEventDateTime = b.DxEventDateTime INNER JOIN Dflt._ppko_LCA_2019_MA_TABLE9 AS c ON a.PatientSSN = c.PatientSSN AND a.DxEventDateTime = c.DxEventDateTime


-- Add death dates
IF (OBJECT_ID('Dflt._ppko_LCA_2019_MA_TABLE_B') IS NOT NULL)
	BEGIN
		DROP TABLE Dflt._ppko_LCA_2019_MA_TABLE_B
	END

CREATE TABLE Dflt._ppko_LCA_2019_MA_TABLE_B
(
	PatientSSN VARCHAR(100)
	,PatientAge INT
	,PatientSex VARCHAR(100)
	,PatientRace VARCHAR(100)
	,StageOfCancer VARCHAR(100)
	,EmergencyStatus VARCHAR(100)
	,DxEventDateTime DATETIME2
	,Encounter90DateTime DATETIME2
	,Encounter180DateTime DATETIME2
	,Encounter365DateTime DATETIME2
	,DeathDate DATETIME2
)

INSERT INTO Dflt._ppko_LCA_2019_MA_TABLE_B
SELECT DISTINCT
	a.PatientSSN
	,a.PatientAge
	,a.PatientSex
	,a.PatientRace
	,a.StageOfCancer
	,a.EmergencyStatus
	,a.DxEventDateTime
	,a.Encounter90DateTime
	,a.Encounter180DateTime
	,a.Encounter365DateTime
	,vsm.DOD
FROM Dflt._ppko_LCA_2019_MA_TABLE_A AS a INNER JOIN [ORD_Singh_202001030D].[Src].SPatient_SPatient AS sp ON a.PatientSSN = sp.PatientSSN
	INNER JOIN [ORD_Singh_202001030D].[Src].[VitalStatus_Mini] AS VSM ON sp.ScrSSN = vsm.SCRSSN


-- Add status flags
IF (OBJECT_ID('Dflt._ppko_LCA_2019_MA_TABLE_C') IS NOT NULL)
	BEGIN
		DROP TABLE Dflt._ppko_LCA_2019_MA_TABLE_C
	END

CREATE TABLE Dflt._ppko_LCA_2019_MA_TABLE_C
(
	PatientAge INT
	,PatientSex INT
	,PatientRace INT
	,StageOfCancer INT
	,EmergencyStatus INT
	,Time90 INT
	,Time180 INT
	,Time365 INT
	,DeathStatus90 INT
	,DeathStatus180 INT
	,DeathStatus365 INT
)

INSERT INTO Dflt._ppko_LCA_2019_MA_TABLE_C
SELECT
	a.PatientAge
	,CASE
		WHEN a.PatientSex = 'M' THEN 1
		WHEN a.PatientSex = 'F' THEN 2
		ELSE 0
	 END
	,CASE
		WHEN a.PatientRace = 'WHITE, NOT HISPANIC' THEN 1
		WHEN a.PatientRace = 'BLACK' THEN 2
		WHEN a.PatientRace = 'HISPANIC' THEN 3
		WHEN a.PatientRace = 'OTHER' THEN 4
		ELSE 0
	 END
	,CASE
		WHEN a.StageOfCancer IS NULL THEN 0
		WHEN a.StageOfCancer = 'I' THEN 1
		WHEN a.StageOfCancer = 'II' THEN 2
		WHEN a.StageOfCancer = 'III' THEN 3
		WHEN a.StageOfCancer = 'IV' THEN 4
		ELSE 0
	 END
	,CASE
		WHEN a.EmergencyStatus = 'EP' THEN 1
		WHEN a.EmergencyStatus = 'Non-EP' THEN 2
		ELSE 0
	 END
	,DATEDIFF(DAY, a.DxEventDateTime, a.Encounter90DateTime)
	,DATEDIFF(DAY, a.DxEventDateTime, a.Encounter180DateTime)
	,DATEDIFF(DAY, a.DxEventDateTime, a.Encounter365DateTime)
	-- 90 day status
	,CASE
		WHEN a.DeathDate IS NULL THEN 0
		WHEN a.DeathDate BETWEEN a.DxEventDateTime AND DATEADD(DAY, 90, DxEventDateTime) THEN 1
		ELSE 0
	 END
	-- 180 day status
	,CASE
		WHEN a.DeathDate IS NULL THEN 0
		WHEN a.DeathDate BETWEEN a.DxEventDateTime AND DATEADD(DAY, 180, DxEventDateTime) THEN 1
		ELSE 0
	 END
	-- 365 day status
	,CASE
		WHEN a.DeathDate IS NULL THEN 0
		WHEN a.DeathDate BETWEEN a.DxEventDateTime AND DATEADD(DAY, 365, DxEventDateTime) THEN 1
		ELSE 0
	 END
FROM Dflt._ppko_LCA_2019_MA_TABLE_B AS a


SELECT DISTINCT * FROM Dflt._ppko_LCA_2019_MA_TABLE_C 

DROP TABLE Dflt._ppko_LCA_2019_MA_TABLE1
DROP TABLE Dflt._ppko_LCA_2019_MA_TABLE2
DROP TABLE Dflt._ppko_LCA_2019_MA_TABLE3
DROP TABLE Dflt._ppko_LCA_2019_MA_TABLE4
DROP TABLE Dflt._ppko_LCA_2019_MA_TABLE5
DROP TABLE Dflt._ppko_LCA_2019_MA_TABLE6
DROP TABLE Dflt._ppko_LCA_2019_MA_TABLE7
DROP TABLE Dflt._ppko_LCA_2019_MA_TABLE8
DROP TABLE Dflt._ppko_LCA_2019_MA_TABLE9
DROP TABLE Dflt._ppko_LCA_2019_MA_TABLE_A
DROP TABLE Dflt._ppko_LCA_2019_MA_TABLE_B
DROP TABLE Dflt._ppko_LCA_2019_MA_TABLE_C