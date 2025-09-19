
CREATE TABLE medication_stock (
    medication_id   SERIAL PRIMARY KEY,
    medication_name VARCHAR(100) NOT NULL,
    quantity        INTEGER      NOT NULL CHECK (quantity >= 0)
);


INSERT INTO medication_stock (medication_name, quantity) VALUES
('Paracetamol 500 mg', 200),
('Insulin Humalog',     45),
('Amlodipine 5 mg',    320),
('Metformin 850 mg',   180),
('Atorvastatin 20 mg',  60),
('Warfarin 3 mg',       25);


/* Create a table medication_stock in your Smart Old Age Home database. The table must have the following attributes:
 1. medication_id (integer, primary key)
 2. medication_name (varchar, not null)
 3. quantity (integer, not null)
 Insert some values into the medication_stock table. 
 Practice SQL with the following:
 */

-- Q!: List all patients name and ages 
SELECT name AS patient_name, age
FROM patients
ORDER BY patient_id;


 -- Q2: List all doctors specializing in 'Cardiology'
SELECT * FROM doctors WHERE specialization = 'Cardiology'; 


 -- Q3: Find all patients that are older than 80
SELECT patient_id, name, age
FROM patients
WHERE age > 80;


-- Q4: List all the patients ordered by their age (youngest first)
SELECT patient_id, name, age
FROM patients
ORDER BY age ASC;


-- Q5: Count the number of doctors in each specialization
SELECT specialization, COUNT(*) AS doctor_count
FROM doctors
GROUP BY specialization
ORDER BY doctor_count DESC;


-- Q6: List patients and their doctors' names
SELECT p.patient_id,
       p.name      AS patient_name,
       d.name      AS doctor_name
FROM patients p
JOIN doctors d ON d.doctor_id = p.doctor_id
ORDER BY p.patient_id;


-- Q7: Show treatments along with patient names and doctor names
SELECT t.treatment_id,
       t.treatment_type,
       t.treatment_time,
       p.name AS patient_name,
       d.name AS doctor_name
FROM treatments t
JOIN patients p ON p.patient_id = t.patient_id
JOIN doctors  d ON d.doctor_id  = p.doctor_id
ORDER BY t.treatment_time;


-- Q8: Count how many patients each doctor supervises
SELECT d.doctor_id,
       d.name,
       COUNT(p.patient_id) AS patients_supervised
FROM doctors d
LEFT JOIN patients p ON p.doctor_id = d.doctor_id
GROUP BY d.doctor_id, d.name
ORDER BY patients_supervised DESC;


-- Q9: List the average age of patients and display it as average_age
SELECT AVG(age) AS average_age
FROM patients;


-- Q10: Find the most common treatment type, and display only that
SELECT treatment_type
FROM treatments
GROUP BY treatment_type
ORDER BY COUNT(*) DESC
LIMIT 1;


-- Q11: List patients who are older than the average age of all patients
SELECT patient_id, name, age
FROM patients
WHERE age > (SELECT AVG(age) FROM patients);


-- Q12: List all the doctors who have more than 5 patients
SELECT d.doctor_id, d.name, COUNT(p.patient_id) AS patient_cnt
FROM doctors d
JOIN patients p ON p.doctor_id = d.doctor_id
GROUP BY d.doctor_id, d.name
HAVING COUNT(p.patient_id) > 5;


-- Q13: List all the treatments that are provided by nurses that work in the morning shift. List patient name as well. 
SELECT t.treatment_id,
       t.treatment_type,
       t.treatment_time,
       n.name AS nurse_name,
       p.name AS patient_name
FROM treatments t
JOIN nurses   n ON n.nurse_id = t.nurse_id
JOIN patients p ON p.patient_id = t.patient_id
WHERE n.shift = 'Morning'
ORDER BY t.treatment_time;


-- Q14: Find the latest treatment for each patient
SELECT DISTINCT ON (patient_id)
       patient_id,
       treatment_id,
       treatment_type,
       treatment_time
FROM treatments
ORDER BY patient_id, treatment_time DESC;


-- Q15: List all the doctors and average age of their patients
SELECT d.doctor_id,
       d.name AS doctor_name,
       ROUND(AVG(p.age), 1) AS avg_patient_age
FROM doctors d
JOIN patients p ON p.doctor_id = d.doctor_id
GROUP BY d.doctor_id, d.name
ORDER BY avg_patient_age DESC;


-- Q16: List the names of the doctors who supervise more than 3 patients
SELECT d.name
FROM doctors d
JOIN patients p ON p.doctor_id = d.doctor_id
GROUP BY d.doctor_id, d.name
HAVING COUNT(p.patient_id) > 3;


-- Q17: List all the patients who have not received any treatments (HINT: Use NOT IN)
SELECT patient_id, name
FROM patients
WHERE patient_id NOT IN (SELECT DISTINCT patient_id FROM treatments);


-- Q18: List all the medicines whose stock (quantity) is less than the average stock
SELECT medication_id, medication_name, quantity
FROM medication_stock
WHERE quantity < (SELECT AVG(quantity) FROM medication_stock);


-- Q19: For each doctor, rank their patients by age
SELECT d.doctor_id,
       d.name AS doctor_name,
       p.patient_id,
       p.name AS patient_name,
       p.age,
       RANK() OVER (PARTITION BY d.doctor_id ORDER BY p.age ASC) AS age_rank
FROM doctors d
JOIN patients p ON p.doctor_id = d.doctor_id
ORDER BY d.doctor_id, age_rank;


-- Q20: For each specialization, find the doctor with the oldest patient
SELECT DISTINCT ON (specialization)
       specialization,
       d.doctor_id,
       d.name AS doctor_name,
       MAX(p.age) AS oldest_patient_age
FROM doctors d
JOIN patients p ON p.doctor_id = d.doctor_id
GROUP BY specialization, d.doctor_id, d.name
ORDER BY specialization, oldest_patient_age DESC;

