-- SAMPLE DATA
INSERT INTO students (registration_no, first_name, last_name, email)
VALUES ('20251SEN313', 'Shema', 'Vainqueur', 'vainqueur.shema@example.com');

INSERT INTO students (registration_no, first_name, last_name, email)
VALUES ('20251IMA127', 'Cyubahiro', 'Israel', 'cyubahiro.israel@example.com');

INSERT INTO students (registration_no, first_name, last_name, email)
VALUES ('20251SEN099', 'Aline', 'Uwase', 'aline.uwase@example.com');

INSERT INTO courses (course_code, course_name, credit_hours)
VALUES ('INSY8311', 'Database Development with PL/SQL', 3);

INSERT INTO courses (course_code, course_name, credit_hours)
VALUES ('INSY8212', 'Software Engineering', 3);

INSERT INTO courses (course_code, course_name, credit_hours)
VALUES ('MATH8101', 'Applied Mathematics', 2);

INSERT INTO registrations (student_id, course_id, academic_year, semester)
SELECT s.student_id, c.course_id, '2026-2027', 1
FROM students s CROSS JOIN courses c
WHERE s.registration_no = '20251SEN313'
  AND c.course_code IN ('INSY8311', 'INSY8212');

INSERT INTO registrations (student_id, course_id, academic_year, semester)
SELECT s.student_id, c.course_id, '2026-2027', 1
FROM students s CROSS JOIN courses c
WHERE s.registration_no = '20251IMA127'
  AND c.course_code IN ('INSY8311', 'MATH8101');

INSERT INTO registrations (student_id, course_id, academic_year, semester)
SELECT s.student_id, c.course_id, '2026-2027', 1
FROM students s CROSS JOIN courses c
WHERE s.registration_no = '20251SEN099'
  AND c.course_code = 'INSY8212';

INSERT INTO grades (registration_id, score, grade_letter)
SELECT r.registration_id, 86, 'A'
FROM registrations r
JOIN students s ON s.student_id = r.student_id
JOIN courses c ON c.course_id = r.course_id
WHERE s.registration_no = '20251SEN313' AND c.course_code = 'INSY8311';

INSERT INTO grades (registration_id, score, grade_letter)
SELECT r.registration_id, 78, 'B'
FROM registrations r
JOIN students s ON s.student_id = r.student_id
JOIN courses c ON c.course_id = r.course_id
WHERE s.registration_no = '20251SEN313' AND c.course_code = 'INSY8212';

INSERT INTO grades (registration_id, score, grade_letter)
SELECT r.registration_id, 91, 'A'
FROM registrations r
JOIN students s ON s.student_id = r.student_id
JOIN courses c ON c.course_id = r.course_id
WHERE s.registration_no = '20251IMA127' AND c.course_code = 'INSY8311';

INSERT INTO grades (registration_id, score, grade_letter)
SELECT r.registration_id, 69, 'C'
FROM registrations r
JOIN students s ON s.student_id = r.student_id
JOIN courses c ON c.course_id = r.course_id
WHERE s.registration_no = '20251IMA127' AND c.course_code = 'MATH8101';

COMMIT;
PROMPT Sample data inserted.
