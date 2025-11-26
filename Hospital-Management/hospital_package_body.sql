CREATE OR REPLACE PACKAGE BODY hospital_mgmt_pkg AS

    PROCEDURE bulk_load_patients(p_patients IN patient_tbl) IS
    BEGIN
        IF p_patients.COUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Patient collection is empty');
        END IF;
        
        FORALL i IN 1..p_patients.COUNT
            INSERT INTO patients (
                patient_id,
                patient_name,
                age,
                gender,
                admitted
            ) VALUES (
                NVL(p_patients(i).patient_id, patient_seq.NEXTVAL),
                p_patients(i).patient_name,
                p_patients(i).age,
                p_patients(i).gender,
                NVL(p_patients(i).admitted, 'N')
            );
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Successfully loaded ' || p_patients.COUNT || ' patients');
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END bulk_load_patients;

    FUNCTION show_all_patients RETURN SYS_REFCURSOR IS
        patient_cursor SYS_REFCURSOR;
    BEGIN
        OPEN patient_cursor FOR
            SELECT patient_id, patient_name, age, gender, admitted
            FROM patients
            ORDER BY patient_id;
        RETURN patient_cursor;
    END show_all_patients;

    FUNCTION count_admitted RETURN NUMBER IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM patients WHERE admitted = 'Y';
        RETURN v_count;
    END count_admitted;

    PROCEDURE admit_patient(p_patient_id IN NUMBER) IS
        v_exists NUMBER;
    BEGIN
        -- Check if patient exists
        SELECT COUNT(*) INTO v_exists FROM patients WHERE patient_id = p_patient_id;
        IF v_exists = 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'Patient ID ' || p_patient_id || ' not found');
        END IF;
        
        UPDATE patients SET admitted = 'Y' WHERE patient_id = p_patient_id;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Patient ' || p_patient_id || ' admitted successfully');
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END admit_patient;

    PROCEDURE admit_multiple_patients(p_patient_ids IN patient_ids_tbl) IS
    BEGIN
        IF p_patient_ids.COUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20003, 'No patient IDs provided');
        END IF;
        
        -- Bulk update using FORALL
        FORALL i IN 1..p_patient_ids.COUNT
            UPDATE patients SET admitted = 'Y' WHERE patient_id = p_patient_ids(i);
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Admitted ' || SQL%ROWCOUNT || ' patients');
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END admit_multiple_patients;

    PROCEDURE add_doctor(p_doctor_name IN VARCHAR2, p_specialty IN VARCHAR2) IS
    BEGIN
        INSERT INTO doctors (doctor_id, doctor_name, specialty)
        VALUES (doctor_seq.NEXTVAL, p_doctor_name, p_specialty);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Doctor ' || p_doctor_name || ' (' || p_specialty || ') added successfully');
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END add_doctor;

    FUNCTION show_doctors RETURN SYS_REFCURSOR IS
        doctor_cursor SYS_REFCURSOR;
    BEGIN
        OPEN doctor_cursor FOR
            SELECT doctor_id, doctor_name, specialty FROM doctors ORDER BY doctor_id;
        RETURN doctor_cursor;
    END show_doctors;

    PROCEDURE clear_test_data IS
    BEGIN
        DELETE FROM patients WHERE patient_name LIKE 'Test%';
        DELETE FROM doctors WHERE doctor_name LIKE 'Test%';
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Test data cleared');
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END clear_test_data;

END hospital_mgmt_pkg;
/

-- Verify package body creation
SELECT object_name, object_type, status
FROM user_objects
WHERE object_name = 'HOSPITAL_MGMT_PKG' AND object_type = 'PACKAGE BODY';
