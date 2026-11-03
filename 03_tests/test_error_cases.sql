SET SERVEROUTPUT ON;

PROMPT === ERROR TEST 1: INVALID SEMESTER ===
DECLARE
    v_message VARCHAR2(200);
BEGIN
    register_student_course(1, 1, '2026-2027', 3, v_message);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Expected error: ' || SQLERRM);
END;
/

PROMPT === ERROR TEST 2: INVALID GRADE ===
DECLARE
    v_message VARCHAR2(200);
    v_registration_id registrations.registration_id%TYPE;
BEGIN
    SELECT MIN(registration_id) INTO v_registration_id FROM registrations;
    record_student_grade(v_registration_id, 120, v_message);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Expected error: ' || SQLERRM);
END;
/

PROMPT === ERROR TEST 3: FUNCTION FOR STUDENT WITHOUT GRADES ===
DECLARE
    v_student_id students.student_id%TYPE;
    v_average NUMBER;
BEGIN
    SELECT student_id INTO v_student_id
    FROM students WHERE registration_no = '20251SEN099';

    v_average := get_student_average(v_student_id);
    DBMS_OUTPUT.PUT_LINE(v_average);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Expected error: ' || SQLERRM);
END;
/

PROMPT === ERROR TEST 4: PREDEFINED NO_DATA_FOUND ===
DECLARE
    v_student students%ROWTYPE;
BEGIN
    SELECT * INTO v_student
    FROM students
    WHERE registration_no = 'DOES-NOT-EXIST';
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('NO_DATA_FOUND handled successfully.');
END;
/


PROMPT === ERROR TEST 5: PREDEFINED TOO_MANY_ROWS ===
DECLARE
    v_student_id students.student_id%TYPE;
BEGIN
    -- More than one student is returned, but SELECT INTO expects one row.
    SELECT student_id INTO v_student_id
    FROM students;
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('TOO_MANY_ROWS handled successfully.');
END;
/
