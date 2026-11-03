# INSY 8311 – Group Assignment IV

## Student Registration and Grading Management System

**Course:** Database Development with PL/SQL  
**Database:** Oracle Database 26ai (SQL Developer)  
**Group members:**

* Shema Vainqueur — 20251SEN313
* Cyubahiro Israel — 20251IMA127

## Project overview

This project manages students, courses, course registrations and grades. It demonstrates records, collections, implicit and explicit cursors, `BULK COLLECT`, `FORALL`, stored procedures, functions and exception handling.

## Repository structure

```text
INSY8311\_Group\_Assignment\_IV/
├── README.md
├── .gitignore
├── 00\_schema/
│   ├── 01\_create\_tables.sql
│   └── 02\_insert\_sample\_data.sql
├── 01\_procedures/
│   ├── 01\_registration\_procedures.sql
│   ├── 02\_cursor\_procedures.sql
│   └── 03\_bulk\_processing.sql
├── 02\_functions/
│   └── 01\_student\_average.sql
├── 03\_tests/
│   ├── test\_success\_cases.sql
│   └── test\_error\_cases.sql
├── 04\_demos/
│   └── records\_and\_collections.sql
├── docs/
│   └── IMPLEMENTATION\_NOTES.md
└── screenshots/
```

## Setup and execution

Run the scripts in this order in Oracle SQL Developer:

1. Open a connection to your Oracle 26ai database.
2. Open `00\_schema/01\_create\_tables.sql` and run it as a script (F5).
3. Run `00\_schema/02\_insert\_sample\_data.sql`.
4. Run all files in `01\_procedures/`.
5. Run all files in `02\_functions/`.
6. Run `03\_tests/test\_success\_cases.sql` , `test\_records\_and\_collections` .
7. Run `03\_tests/test\_error\_cases.sql`.

Enable output before running PL/SQL:

```sql
SET SERVEROUTPUT ON;
```

**Important:** Run the schema script only once unless you first drop the existing project tables. The scripts are designed for a clean project schema.

## Main features

* Register a student for a course.
* Record or update a student's grade.
* Display a course roster using an explicit cursor.
* Calculate a student's average grade using a stored function.
* Apply a bulk grade adjustment using `BULK COLLECT` and `FORALL`.
* Demonstrate records, `%ROWTYPE`, associative arrays and nested tables.
* Handle missing records, duplicate registrations and invalid marks.







