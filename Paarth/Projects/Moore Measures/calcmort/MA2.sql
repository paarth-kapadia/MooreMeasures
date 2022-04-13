USE ORD_Singh_202001030D


-- Pull all the data from demographic tables from MM2 script
IF (OBJECT_ID('Dflt._ppko_CRC_2019_MA_TABLE_1') IS NOT NULL)
	BEGIN
		DROP TABLE Dflt._ppko_CRC_2019_MA_TABLE_1
	END

CREATE TABLE Dflt._ppko_CRC_2019_MA_TABLE_1
(
	PatientSSN VARCHAR(100)
	,PatientAge INT
	,PatientSex VARCHAR(100)
	,PatientRace VARCHAR(100)
	,StageOfCancer VARCHAR(100)
	,EmergencyStatus VARCHAR(100)
	,DxEventDateTime DATETIME2
)

INSERT INTO Dflt._ppko_CRC_2019_MA_TABLE_1
SELECT DISTINCT
	SUBSTRING(a.PatientSSN, 2, 9)
	,a.PatientAge
	,a.PatientSex
	,a.PatientRace
	,a.StageOfCancer
	,'EP'
	,a.DiagnosticEventDateTime
FROM Dflt._ppko_CRC_2019d_DEMOGRAPHIC_TABLE AS a INNER JOIN Dflt._ppko_CRC_2019n_DEMOGRAPHIC_TABLE AS b ON a.PatientSSN = b.PatientSSN AND a.DiagnosticEventDateTime = b.DiagnosticEventDateTime

INSERT INTO Dflt._ppko_CRC_2019_MA_TABLE_1
SELECT DISTINCT
	SUBSTRING(a.PatientSSN, 2, 9)
	,a.PatientAge
	,a.PatientSex
	,a.PatientRace
	,a.StageOfCancer
	,'Non-EP'
	,a.DiagnosticEventDateTime
FROM Dflt._ppko_CRC_2019d_DEMOGRAPHIC_TABLE AS a WHERE a.PatientSSN NOT IN (SELECT b.PatientSSN FROM Dflt._ppko_CRC_2019n_DEMOGRAPHIC_TABLE AS b WHERE a.DiagnosticEventDateTime = b.DiagnosticEventDateTime)

SELECT COUNT(*) FROM Dflt._ppko_CRC_2019_MA_TABLE_1

-- Add SID
IF (OBJECT_ID('Dflt._ppko_CRC_2019_MA_TABLE_2') IS NOT NULL)
	BEGIN
		DROP TABLE Dflt._ppko_CRC_2019_MA_TABLE_2
	END

CREATE TABLE Dflt._ppko_CRC_2019_MA_TABLE_2
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

INSERT INTO Dflt._ppko_CRC_2019_MA_TABLE_2
SELECT DISTINCT
	a.PatientSSN
	,sp.PatientSID
	,a.PatientAge
	,a.PatientSex
	,a.PatientRace
	,a.StageOfCancer
	,a.EmergencyStatus
	,a.DxEventDateTime
FROM Dflt._ppko_CRC_2019_MA_TABLE_1 AS a INNER JOIN Src.SPatient_SPatient AS sp ON a.PatientSSN = sp.PatientSSN

SELECT COUNT(*) FROM Dflt._ppko_CRC_2019_MA_TABLE_2

-- Add all encounters after the dx date
IF (OBJECT_ID('Dflt._ppko_CRC_2019_MA_TABLE_3') IS NOT NULL)
	BEGIN
		DROP TABLE Dflt._ppko_CRC_2019_MA_TABLE_3
	END

CREATE TABLE Dflt._ppko_CRC_2019_MA_TABLE_3
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

INSERT INTO Dflt._ppko_CRC_2019_MA_TABLE_3
SELECT DISTINCT
	x.*
	,inp.InpatientSID
	,inp.AdmitDateTime
FROM Src.Inpat_Inpatient AS inp INNER JOIN Dflt._ppko_CRC_2019_MA_TABLE_2 AS x ON inp.PatientSID = x.PatientSID
WHERE inp.AdmitDateTime >= '01-01-2019'

INSERT INTO Dflt._ppko_CRC_2019_MA_TABLE_3
SELECT DISTINCT
	x.*
	,oup.VisitSID
	,oup.VisitDateTime
FROM Src.Outpat_Workload AS oup INNER JOIN Dflt._ppko_CRC_2019_MA_TABLE_2 AS x ON oup.PatientSID = x.PatientSID
WHERE oup.VisitDateTime >= '01-01-2019'

SELECT COUNT(*) FROM Dflt._ppko_CRC_2019_MA_TABLE_3


-- Select for only the most recent encounter
IF (OBJECT_ID('Dflt._ppko_CRC_2019_MA_TABLE_4') IS NOT NULL)
	BEGIN
		DROP TABLE Dflt._ppko_CRC_2019_MA_TABLE_4
	END

CREATE TABLE Dflt._ppko_CRC_2019_MA_TABLE_4
(
	PatientSSN VARCHAR(100)
	,PatientSID INT
	,PatientAge INT
	,PatientSex VARCHAR(100)
	,PatientRace VARCHAR(100)
	,StageOfCancer VARCHAR(100)
	,EmergencyStatus VARCHAR(100)
	,DxEventDateTime DATETIME2
	,EncounterLatestSID BIGINT
	,EncounterLatestDateTime DATETIME2
)

INSERT INTO Dflt._ppko_CRC_2019_MA_TABLE_4
SELECT DISTINCT a.*
FROM Dflt._ppko_CRC_2019_MA_TABLE_3 AS a WHERE a.EncounterSID =
(
	SELECT TOP 1 x.EncounterSID
	FROM Dflt._ppko_CRC_2019_MA_TABLE_3 AS x
	WHERE a.PatientSSN = x.PatientSSN
	ORDER BY x.EncounterDateTime DESC
)

SELECT COUNT(*) FROM Dflt._ppko_CRC_2019_MA_TABLE_4

-- Add death dates
IF (OBJECT_ID('Dflt._ppko_CRC_2019_MA_TABLE_5') IS NOT NULL)
	BEGIN
		DROP TABLE Dflt._ppko_CRC_2019_MA_TABLE_5
	END

CREATE TABLE Dflt._ppko_CRC_2019_MA_TABLE_5
(
	PatientSSN VARCHAR(100)
	,PatientAge INT
	,PatientSex VARCHAR(100)
	,PatientRace VARCHAR(100)
	,StageOfCancer VARCHAR(100)
	,EmergencyStatus VARCHAR(100)
	,DxEventDateTime DATETIME2
	,EncounterLatestDateTime DATETIME2
	,DeathDate DATETIME2
)

INSERT INTO Dflt._ppko_CRC_2019_MA_TABLE_5
SELECT DISTINCT
	a.PatientSSN
	,a.PatientAge
	,a.PatientSex
	,a.PatientRace
	,a.StageOfCancer
	,a.EmergencyStatus
	,a.DxEventDateTime
	,a.EncounterLatestDateTime
	,vsm.DOD
FROM Dflt._ppko_CRC_2019_MA_TABLE_4 AS a INNER JOIN [ORD_Singh_202001030D].[Src].SPatient_SPatient AS sp ON a.PatientSSN = sp.PatientSSN
	INNER JOIN [ORD_Singh_202001030D].[Src].[VitalStatus_Mini] AS VSM ON sp.ScrSSN = vsm.SCRSSN

SELECT COUNT(*) FROM Dflt._ppko_CRC_2019_MA_TABLE_5

-- Add status flags
IF (OBJECT_ID('Dflt._ppko_CRC_2019_MA_TABLE_6') IS NOT NULL)
	BEGIN
		DROP TABLE Dflt._ppko_CRC_2019_MA_TABLE_6
	END

CREATE TABLE Dflt._ppko_CRC_2019_MA_TABLE_6
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

INSERT INTO Dflt._ppko_CRC_2019_MA_TABLE_6
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
	,CASE
		WHEN DATEDIFF(DAY, a.DxEventDateTime, a.EncounterLatestDateTime) < 90 THEN DATEDIFF(DAY, a.DxEventDateTime, a.EncounterLatestDateTime)
		ELSE 90
	 END
	,CASE
		WHEN DATEDIFF(DAY, a.DxEventDateTime, a.EncounterLatestDateTime) < 180 THEN DATEDIFF(DAY, a.DxEventDateTime, a.EncounterLatestDateTime)
		ELSE 180
	 END
	,CASE
		WHEN DATEDIFF(DAY, a.DxEventDateTime, a.EncounterLatestDateTime) < 365 THEN DATEDIFF(DAY, a.DxEventDateTime, a.EncounterLatestDateTime)
		ELSE 365
	 END
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
FROM Dflt._ppko_CRC_2019_MA_TABLE_5 AS a

SELECT COUNT(*) FROM Dflt._ppko_CRC_2019_MA_TABLE_6
SELECT * FROM Dflt._ppko_CRC_2019_MA_TABLE_6

DROP TABLE Dflt._ppko_CRC_2019_MA_TABLE_1
DROP TABLE Dflt._ppko_CRC_2019_MA_TABLE_2
DROP TABLE Dflt._ppko_CRC_2019_MA_TABLE_3
DROP TABLE Dflt._ppko_CRC_2019_MA_TABLE_4
DROP TABLE Dflt._ppko_CRC_2019_MA_TABLE_5
--DROP TABLE Dflt._ppko_CRC_2019_MA_TABLE_6