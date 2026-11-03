-- BULK COLLECT + FORALL
-- Increase scores by a supplied amount for all grades below a threshold.
CREATE OR REPLACE PROCEDURE bulk_adjust_grades (
    p_threshold IN NUMBER,
    p_increment IN NUMBER
) AS
    TYPE t_grade_ids IS TABLE OF grades.grade_id%TYPE
        INDEX BY PLS_INTEGER;
    TYPE t_scores IS TABLE OF grades.score%TYPE
        INDEX BY PLS_INTEGER;

    v_grade_ids t_grade_ids;
    v_new_scores t_scores;
BEGIN
    IF p_threshold < 0 OR p_threshold > 100
       OR p_increment < 0 THEN
        RAISE_APPLICATION_ERROR(-20010,
            'Threshold must be 0-100 and increment cannot be negative.');
    END IF;

    SELECT grade_id, LEAST(100, score + p_increment)
    BULK COLLECT INTO v_grade_ids, v_new_scores
    FROM grades
    WHERE score < p_threshold;

    IF v_grade_ids.COUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No grades matched the threshold.');
        RETURN;
    END IF;

    FORALL i IN 1 .. v_grade_ids.COUNT SAVE EXCEPTIONS
        UPDATE grades
           SET score = v_new_scores(i),
               grade_letter =
                   CASE
                       WHEN v_new_scores(i) >= 80 THEN 'A'
                       WHEN v_new_scores(i) >= 70 THEN 'B'
                       WHEN v_new_scores(i) >= 60 THEN 'C'
                       WHEN v_new_scores(i) >= 50 THEN 'D'
                       ELSE 'F'
                   END,
               recorded_at = SYSDATE
         WHERE grade_id = v_grade_ids(i);

    DBMS_OUTPUT.PUT_LINE('Bulk rows updated: ' || SQL%ROWCOUNT);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -24381 THEN
            DBMS_OUTPUT.PUT_LINE('One or more FORALL DML operations failed.');
            FOR i IN 1 .. SQL%BULK_EXCEPTIONS.COUNT LOOP
                DBMS_OUTPUT.PUT_LINE(
                    'Error index: ' || SQL%BULK_EXCEPTIONS(i).ERROR_INDEX ||
                    ', Oracle error: ' || SQL%BULK_EXCEPTIONS(i).ERROR_CODE
                );
            END LOOP;
        ELSE
            ROLLBACK;
            RAISE;
        END IF;
END;
/
