PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS testing_event;
DROP TABLE IF EXISTS technician_expertise;
DROP TABLE IF EXISTS airplane_location;
DROP TABLE IF EXISTS traffic_controller;
DROP TABLE IF EXISTS technician;
DROP TABLE IF EXISTS airport_employee;
DROP TABLE IF EXISTS test;
DROP TABLE IF EXISTS airplane;
DROP TABLE IF EXISTS hangar;
DROP TABLE IF EXISTS plane_model;

CREATE TABLE plane_model (
    model_no TEXT PRIMARY KEY,
    model_name TEXT NOT NULL,
    manufacturer TEXT,
    max_capacity INTEGER
);

CREATE TABLE airplane (
    plane_no TEXT PRIMARY KEY,
    model_no TEXT NOT NULL,
    capacity INTEGER,
    production_year INTEGER,
    status TEXT,
    FOREIGN KEY (model_no) REFERENCES plane_model(model_no)
);

CREATE TABLE hangar (
    hangar_no TEXT PRIMARY KEY,
    location TEXT,
    hangar_capacity INTEGER
);

CREATE TABLE airplane_location (
    location_id INTEGER PRIMARY KEY,
    plane_no TEXT,
    hangar_no TEXT,
    in_date TEXT,
    out_date TEXT,
    FOREIGN KEY (plane_no) REFERENCES airplane(plane_no),
    FOREIGN KEY (hangar_no) REFERENCES hangar(hangar_no)
);

CREATE TABLE airport_employee (
    ssn TEXT PRIMARY KEY,
    emp_name TEXT NOT NULL,
    phone TEXT,
    salary REAL,
    union_no TEXT NOT NULL,
    emp_type TEXT
);

CREATE TABLE technician (
    ssn TEXT PRIMARY KEY,
    experience_year INTEGER,
    FOREIGN KEY (ssn) REFERENCES airport_employee(ssn)
);

CREATE TABLE traffic_controller (
    ssn TEXT PRIMARY KEY,
    last_medical_exam TEXT,
    FOREIGN KEY (ssn) REFERENCES airport_employee(ssn)
);

CREATE TABLE test (
    test_no TEXT PRIMARY KEY,
    test_name TEXT,
    max_score INTEGER,
    test_frequency TEXT
);

CREATE TABLE technician_expertise (
    ssn TEXT,
    model_no TEXT,
    PRIMARY KEY (ssn, model_no),
    FOREIGN KEY (ssn) REFERENCES technician(ssn),
    FOREIGN KEY (model_no) REFERENCES plane_model(model_no)
);

CREATE TABLE testing_event (
    event_id INTEGER PRIMARY KEY,
    plane_no TEXT,
    ssn TEXT,
    test_no TEXT,
    test_date TEXT,
    hours_spent REAL,
    score REAL,
    FOREIGN KEY (plane_no) REFERENCES airplane(plane_no),
    FOREIGN KEY (ssn) REFERENCES technician(ssn),
    FOREIGN KEY (test_no) REFERENCES test(test_no)
);

INSERT INTO plane_model VALUES ('A320', 'Airbus A320', 'Airbus', 180);
INSERT INTO plane_model VALUES ('B737', 'Boeing 737', 'Boeing', 190);
INSERT INTO plane_model VALUES ('E190', 'Embraer 190', 'Embraer', 114);
INSERT INTO plane_model VALUES ('A330', 'Airbus A330', 'Airbus', 300);

INSERT INTO airplane VALUES ('P1001', 'A320', 170, 2016, 'Active');
INSERT INTO airplane VALUES ('P1002', 'B737', 185, 2018, 'Active');
INSERT INTO airplane VALUES ('P1003', 'E190', 110, 2015, 'Maintenance');
INSERT INTO airplane VALUES ('P1004', 'A330', 290, 2020, 'Active');
INSERT INTO airplane VALUES ('P1005', 'A320', 175, 2017, 'Maintenance');

INSERT INTO hangar VALUES ('H01', 'North Zone', 5);
INSERT INTO hangar VALUES ('H02', 'East Zone', 4);
INSERT INTO hangar VALUES ('H03', 'Maintenance Zone', 6);

INSERT INTO airplane_location VALUES (1, 'P1001', 'H01', '2026-05-01', '2026-05-05');
INSERT INTO airplane_location VALUES (2, 'P1002', 'H02', '2026-05-03', NULL);
INSERT INTO airplane_location VALUES (3, 'P1003', 'H03', '2026-05-07', NULL);
INSERT INTO airplane_location VALUES (4, 'P1004', 'H01', '2026-05-10', '2026-05-12');
INSERT INTO airplane_location VALUES (5, 'P1005', 'H03', '2026-05-14', NULL);

INSERT INTO airport_employee VALUES ('111', 'Ahmed Ali', '0501111111', 4500, 'U1001', 'Technician');
INSERT INTO airport_employee VALUES ('222', 'Omar Hassan', '0502222222', 5200, 'U1002', 'Technician');
INSERT INTO airport_employee VALUES ('333', 'Sara Khaled', NULL, 6000, 'U1003', 'Traffic Controller');
INSERT INTO airport_employee VALUES ('444', 'Mona Sami', '0504444444', 5800, 'U1004', 'Traffic Controller');
INSERT INTO airport_employee VALUES ('555', 'Faisal Saleh', NULL, 4000, 'U1005', 'Airport Employee');

INSERT INTO technician VALUES ('111', 5);
INSERT INTO technician VALUES ('222', 8);

INSERT INTO traffic_controller VALUES ('333', '2026-01-10');
INSERT INTO traffic_controller VALUES ('444', '2026-03-15');

INSERT INTO test VALUES ('T01', 'Engine Safety Test', 100, 'Monthly');
INSERT INTO test VALUES ('T02', 'Landing Gear Test', 100, 'Quarterly');
INSERT INTO test VALUES ('T03', 'Navigation System Test', 100, 'Monthly');
INSERT INTO test VALUES ('T04', 'Fuel System Test', 100, 'Yearly');

INSERT INTO technician_expertise VALUES ('111', 'A320');
INSERT INTO technician_expertise VALUES ('111', 'B737');
INSERT INTO technician_expertise VALUES ('222', 'A330');
INSERT INTO technician_expertise VALUES ('222', 'E190');
INSERT INTO technician_expertise VALUES ('222', 'A320');

INSERT INTO testing_event VALUES (1, 'P1001', '111', 'T01', '2026-05-02', 3, 88);
INSERT INTO testing_event VALUES (2, 'P1002', '111', 'T02', '2026-05-04', 4, 92);
INSERT INTO testing_event VALUES (3, 'P1003', '222', 'T01', '2026-05-08', 5, 75);
INSERT INTO testing_event VALUES (4, 'P1004', '222', 'T03', '2026-05-11', 2, 95);
INSERT INTO testing_event VALUES (5, 'P1005', '111', 'T04', '2026-05-15', 6, 70);
INSERT INTO testing_event VALUES (6, 'P1001', '222', 'T03', '2026-05-17', 3, 90);

/* Management Queries */

SELECT plane_no, model_no, capacity, status
FROM airplane
ORDER BY capacity DESC;

SELECT plane_no, capacity
FROM airplane
WHERE capacity BETWEEN 170 AND 200;

SELECT emp_name, emp_type
FROM airport_employee
WHERE emp_name LIKE '%a%';

SELECT UPPER(emp_name) AS employee_upper,
       LOWER(emp_type) AS type_lower
FROM airport_employee;

SELECT emp_name, LENGTH(emp_name) AS name_length
FROM airport_employee;

SELECT plane_no,
       SUBSTR(plane_no, 1, 1) AS first_character,
       SUBSTR(plane_no, 2, 4) AS plane_number
FROM airplane;

SELECT emp_name,
       INSTR(emp_name, 'a') AS position_of_a
FROM airport_employee;

SELECT ROUND(AVG(score), 2) AS average_test_score
FROM testing_event;

SELECT emp_name,
       IFNULL(phone, 'No Phone Number') AS phone_status
FROM airport_employee;

SELECT plane_no,
       COALESCE(out_date, 'Still in Hangar') AS hangar_status
FROM airplane_location;

SELECT plane_no,
       capacity,
       NULLIF(capacity, 170) AS capacity_if_not_170
FROM airplane;

SELECT plane_no, score,
       CASE
           WHEN score >= 90 THEN 'Excellent'
           WHEN score >= 80 THEN 'Good'
           ELSE 'Needs Maintenance Review'
       END AS test_result
FROM testing_event;

SELECT COUNT(*) AS total_tests,
       MAX(score) AS highest_score,
       MIN(score) AS lowest_score,
       SUM(hours_spent) AS total_hours
FROM testing_event;

SELECT test_no,
       COUNT(*) AS number_of_tests,
       ROUND(AVG(score), 2) AS average_score
FROM testing_event
GROUP BY test_no;

SELECT ssn,
       SUM(hours_spent) AS total_hours
FROM testing_event
GROUP BY ssn
HAVING SUM(hours_spent) > 5;

SELECT a.plane_no,
       m.model_name,
       m.manufacturer,
       a.status
FROM airplane a
JOIN plane_model m
ON a.model_no = m.model_no;

SELECT ev.event_id,
       a.plane_no,
       e.emp_name,
       t.test_name,
       ev.score
FROM testing_event ev
JOIN airplane a
ON ev.plane_no = a.plane_no
JOIN airport_employee e
ON ev.ssn = e.ssn
JOIN test t
ON ev.test_no = t.test_no;

SELECT plane_no, score
FROM testing_event
WHERE score > (
    SELECT AVG(score)
    FROM testing_event
);

SELECT event_id,
       strftime('%d-%m-%Y', test_date) AS formatted_test_date
FROM testing_event;

SELECT emp_name, 'Technician' AS staff_category
FROM airport_employee
WHERE emp_type = 'Technician'
UNION
SELECT emp_name, 'Traffic Controller' AS staff_category
FROM airport_employee
WHERE emp_type = 'Traffic Controller';
