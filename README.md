# INSY 8311 – Group Assignment IV
## Student Registration and Grading Management System

**Course:** Database Development with PL/SQL  
**Database:** Oracle Database 26ai (SQL Developer)  
**Group members:**
- Shema Vainqueur — 20251SEN313
- Cyubahiro Israel — 20251IMA127

## Project overview
This project manages students, courses, course registrations and grades. It demonstrates records, collections, implicit and explicit cursors, `BULK COLLECT`, `FORALL`, stored procedures, functions and exception handling.

## Repository structure
```text
INSY8311_Group_Assignment_IV/
├── README.md
├── .gitignore
├── 00_schema/
│   ├── 01_create_tables.sql
│   └── 02_insert_sample_data.sql
├── 01_procedures/
│   ├── 01_registration_procedures.sql
│   ├── 02_cursor_procedures.sql
│   └── 03_bulk_processing.sql
├── 02_functions/
│   └── 01_student_average.sql
├── 03_tests/
│   ├── test_success_cases.sql
│   └── test_error_cases.sql
├── 04_demos/
│   └── records_and_collections.sql
├── docs/
│   └── IMPLEMENTATION_NOTES.md
└── screenshots/
```

## Setup and execution
Run the scripts in this order in Oracle SQL Developer:

1. Open a connection to your Oracle 26ai database.
2. Open `00_schema/01_create_tables.sql` and run it as a script (F5).
3. Run `00_schema/02_insert_sample_data.sql`.
4. Run all files in `01_procedures/`.
5. Run all files in `02_functions/`.
6. Run `04_demos/records_and_collections.sql`.
7. Run `03_tests/test_success_cases.sql`.
8. Run `03_tests/test_error_cases.sql`.

Enable output before running PL/SQL:
```sql
SET SERVEROUTPUT ON;
```

**Important:** Run the schema script only once unless you first drop the existing project tables. The scripts are designed for a clean project schema.

## Main features
- Register a student for a course.
- Record or update a student's grade.
- Display a course roster using an explicit cursor.
- Calculate a student's average grade using a stored function.
- Apply a bulk grade adjustment using `BULK COLLECT` and `FORALL`.
- Demonstrate records, `%ROWTYPE`, associative arrays and nested tables.
- Handle missing records, duplicate registrations and invalid marks.


