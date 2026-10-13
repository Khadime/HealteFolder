-- Run as a deployment administrator after creating a dedicated application user.
-- Replace health_app with the provisioned account. Never run the application as root in production.
GRANT SELECT, INSERT, UPDATE ON HealthPlatform.patient_profile TO 'health_app'@'%';
GRANT SELECT ON HealthPlatform.organization TO 'health_app'@'%';
GRANT SELECT ON HealthPlatform.practitioner TO 'health_app'@'%';
GRANT SELECT, INSERT, UPDATE ON HealthPlatform.consent_qr_challenge TO 'health_app'@'%';
GRANT SELECT, INSERT, UPDATE ON HealthPlatform.consent_access_request TO 'health_app'@'%';
GRANT SELECT, INSERT, UPDATE ON HealthPlatform.consent_access_grant TO 'health_app'@'%';
GRANT SELECT, INSERT ON HealthPlatform.audit_event TO 'health_app'@'%';
GRANT SELECT, INSERT ON HealthPlatform.outbox_message TO 'health_app'@'%';
