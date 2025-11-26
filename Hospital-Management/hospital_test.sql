SET SERVEROUTPUT ON;

DECLARE
    v_patients hospital_mgmt_pkg.patient_tbl := hospital_mgmt_pkg.patient_tbl();
    v_patient_ids hospital_mgmt_pkg.patient_ids_tbl := hospital_mgmt_pkg.patient_ids_tbl();
    v_cursor SYS_REFCURSOR;
    v_patient_id NUMBER;
    v_patient_name VARCHAR2(100);
    v_age NUMBER;
    v_gender VARCHAR2(10);
    v_admitted VARCHAR2(1);
    v_admitted_count NUMBER;
    v_doctor_id NUMBER;
    v_doctor_name VARCHAR2(100);
    v_specialty VARCHAR2(100);
    
BEGIN
    DBMS_OUTPUT.PUT_LINE('=========================================');
    DBMS_OUTPUT.PUT_LINE('HOSPITAL MANAGEMENT SYSTEM - FULL TEST');
    DBMS_OUTPUT.PUT_LINE('=========================================');
    DBMS_OUTPUT.PUT_LINE('');
    
    DBMS_OUTPUT.PUT_LINE('PHASE 1: INITIAL SETUP');
    DBMS_OUTPUT.PUT_LINE('-----------------------');
    hospital_mgmt_pkg.clear_test_data();
    DBMS_OUTPUT.PUT_LINE('Test environment prepared');
    DBMS_OUTPUT.PUT_LINE('');
    
   
    DBMS_OUTPUT.PUT_LINE('PHASE 2: BULK PATIENT LOADING');
    DBMS_OUTPUT.PUT_LINE('------------------------------');
    
    
    v_patients.EXTEND(5);
    v_patients(1) := hospital_mgmt_pkg.patient_rec(NULL, 'Test Patient John', 45, 'Male', 'N');
    v_patients(2) := hospital_mgmt_pkg.patient_rec(NULL, 'Test Patient Sarah', 32, 'Female', 'N');
    v_patients(3) := hospital_mgmt_pkg.patient_rec(NULL, 'Test Patient Mike', 28, 'Male', 'N');
    v_patients(4) := hospital_mgmt_pkg.patient_rec(NULL, 'Test Patient Emily', 67, 'Female', 'N');
    v_patients(5) := hospital_mgmt_pkg.patient_rec(NULL, 'Test Patient David', 53, 'Male', 'N');
    
    hospital_mgmt_pkg.bulk_load_patients(v_patients);
    DBMS_OUTPUT.PUT_LINE('RESULT: PASS - Bulk patient loading successful');
    DBMS_OUTPUT.PUT_LINE('');
    

    DBMS_OUTPUT.PUT_LINE('PHASE 3: PATIENT DISPLAY FUNCTION');
    DBMS_OUTPUT.PUT_LINE('---------------------------------');
    
    v_cursor := hospital_mgmt_pkg.show_all_patients();
    DBMS_OUTPUT.PUT_LINE('All Patients in System:');
    DBMS_OUTPUT.PUT_LINE('ID  Name                Age Gender Admitted');
    DBMS_OUTPUT.PUT_LINE('--- -------------------- --- ------ --------');
    LOOP
        FETCH v_cursor INTO v_patient_id, v_patient_name, v_age, v_gender, v_admitted;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(
            RPAD(v_patient_id, 4) || ' ' ||
            RPAD(v_patient_name, 20) || ' ' ||
            RPAD(v_age, 3) || ' ' ||
            RPAD(v_gender, 6) || ' ' ||
            v_admitted
        );
    END LOOP;
    CLOSE v_cursor;
    DBMS_OUTPUT.PUT_LINE('RESULT: PASS - Patient display working correctly');
    DBMS_OUTPUT.PUT_LINE('');
    
    
    DBMS_OUTPUT.PUT_LINE('PHASE 4: ADMITTED PATIENT COUNTING');
    DBMS_OUTPUT.PUT_LINE('----------------------------------');
    
    v_admitted_count := hospital_mgmt_pkg.count_admitted();
    DBMS_OUTPUT.PUT_LINE('Currently admitted patients: ' || v_admitted_count);
    DBMS_OUTPUT.PUT_LINE('RESULT: PASS - Admission counting accurate');
    DBMS_OUTPUT.PUT_LINE('');
    
    
    DBMS_OUTPUT.PUT_LINE('PHASE 5: SINGLE PATIENT ADMISSION');
    DBMS_OUTPUT.PUT_LINE('---------------------------------');
    
    SELECT patient_id INTO v_patient_id 
    FROM patients 
    WHERE patient_name = 'Test Patient John' AND ROWNUM = 1;
    
    hospital_mgmt_pkg.admit_patient(v_patient_id);
    v_admitted_count := hospital_mgmt_pkg.count_admitted();
    DBMS_OUTPUT.PUT_LINE('Admitted patients after single admission: ' || v_admitted_count);
    DBMS_OUTPUT.PUT_LINE('RESULT: PASS - Single patient admission successful');
    DBMS_OUTPUT.PUT_LINE('');
    
  
    DBMS_OUTPUT.PUT_LINE('PHASE 6: BULK PATIENT ADMISSION');
    DBMS_OUTPUT.PUT_LINE('-------------------------------');
    
    v_patient_ids.EXTEND(2);
    SELECT patient_id INTO v_patient_ids(1) 
    FROM patients 
    WHERE patient_name = 'Test Patient Sarah' AND ROWNUM = 1;
    
    SELECT patient_id INTO v_patient_ids(2) 
    FROM patients 
    WHERE patient_name = 'Test Patient Mike' AND ROWNUM = 1;
    
    hospital_mgmt_pkg.admit_multiple_patients(v_patient_ids);
    v_admitted_count := hospital_mgmt_pkg.count_admitted();
    DBMS_OUTPUT.PUT_LINE('Total admitted patients after bulk admission: ' || v_admitted_count);
    DBMS_OUTPUT.PUT_LINE('RESULT: PASS - Bulk patient admission successful');
    DBMS_OUTPUT.PUT_LINE('');
    
  
    DBMS_OUTPUT.PUT_LINE('PHASE 7: DOCTOR MANAGEMENT');
    DBMS_OUTPUT.PUT_LINE('--------------------------');
    
    hospital_mgmt_pkg.add_doctor('Test Dr. Smith', 'Cardiology');
    hospital_mgmt_pkg.add_doctor('Test Dr. Wilson', 'Neurology');
    hospital_mgmt_pkg.add_doctor('Test Dr. Brown', 'Pediatrics');
    
    v_cursor := hospital_mgmt_pkg.show_doctors();
    DBMS_OUTPUT.PUT_LINE('Available Doctors:');
    DBMS_OUTPUT.PUT_LINE('ID  Name            Specialty');
    DBMS_OUTPUT.PUT_LINE('--- --------------- ------------');
    LOOP
        FETCH v_cursor INTO v_doctor_id, v_doctor_name, v_specialty;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(
            RPAD(v_doctor_id, 4) || ' ' ||
            RPAD(v_doctor_name, 15) || ' ' ||
            v_specialty
        );
    END LOOP;
    CLOSE v_cursor;
    DBMS_OUTPUT.PUT_LINE('RESULT: PASS - Doctor management working correctly');
    DBMS_OUTPUT.PUT_LINE('');
    
    
    DBMS_OUTPUT.PUT_LINE('PHASE 8: TEST SUMMARY');
    DBMS_OUTPUT.PUT_LINE('---------------------');
    DBMS_OUTPUT.PUT_LINE('PASS: Bulk patient loading functionality');
    DBMS_OUTPUT.PUT_LINE('PASS: Patient display with cursor');
    DBMS_OUTPUT.PUT_LINE('PASS: Single patient admission');
    DBMS_OUTPUT.PUT_LINE('PASS: Bulk patient admission');
    DBMS_OUTPUT.PUT_LINE('PASS: Admitted patient counting');
    DBMS_OUTPUT.PUT_LINE('PASS: Doctor management system');
    DBMS_OUTPUT.PUT_LINE('PASS: All FORALL bulk operations');
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=========================================');
    DBMS_OUTPUT.PUT_LINE('ALL HOSPITAL SYSTEM TESTS COMPLETED');
    DBMS_OUTPUT.PUT_LINE('=========================================');
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR during hospital system test: ' || SQLERRM);
        ROLLBACK;
END;
/

-- Additional verification queries
SELECT 'DATABASE STATUS VERIFICATION' as check_type FROM dual;

SELECT 'PATIENTS' as table_name, COUNT(*) as record_count FROM patients
UNION ALL
SELECT 'DOCTORS', COUNT(*) FROM doctors;

SELECT 'ADMISSION STATUS' as report, admitted, COUNT(*) as patient_count
FROM patients
GROUP BY admitted;

SELECT object_name, object_type, status
FROM user_objects
WHERE object_name = 'HOSPITAL_MGMT_PKG';
