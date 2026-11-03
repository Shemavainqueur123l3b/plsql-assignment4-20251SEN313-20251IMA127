-- PROCEDURE 1: REGISTER A STUDENT FOR A COURSE
CREATE OR REPLACE PROCEDURE register_student_course (
    p_student_id    IN  students.student_id%TYPE,
    p_course_id     IN  courses.course_id%TYPE,
    p_academic_year IN  registrations.academic_year%TYPE,
    p_semester      IN  registrations.semester%TYPE,
    p_message       OUT VARCHAR2
) AS
    v_student_count NUMBER;
    v_course_count  NUMBER;
    e_invalid_semester EXCEPTION;
BEGIN
    IF p_semester NOT IN (1, 2) THEN
        RAISE e_invalid_semester;
    END IF;

    SELECT COUNT(*) INTO v_student_count
    FROM students WHERE student_id = p_student_id;

    IF v_student_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Student does not exist.');
    END IF;

    SELECT COUNT(*) INTO v_course_count
    FROM courses WHERE course_id = p_course_id;

    IF v_course_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Course does not exist.');
    END IF;

    INSERT INTO registrations
        (student_id, course_id, academic_year, semester)
    VALUES
        (p_student_id, p_course_id, p_academic_year, p_semester);

    p_message := 'Registration completed. Rows inserted: ' || SQL%ROWCOUNT;
    COMMIT;
EXCEPTION
    WHEN e_invalid_semester THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20003, 'Semester must be 1 or 2.');
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20004,
            'This student is already registered for this course and term.');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/

-- PROCEDURE 2: RECORD OR UPDATE A STUDENT GRADE
CREATE OR REPLACE PROCEDURE record_student_grade (
    p_registration_id IN registrations.registration_id%TYPE,
    p_score           IN grades.score%TYPE,
    p_message         OUT VARCHAR2
) AS
    e_invalid_score EXCEPTION;
    v_grade_letter grades.grade_letter%TYPE;
BEGIN
    IF p_score < 0 OR p_score > 100 THEN
        RAISE e_invalid_score;
    END IF;

    v_grade_letter :=
        CASE
            WHEN p_score >= 80 THEN 'A'
            WHEN p_score >= 70 THEN 'B'
            WHEN p_score >= 60 THEN 'C'
            WHEN p_score >= 50 THEN 'D'
            ELSE 'F'
        END;

    MERGE INTO grades g
    USING (SELECT p_registration_id registration_id FROM dual) src
       ON (g.registration_id = src.registration_id)
    WHEN MATCHED THEN
        UPDATE SET g.score = p_score,
                   g.grade_letter = v_grade_letter,
                   g.recorded_at = SYSDATE
    WHEN NOT MATCHED THEN
        INSERT (registration_id, score, grade_letter)
        VALUES (p_registration_id, p_score, v_grade_letter);

    p_message := 'Grade saved. Rows affected: ' || SQL%ROWCOUNT;
    COMMIT;
EXCEPTION
    WHEN e_invalid_score THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20005, 'Score must be between 0 and 100.');
    WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20006, 'Registration was not found.');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/
