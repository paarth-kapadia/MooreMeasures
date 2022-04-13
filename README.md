# Digital quality measures of cancer diagnosis

1. Rate of delayed cancer red flag follow-up (process measure)
2. Rate of cancers diagnosed as an emergency (outcome measure)
3. Rate of cancers diagnosed at advanced stage (outcome measure)

This repository currently focuses on measures 2 and 3 only. This
README file contains pseudocode for measure 2 (emergency presentation
of cancer).




# Terminology

- Cancer of Study: The cancer being studied in a particular eMeasure.

- Diagnosis Event: A first-time discovery of the cancer of study.

- Cancer Registry Entry: An entry in the cancer registry from which we
may infer a Diagnosis Event occurred.

- First-Time Cancer Code Occurrence: The first occurrence of a
diagnostic code for a cancer in a patient's medical record, from which
we may infer a Diagnosis Event occurred.

- Pre-Diagnosis Emergency Care Event: Emergency care preceding the
Diagnosis Event that is related to some pre-diagnosis manifestation of
the cancer of study.

- Emergency Cancer Diagnosis: A Diagnosis Event preceded by a
Pre-Diagnosis Emergency Care Event within some Lookback Period.

- Emergency Cancer Diagnosis Record: A record containing the following
fields:

    - Patient ID

    - Pre-Diagnosis Emergency Care Event ID

    - Pre-Diagnosis Emergency Care Event Start Date

    - Pre-Diagnosis Emergency Care Event Location

    - Diagnosis Event ID

    - Diagnosis Event Start Date

    - Diagnosis Event Location

- Search Period Start: The date from which to search for Emergency
Cancer Diagnoses.

- Search Period Length: Length of time from `Search Period Start` over
which the search will be conducted.

- Search Period: The range of dates encompassed by `Search Period
Start + Search Period Length` over which the search is conducted.

- Exclusion Period Length: Length of time prior to `Search Period
Start` over which diagnostic data will be collected for each patient
to exclude them from the study if they have a prior cancer diagnosis.

- Exclusion Period: The range of dates encompassed by `Search Period
Start - Exclusion Period Length` over which data for exclusion is
collected.

- Lookback Period Length: The period of time prior to each Diagnosis
Event over which a Pre-Diagnosis Emergency Care Event may occur.

- Lookback Period: The range of dates encompassed by `Diagnosis Event
Start Date - Lookback Period Length` over which a Pre-Diagnosis
Emergency Care Event may occur for each Diagnosis Event.

- Potential Lookback Search Period: The range of dates encompassed by
`Search Period Start - Lookback Period Length` to `Search Period Start
+ Search Period Length`.

- Search Region: The geographic region within a health system over
which a search is conducted.

- Prior History Period: The minimum period of time prior to a
Diagnosis Event for which a patient must have some documentation of
healthcare encounters within a health system to qualify as having a
history of receiving care from that health system.




# Parameters

1. Set up Parameters

    a. Search Period Start = 2019-01-01

    b. Search Period Length = 12 months

    c. Exclusion Period Length = -50 years (Length of time prior to
       Search Period Start to look for previous cancer records to
       exclude patients)

    d. Lookback Period Length = -30 days (Length of time an inpatient
       encounter must occur prior to a cancer diagnosis to qualify the
       diagnosis as an emergency)

    e. Prior History Period = 730 days (Length of time prior to cancer
       diagnosis date for which the patient needs to have previous
       records of being in the health system)




# Numerator

## Inclusion

1. Get a list of all cancer records in the Search Period for the
Cancer of Study. This includes (a) Cancer Registry Entries as well
as (b) diagnostic code occurrences for the Study Cancer (*this part is
optional -- the current code does this but later filters these
occurrences out as we are not currently using them to determine cancer
incidence*).

2. Using the same methodology as in Step 1, get a list of all cancer
records in the exclusion period prior to the search period for the
cancer of study.

3. Remove all cancer records from Step 1 for patients that were also
identified in the cancer records in Step 2.

4. From Step 3, add Cancer Registry Entries to a table (select only
the earliest for any given type of cancer for any given patient).
Then, for patients from Step 3 that do not have cancer registry
entries, add the First-Time Diagnostic Code occurrences to that table
by selecting only the earliest diagnostic code occurrences from Step
3. This table now contains the collection of Diagnosis Events within
the study parameters.

5. Select for all potential emergency care events in the Potential
Lookback Search Period. This table now contains the collection of
Emergency Care Events within the study parameters.

6. Select for dyads of Diagnosis Events and Emergency Care Events for
each patient such that the Emergency Care Event falls within the
lookback period for the Diagnosis Event.

## Exclusion

1. From Step 6, select only records for patients who've had previous
records in the health system for at least the Prior History Period
(to ensure that the patients are "enrolled" in the health system).




# Denominator

## Inclusion

1. Get a list of all cancer records in the Search Period for the
Cancer of Study. This includes (a) Cancer Registry Entries as well
as (b) diagnostic code occurrences for the Study Cancer (*this part is
optional -- the current code does this but later filters these
occurrences out as we are not currently using them to determine cancer
incidence*).

2. Using the same methodology as in Step 1, get a list of all cancer
records in the exclusion period prior to the search period for the
cancer of study.

3. Remove all cancer records from Step 1 for patients that were also
identified in the cancer records in Step 2.

4. From Step 3, add Cancer Registry Entries to a table (select only
the earliest for any given type of cancer for any given patient).
Then, for patients from Step 3 that do not have cancer registry
entries, add the First-Time Diagnostic Code occurrences to that table
by selecting only the earliest diagnostic code occurrences from Step
3. This table now contains the collection of Diagnosis Events within
the study parameters.

## Exclusion

1. From Step 4, select only records for patients who've had previous
records in the health system for at least the Prior History Period (to
ensure that the patients are "enrolled" in the health system).




# Output

1. EP Numerator: Output all records from the table created in the
Numerator Exclusion section where the cancer was **identified via
Cancer Registry Entry** (*we are not counting any other types of
cancer diagnoses at this time*)

2. EP Denominator: Output all records from the table created in the
Denominator Exclusion section where the cancer was **identified via
Cancer Registry Entry** (*we are not counting any other types of
cancer diagnoses at this time*)

3. Stage I: Output all records from the table created in the
Denominator Exclusion section where the cancer was identified via
**Cancer Registry Entry** (*we are not counting any other types of
cancer diagnoses at this time*) and the cancer is stage I

4. Stage II: Output all records from the table created in the
Denominator Exclusion section where the cancer was identified via
**Cancer Registry Entry** (*we are not counting any other types of
cancer diagnoses at this time*) and the cancer is stage II

5. Stage III: Output all records from the table created in the
Denominator Exclusion section where the cancer was identified **via
Cancer Registry Entry** (*we are not counting any other types of
cancer diagnoses at this time*) and the cancer is stage III

6. Stage IV: Output all records from the table created in the
Denominator Exclusion section where the cancer was identified **via
Cancer Registry Entry** (*we are not counting any other types of
cancer diagnoses at this time*) and the cancer is stage IV

7. Stage "Other": Output all records from the table created in the
Denominator Exclusion section where the cancer was identified **via
Cancer Registry Entry** (*we are not counting any other types of
cancer diagnoses at this time*) and the cancer is not stage I, II,
III, or IV

8. Early-Stage Presentations: Add up Step 3 and Step 4 tables

9. Late-Stage Presentations: Add up Step 5 and Step 6 tables
