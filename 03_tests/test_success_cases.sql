SET SERVEROUTPUT ON;

PROMPT === TEST 1: DISPLAY COURSE ROSTER ===
BEGIN
    show_course_roster('INSY8311');
END;
/

PROMPT === TEST 2: REGISTER A STUDENT ===
DECLARE
    v_message VARCHAR2(200);
    v_student_id students.student_id%TYPE;
    v_course_id courses.course_id%TYPE;
BEGIN
    SELECT student_id INTO v_student_id
    FROM students WHERE registration_no = '20251SEN099';

    SELECT course_id INTO v_course_id
    FROM courses WHERE course_code = 'MATH8101';

    register_student_course(
        v_student_id, v_course_id, '2026-2027', 1, v_message
    );
    DBMS_OUTPUT.PUT_LINE(v_message);
END;
/

PROMPT === TEST 3: RECORD A GRADE ===
DECLARE
    v_registration_id registrations.registration_id%TYPE;
    v_message VARCHAR2(200);
BEGIN
    SELECT r.registration_id INTO v_registration_id
    FROM registrations r
    JOIN students s ON s.student_id = r.student_id
    JOIN courses c ON c.course_id = r.course_id
    WHERE s.registration_no = '20251SEN099'
      AND c.course_code = 'MATH8101';

    record_student_grade(v_registration_id, 88, v_message);
    DBMS_OUTPUT.PUT_LINE(v_message);
END;
/

PROMPT === TEST 4: CALL THE STORED FUNCTION ===
DECLARE
    v_student_id students.student_id%TYPE;
    v_average NUMBER;
BEGIN
    SELECT student_id INTO v_student_id
    FROM students WHERE registration_no = '20251SEN313';

    v_average := get_student_average(v_student_id);
    DBMS_OUTPUT.PUT_LINE('Student average: ' || v_average);
END;
/

PROMPT === TEST 5: IMPLICIT CURSOR ATTRIBUTES ===
BEGIN
    add_bonus_to_course('INSY8311', 1);
END;
/

PROMPT === TEST 6: BULK PROCESSING ===
BEGIN
    bulk_adjust_grades(75, 2);
END;
/
