CREATE TABLE login_audit (
    audit_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username VARCHAR2(100) NOT NULL,
    attempt_time TIMESTAMP NOT NULL,
    status VARCHAR2(10) NOT NULL CHECK (status IN ('SUCCESS', 'FAILED')),
    ip_address VARCHAR2(45),
    device_info VARCHAR2(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE security_alerts (
     alert_id NUMBER PRIMARY KEY,
     Username VARCHAR2(100) NOT NULL,
     Number_of_failed_attemps NUMBER,
     Alert_time DATE,
     Alert_message VARCHAR2(100),
     Email VARCHAR2(100)
);

CREATE INDEX idx_login_audit_user_time ON login_audit(username, attempt_time);
CREATE INDEX idx_login_audit_status_time ON login_audit(status, attempt_time);

CREATE INDEX idx_security_alerts_time ON security_alerts(alert_time);
CREATE INDEX idx_security_alerts_user ON security_alerts(username);


CREATE SEQUENCE security_alerts_seq START WITH 1 INCREMENT BY 1;
