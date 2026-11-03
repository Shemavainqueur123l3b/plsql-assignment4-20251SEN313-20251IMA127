SET SERVEROUTPUT ON;

DECLARE
    -- User-defined record: fields may have different data types.
    TYPE t_student_summary IS RECORD (
        registration_no students.registration_no%TYPE,
        full_name       VARCHAR2(120),
        enrollment_date DATE
    );
    v_summary t_student_summary;

    -- %ROWTYPE record: structure follows the STUDENTS table row.
    v_student students%ROWTYPE;

    -- Associative array collection.
    TYPE t_name_array IS TABLE OF VARCHAR2(120)
        INDEX BY PLS_INTEGER;
    v_names t_name_array;

    -- Nested table collection.
    TYPE t_score_list IS TABLE OF NUMBER;
    v_scores t_score_list := t_score_list(86, 78, 91);

    v_index PLS_INTEGER;
BEGIN
    SELECT * INTO v_student
    FROM students
    WHERE registration_no = '20251SEN313';

    v_summary.registration_no := v_student.registration_no;
    v_summary.full_name := v_student.first_name || ' ' || v_student.last_name;
    v_summary.enrollment_date := v_student.enrollment_date;

    DBMS_OUTPUT.PUT_LINE('USER-DEFINED RECORD');
    DBMS_OUTPUT.PUT_LINE(v_summary.registration_no || ' - ' ||
                         v_summary.full_name);

    DBMS_OUTPUT.PUT_LINE('%ROWTYPE RECORD');
    DBMS_OUTPUT.PUT_LINE('Email: ' || v_student.email);

    SELECT first_name || ' ' || last_name
    BULK COLLECT INTO v_names
    FROM students
    ORDER BY student_id;

    DBMS_OUTPUT.PUT_LINE('ASSOCIATIVE ARRAY populated with BULK COLLECT');
    v_index := v_names.FIRST;
    WHILE v_index IS NOT NULL LOOP
        DBMS_OUTPUT.PUT_LINE(v_names(v_index));
        v_index := v_names.NEXT(v_index);
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('NESTED TABLE VALUES');
    FOR i IN 1 .. v_scores.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('Score: ' || v_scores(i));
    END LOOP;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('The requested student does not exist.');
END;
/
