USE ORD_Singh_202001030D

-- NUMERATOR
SELECT COUNT(DISTINCT a.PatientSSN)
FROM Dflt._ppko_CRC_2016n_DEMOGRAPHIC_TABLE AS a 
WHERE 
	a.PatientRace = 'WHITE, NOT HISPANIC'

SELECT COUNT(DISTINCT a.PatientSSN)
FROM Dflt._ppko_CRC_2016n_DEMOGRAPHIC_TABLE AS a 
WHERE 
	a.PatientRace = 'WHITE, HISPANIC'

SELECT COUNT(DISTINCT a.PatientSSN)
FROM Dflt._ppko_CRC_2016n_DEMOGRAPHIC_TABLE AS a 
WHERE 
	a.PatientRace = 'BLACK'

SELECT COUNT(DISTINCT a.PatientSSN)
FROM Dflt._ppko_CRC_2016n_DEMOGRAPHIC_TABLE AS a 
WHERE 
	a.PatientRace = 'OTHER'


-- DENOMINATOR
SELECT COUNT(DISTINCT a.PatientSSN)
FROM Dflt._ppko_CRC_2016d_DEMOGRAPHIC_TABLE AS a 
WHERE 
	a.PatientRace = 'WHITE, NOT HISPANIC'

SELECT COUNT(DISTINCT a.PatientSSN)
FROM Dflt._ppko_CRC_2016d_DEMOGRAPHIC_TABLE AS a 
WHERE 
	a.PatientRace = 'WHITE, HISPANIC'

SELECT COUNT(DISTINCT a.PatientSSN)
FROM Dflt._ppko_CRC_2016d_DEMOGRAPHIC_TABLE AS a 
WHERE 
	a.PatientRace = 'BLACK'

SELECT COUNT(DISTINCT a.PatientSSN)
FROM Dflt._ppko_CRC_2016d_DEMOGRAPHIC_TABLE AS a 
WHERE 
	a.PatientRace = 'OTHER'


-- NUMERATOR
SELECT COUNT(DISTINCT a.PatientSSN)
FROM Dflt._ppko_CRC_2016n_DEMOGRAPHIC_TABLE AS a 
WHERE 
	a.PatientRace = 'WHITE, NOT HISPANIC'
	AND
	a.DeathDateTime BETWEEN 
		a.DiagnosticEventDateTime
		AND
		DATEADD(YEAR, 1, a.DiagnosticEventDateTime)

SELECT COUNT(DISTINCT a.PatientSSN)
FROM Dflt._ppko_CRC_2016n_DEMOGRAPHIC_TABLE AS a 
WHERE 
	a.PatientRace = 'WHITE, HISPANIC'
	AND
	a.DeathDateTime BETWEEN 
		a.DiagnosticEventDateTime
		AND
		DATEADD(YEAR, 1, a.DiagnosticEventDateTime)

SELECT COUNT(DISTINCT a.PatientSSN)
FROM Dflt._ppko_CRC_2016n_DEMOGRAPHIC_TABLE AS a 
WHERE 
	a.PatientRace = 'BLACK'
	AND
	a.DeathDateTime BETWEEN 
		a.DiagnosticEventDateTime
		AND
		DATEADD(YEAR, 1, a.DiagnosticEventDateTime)

SELECT COUNT(DISTINCT a.PatientSSN)
FROM Dflt._ppko_CRC_2016n_DEMOGRAPHIC_TABLE AS a 
WHERE 
	a.PatientRace = 'OTHER'
	AND
	a.DeathDateTime BETWEEN 
		a.DiagnosticEventDateTime
		AND
		DATEADD(YEAR, 1, a.DiagnosticEventDateTime)


-- DENOMINATOR
SELECT COUNT(DISTINCT a.PatientSSN)
FROM Dflt._ppko_CRC_2016d_DEMOGRAPHIC_TABLE AS a 
WHERE 
	a.PatientRace = 'WHITE, NOT HISPANIC'
	AND
	a.DeathDateTime BETWEEN 
		a.DiagnosticEventDateTime
		AND
		DATEADD(YEAR, 1, a.DiagnosticEventDateTime)

SELECT COUNT(DISTINCT a.PatientSSN)
FROM Dflt._ppko_CRC_2016d_DEMOGRAPHIC_TABLE AS a 
WHERE 
	a.PatientRace = 'WHITE, HISPANIC'
	AND
	a.DeathDateTime BETWEEN 
		a.DiagnosticEventDateTime
		AND
		DATEADD(YEAR, 1, a.DiagnosticEventDateTime)

SELECT COUNT(DISTINCT a.PatientSSN)
FROM Dflt._ppko_CRC_2016d_DEMOGRAPHIC_TABLE AS a 
WHERE 
	a.PatientRace = 'BLACK'
	AND
	a.DeathDateTime BETWEEN 
		a.DiagnosticEventDateTime
		AND
		DATEADD(YEAR, 1, a.DiagnosticEventDateTime)

SELECT COUNT(DISTINCT a.PatientSSN)
FROM Dflt._ppko_CRC_2016d_DEMOGRAPHIC_TABLE AS a 
WHERE 
	a.PatientRace = 'OTHER'
	AND
	a.DeathDateTime BETWEEN 
		a.DiagnosticEventDateTime
		AND
		DATEADD(YEAR, 1, a.DiagnosticEventDateTime)