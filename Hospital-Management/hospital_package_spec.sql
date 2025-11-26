CREATE OR REPLACE PACKAGE hospital_mgmt_pkg AS

    -- Record type for patient data
    TYPE patient_rec IS RECORD (
        patient_id NUMBER,
        patient_name VARCHAR2(100),
        age NUMBER,
        gender VARCHAR2(10),
        admitted VARCHAR2(1)
    );
    
    TYPE patient_tbl IS TABLE OF patient_rec;
    TYPE patient_ids_tbl IS TABLE OF NUMBER;
    
    -- Procedure and function declarations
    PROCEDURE bulk_load_patients(p_patients IN patient_tbl);
    FUNCTION show_all_patients RETURN SYS_REFCURSOR;
    FUNCTION count_admitted RETURN NUMBER;
    PROCEDURE admit_patient(p_patient_id IN NUMBER);
    PROCEDURE admit_multiple_patients(p_patient_ids IN patient_ids_tbl);
    PROCEDURE add_doctor(p_doctor_name IN VARCHAR2, p_specialty IN VARCHAR2);
    FUNCTION show_doctors RETURN SYS_REFCURSOR;
    PROCEDURE clear_test_data;
    
END hospital_mgmt_pkg;
/

-- Verify package specification creation
SELECT object_name, object_type, status
FROM user_objects
WHERE object_name = 'HOSPITAL_MGMT_PKG' AND object_type = 'PACKAGE';
