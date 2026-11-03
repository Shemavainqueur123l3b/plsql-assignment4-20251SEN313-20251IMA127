# Implementation Notes

## 1. Problem statement
Educational institutions need to keep student, course, registration and grade information organized. This project provides a small relational database and PL/SQL program units to perform common academic operations.

## 2. Database design
- `STUDENTS`: one row per student; registration number and email are unique.
- `COURSES`: one row per course; course code is unique.
- `REGISTRATIONS`: links a student to a course for an academic year and semester. A student cannot register for the same course twice in the same term.
- `GRADES`: stores one grade for each registration. Scores are constrained to 0–100.

## 3. PL/SQL concepts demonstrated
### Records
A user-defined `RECORD` groups related fields that may have different data types. The demo also declares `students%ROWTYPE`, whose structure corresponds to a complete row in the STUDENTS table.

### Collections
- Associative array: indexed by `PLS_INTEGER`; used to hold student names.
- Nested table: initialized with a constructor and used to hold scores.
- `BULK COLLECT`: fetches multiple query results into collections in one operation.

### Cursors
- Implicit cursor: Oracle creates it automatically for DML and `SELECT INTO`. The bonus procedure demonstrates `SQL%ROWCOUNT`, `SQL%FOUND` and `SQL%NOTFOUND`.
- Explicit cursor: `show_course_roster` declares, opens, fetches and closes a cursor to process multiple rows. `%NOTFOUND` ends the loop and `%ROWCOUNT` counts fetched rows.

### Bulk processing
`bulk_adjust_grades` uses `BULK COLLECT` to retrieve matching grade IDs and calculated scores into associative arrays. `FORALL` sends the updates to SQL in a bulk operation. `SAVE EXCEPTIONS` allows Oracle to report individual DML failures through `SQL%BULK_EXCEPTIONS`.

### Procedures and functions
- `register_student_course` uses IN parameters for input values and an OUT parameter for a status message.
- `record_student_grade` validates and saves a grade.
- `get_student_average` returns a numeric average and raises an application error when no grade records exist.

### Exception handling
The scripts demonstrate:
- Predefined exceptions: `NO_DATA_FOUND` and `DUP_VAL_ON_INDEX`.
- User-defined exceptions: invalid semester and invalid score.
- `RAISE_APPLICATION_ERROR`: returns meaningful application-specific errors.
- `WHEN OTHERS`: catches unexpected errors where appropriate.

## 4. Performance discussion
A normal cursor fetches and processes rows one at a time. `BULK COLLECT` reduces repeated SQL-to-PL/SQL context switches when retrieving multiple rows, while `FORALL` sends DML for collection elements in batches. This can improve performance for larger sets of records. For very large datasets, use a bounded `BULK COLLECT ... LIMIT` loop to control memory consumption; the demonstration uses a small classroom dataset.

## 5. Test plan
The success script tests roster display, registration, grade recording, the stored function, implicit cursor attributes and bulk processing. The error script tests invalid semester, invalid score, a student without grades, and `NO_DATA_FOUND`.

## 6. Limitations and future improvements
- Add authentication and role-based access.
- Add GPA weighting based on course credit hours.
- Add academic-year and semester validation against a term table.
- Add audit history for grade changes.
- Add pagination or a `LIMIT` loop for large bulk operations.
- Review transaction ownership before integrating these procedures into a larger application; this teaching project commits within selected procedures for easy testing.
