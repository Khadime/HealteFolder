-- Synthetic registry only. No patients, passwords or automatic clinical grants.
-- Subject synthetic-practitioner must be replaced through a verified onboarding process.
INSERT IGNORE INTO organization (TenantId,Id,Version,CreatedAt,Name,Jurisdiction,Active)
VALUES ('11111111-1111-1111-1111-111111111111','22222222-2222-2222-2222-222222222222',1,UTC_TIMESTAMP(6),'Synthetic clinic','CA-QC',1);
INSERT IGNORE INTO practitioner (TenantId,Id,Version,CreatedAt,Subject,DisplayName,OrganizationId,LicenseUntil,Verified)
VALUES ('11111111-1111-1111-1111-111111111111','33333333-3333-3333-3333-333333333333',1,UTC_TIMESTAMP(6),'synthetic-practitioner','Synthetic professional','22222222-2222-2222-2222-222222222222','2027-01-01',0);
