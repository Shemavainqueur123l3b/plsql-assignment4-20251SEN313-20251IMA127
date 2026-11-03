-- EXPLICIT CURSOR: DISPLAY ALL STUDENTS REGISTERED IN A COURSE
CREATE OR REPLACE PROCEDURE show_course_roster (
    p_course_code IN courses.course_code%TYPE
) AS
    CURSOR c_roster IS
        SELECT s.registration_no, s.first_name, s.last_name,
               c.course_code, r.academic_year, r.semester
        FROM registrations r
        JOIN students s ON s.student_id = r.student_id
        JOIN courses c ON c.course_id = r.course_id
        WHERE c.course_code = p_course_code
        ORDER BY s.last_name, s.first_name;
    v_row c_roster%ROWTYPE;
BEGIN
    OPEN c_roster;
    LOOP
        FETCH c_roster INTO v_row;
        EXIT WHEN c_roster%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
            v_row.registration_no || ' | ' ||
            v_row.first_name || ' ' || v_row.last_name ||
            ' | ' || v_row.course_code ||
            ' | ' || v_row.academic_year ||
            ' | Semester ' || v_row.semester
        );
    END LOOP;

    IF c_roster%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No students registered for ' || p_course_code);
    END IF;

    CLOSE c_roster;
EXCEPTION
    WHEN OTHERS THEN
        IF c_roster%ISOPEN THEN
            CLOSE c_roster;
        END IF;
        RAISE;
END;
/

-- IMPLICIT CURSOR ATTRIBUTES: UPDATE AND REPORT ROWS AFFECTED
CREATE OR REPLACE PROCEDURE add_bonus_to_course (
    p_course_code IN courses.course_code%TYPE,
    p_bonus       IN NUMBER
) AS
BEGIN
    UPDATE grades g
       SET g.score = LEAST(100, g.score + p_bonus),
           g.grade_letter =
               CASE
                   WHEN LEAST(100, g.score + p_bonus) >= 80 THEN 'A'
                   WHEN LEAST(100, g.score + p_bonus) >= 70 THEN 'B'
                   WHEN LEAST(100, g.score + p_bonus) >= 60 THEN 'C'
                   WHEN LEAST(100, g.score + p_bonus) >= 50 THEN 'D'
                   ELSE 'F'
               END
     WHERE EXISTS (
         SELECT 1
         FROM registrations r
         JOIN courses c ON c.course_id = r.course_id
         WHERE r.registration_id = g.registration_id
           AND c.course_code = p_course_code
     );

    DBMS_OUTPUT.PUT_LINE('Rows updated: ' || SQL%ROWCOUNT);

    IF SQL%FOUND THEN
        DBMS_OUTPUT.PUT_LINE('At least one grade was updated.');
    ELSIF SQL%NOTFOUND THEN
        DBMS_OUTPUT.PUT_LINE('No matching grades were found.');
    END IF;

    COMMIT;
END;
/
