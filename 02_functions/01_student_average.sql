-- FUNCTION: RETURN A STUDENT'S ARITHMETIC AVERAGE SCORE
CREATE OR REPLACE FUNCTION get_student_average (
    p_student_id IN students.student_id%TYPE
) RETURN NUMBER
AS
    v_average NUMBER(5,2);
BEGIN
    SELECT AVG(g.score)
      INTO v_average
      FROM grades g
      JOIN registrations r
        ON r.registration_id = g.registration_id
     WHERE r.student_id = p_student_id;

    IF v_average IS NULL THEN
        RAISE NO_DATA_FOUND;
    END IF;

    RETURN ROUND(v_average, 2);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20020,
            'No grade records found for this student.');
END;
/
