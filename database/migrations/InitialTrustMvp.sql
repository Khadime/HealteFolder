CREATE TABLE IF NOT EXISTS `__EFMigrationsHistory` (
    `MigrationId` varchar(150) CHARACTER SET utf8mb4 NOT NULL,
    `ProductVersion` varchar(32) CHARACTER SET utf8mb4 NOT NULL,
    CONSTRAINT `PK___EFMigrationsHistory` PRIMARY KEY (`MigrationId`)
) CHARACTER SET=utf8mb4;

START TRANSACTION;
DROP PROCEDURE IF EXISTS MigrationsScript;
DELIMITER //
CREATE PROCEDURE MigrationsScript()
BEGIN
    IF NOT EXISTS(SELECT 1 FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20261005171820_InitialTrustMvp') THEN

    ALTER DATABASE CHARACTER SET utf8mb4;

    END IF;
END //
DELIMITER ;
CALL MigrationsScript();
DROP PROCEDURE MigrationsScript;

DROP PROCEDURE IF EXISTS MigrationsScript;
DELIMITER //
CREATE PROCEDURE MigrationsScript()
BEGIN
    IF NOT EXISTS(SELECT 1 FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20261005171820_InitialTrustMvp') THEN

    CREATE TABLE `audit_event` (
        `Id` char(36) COLLATE ascii_general_ci NOT NULL,
        `TenantId` char(36) COLLATE ascii_general_ci NOT NULL,
        `PatientId` char(36) COLLATE ascii_general_ci NULL,
        `Actor` varchar(200) CHARACTER SET utf8mb4 NOT NULL,
        `Action` varchar(200) CHARACTER SET utf8mb4 NOT NULL,
        `Outcome` varchar(200) CHARACTER SET utf8mb4 NOT NULL,
        `CorrelationId` varchar(200) CHARACTER SET utf8mb4 NOT NULL,
        `Purpose` varchar(200) CHARACTER SET utf8mb4 NOT NULL,
        `GrantId` char(36) COLLATE ascii_general_ci NULL,
        `Version` bigint NOT NULL,
        `CreatedAt` datetime(6) NOT NULL,
        CONSTRAINT `PK_audit_event` PRIMARY KEY (`TenantId`, `Id`)
    ) CHARACTER SET=utf8mb4;

    END IF;
END //
DELIMITER ;
CALL MigrationsScript();
DROP PROCEDURE MigrationsScript;

DROP PROCEDURE IF EXISTS MigrationsScript;
DELIMITER //
CREATE PROCEDURE MigrationsScript()
BEGIN
    IF NOT EXISTS(SELECT 1 FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20261005171820_InitialTrustMvp') THEN

    CREATE TABLE `identity_account` (
        `Id` char(36) COLLATE ascii_general_ci NOT NULL,
        `TenantId` char(36) COLLATE ascii_general_ci NOT NULL,
        `Subject` varchar(200) CHARACTER SET utf8mb4 NOT NULL,
        `Active` tinyint(1) NOT NULL,
        `Version` bigint NOT NULL,
        `CreatedAt` datetime(6) NOT NULL,
        CONSTRAINT `PK_identity_account` PRIMARY KEY (`TenantId`, `Id`)
    ) CHARACTER SET=utf8mb4;

    END IF;
END //
DELIMITER ;
CALL MigrationsScript();
DROP PROCEDURE MigrationsScript;

DROP PROCEDURE IF EXISTS MigrationsScript;
DELIMITER //
CREATE PROCEDURE MigrationsScript()
BEGIN
    IF NOT EXISTS(SELECT 1 FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20261005171820_InitialTrustMvp') THEN

    CREATE TABLE `organization` (
        `Id` char(36) COLLATE ascii_general_ci NOT NULL,
        `TenantId` char(36) COLLATE ascii_general_ci NOT NULL,
        `Name` varchar(200) CHARACTER SET utf8mb4 NOT NULL,
        `Jurisdiction` varchar(200) CHARACTER SET utf8mb4 NOT NULL,
        `Active` tinyint(1) NOT NULL,
        `Version` bigint NOT NULL,
        `CreatedAt` datetime(6) NOT NULL,
        CONSTRAINT `PK_organization` PRIMARY KEY (`TenantId`, `Id`)
    ) CHARACTER SET=utf8mb4;

    END IF;
END //
DELIMITER ;
CALL MigrationsScript();
DROP PROCEDURE MigrationsScript;

DROP PROCEDURE IF EXISTS MigrationsScript;
DELIMITER //
CREATE PROCEDURE MigrationsScript()
BEGIN
    IF NOT EXISTS(SELECT 1 FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20261005171820_InitialTrustMvp') THEN

    CREATE TABLE `outbox_message` (
        `Id` char(36) COLLATE ascii_general_ci NOT NULL,
        `TenantId` char(36) COLLATE ascii_general_ci NOT NULL,
        `Type` varchar(200) CHARACTER SET utf8mb4 NOT NULL,
        `Recipient` varchar(200) CHARACTER SET utf8mb4 NOT NULL,
        `ReferenceId` char(36) COLLATE ascii_general_ci NOT NULL,
        `DeliveredAt` datetime(6) NULL,
        `Version` bigint NOT NULL,
        `CreatedAt` datetime(6) NOT NULL,
        CONSTRAINT `PK_outbox_message` PRIMARY KEY (`TenantId`, `Id`)
    ) CHARACTER SET=utf8mb4;

    END IF;
END //
DELIMITER ;
CALL MigrationsScript();
DROP PROCEDURE MigrationsScript;

DROP PROCEDURE IF EXISTS MigrationsScript;
DELIMITER //
CREATE PROCEDURE MigrationsScript()
BEGIN
    IF NOT EXISTS(SELECT 1 FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20261005171820_InitialTrustMvp') THEN

    CREATE TABLE `patient_profile` (
        `Id` char(36) COLLATE ascii_general_ci NOT NULL,
        `TenantId` char(36) COLLATE ascii_general_ci NOT NULL,
        `Subject` varchar(200) CHARACTER SET utf8mb4 NOT NULL,
        `GivenName` varchar(200) CHARACTER SET utf8mb4 NOT NULL,
        `FamilyName` varchar(200) CHARACTER SET utf8mb4 NOT NULL,
        `BirthDate` date NOT NULL,
        `Version` bigint NOT NULL,
        `CreatedAt` datetime(6) NOT NULL,
        CONSTRAINT `PK_patient_profile` PRIMARY KEY (`TenantId`, `Id`)
    ) CHARACTER SET=utf8mb4;

    END IF;
END //
DELIMITER ;
CALL MigrationsScript();
DROP PROCEDURE MigrationsScript;

DROP PROCEDURE IF EXISTS MigrationsScript;
DELIMITER //
CREATE PROCEDURE MigrationsScript()
BEGIN
    IF NOT EXISTS(SELECT 1 FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20261005171820_InitialTrustMvp') THEN

    CREATE TABLE `practitioner` (
        `Id` char(36) COLLATE ascii_general_ci NOT NULL,
        `TenantId` char(36) COLLATE ascii_general_ci NOT NULL,
        `Subject` varchar(200) CHARACTER SET utf8mb4 NOT NULL,
        `DisplayName` varchar(200) CHARACTER SET utf8mb4 NOT NULL,
        `OrganizationId` char(36) COLLATE ascii_general_ci NOT NULL,
        `LicenseUntil` datetime(6) NOT NULL,
        `Verified` tinyint(1) NOT NULL,
        `Version` bigint NOT NULL,
        `CreatedAt` datetime(6) NOT NULL,
        CONSTRAINT `PK_practitioner` PRIMARY KEY (`TenantId`, `Id`),
        CONSTRAINT `FK_practitioner_organization_TenantId_OrganizationId` FOREIGN KEY (`TenantId`, `OrganizationId`) REFERENCES `organization` (`TenantId`, `Id`) ON DELETE RESTRICT
    ) CHARACTER SET=utf8mb4;

    END IF;
END //
DELIMITER ;
CALL MigrationsScript();
DROP PROCEDURE MigrationsScript;

DROP PROCEDURE IF EXISTS MigrationsScript;
DELIMITER //
CREATE PROCEDURE MigrationsScript()
BEGIN
    IF NOT EXISTS(SELECT 1 FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20261005171820_InitialTrustMvp') THEN

    CREATE TABLE `consent_qr_challenge` (
        `Id` char(36) COLLATE ascii_general_ci NOT NULL,
        `TenantId` char(36) COLLATE ascii_general_ci NOT NULL,
        `PatientId` char(36) COLLATE ascii_general_ci NOT NULL,
        `NonceHash` varchar(200) CHARACTER SET utf8mb4 NOT NULL,
        `ExpiresAt` datetime(6) NOT NULL,
        `ConsumedAt` datetime(6) NULL,
        `RevokedAt` datetime(6) NULL,
        `Scope` int NOT NULL,
        `Version` bigint NOT NULL,
        `CreatedAt` datetime(6) NOT NULL,
        CONSTRAINT `PK_consent_qr_challenge` PRIMARY KEY (`TenantId`, `Id`),
        CONSTRAINT `FK_consent_qr_challenge_patient_profile_TenantId_PatientId` FOREIGN KEY (`TenantId`, `PatientId`) REFERENCES `patient_profile` (`TenantId`, `Id`) ON DELETE RESTRICT
    ) CHARACTER SET=utf8mb4;

    END IF;
END //
DELIMITER ;
CALL MigrationsScript();
DROP PROCEDURE MigrationsScript;

DROP PROCEDURE IF EXISTS MigrationsScript;
DELIMITER //
CREATE PROCEDURE MigrationsScript()
BEGIN
    IF NOT EXISTS(SELECT 1 FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20261005171820_InitialTrustMvp') THEN

    CREATE TABLE `consent_access_request` (
        `Id` char(36) COLLATE ascii_general_ci NOT NULL,
        `TenantId` char(36) COLLATE ascii_general_ci NOT NULL,
        `PatientId` char(36) COLLATE ascii_general_ci NOT NULL,
        `PractitionerId` char(36) COLLATE ascii_general_ci NOT NULL,
        `OrganizationId` char(36) COLLATE ascii_general_ci NOT NULL,
        `PractitionerSubject` varchar(200) CHARACTER SET utf8mb4 NOT NULL,
        `PractitionerName` varchar(200) CHARACTER SET utf8mb4 NOT NULL,
        `OrganizationName` varchar(200) CHARACTER SET utf8mb4 NOT NULL,
        `Purpose` varchar(200) CHARACTER SET utf8mb4 NOT NULL,
        `ChallengeId` char(36) COLLATE ascii_general_ci NOT NULL,
        `Scope` int NOT NULL,
        `DurationMinutes` int NOT NULL,
        `ExpiresAt` datetime(6) NOT NULL,
        `Status` int NOT NULL,
        `Version` bigint NOT NULL,
        `CreatedAt` datetime(6) NOT NULL,
        CONSTRAINT `PK_consent_access_request` PRIMARY KEY (`TenantId`, `Id`),
        CONSTRAINT `FK_consent_access_request_consent_qr_challenge_TenantId_Challen~` FOREIGN KEY (`TenantId`, `ChallengeId`) REFERENCES `consent_qr_challenge` (`TenantId`, `Id`) ON DELETE RESTRICT,
        CONSTRAINT `FK_consent_access_request_patient_profile_TenantId_PatientId` FOREIGN KEY (`TenantId`, `PatientId`) REFERENCES `patient_profile` (`TenantId`, `Id`) ON DELETE RESTRICT,
        CONSTRAINT `FK_consent_access_request_practitioner_TenantId_PractitionerId` FOREIGN KEY (`TenantId`, `PractitionerId`) REFERENCES `practitioner` (`TenantId`, `Id`) ON DELETE RESTRICT
    ) CHARACTER SET=utf8mb4;

    END IF;
END //
DELIMITER ;
CALL MigrationsScript();
DROP PROCEDURE MigrationsScript;

DROP PROCEDURE IF EXISTS MigrationsScript;
DELIMITER //
CREATE PROCEDURE MigrationsScript()
BEGIN
    IF NOT EXISTS(SELECT 1 FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20261005171820_InitialTrustMvp') THEN

    CREATE TABLE `consent_access_grant` (
        `Id` char(36) COLLATE ascii_general_ci NOT NULL,
        `TenantId` char(36) COLLATE ascii_general_ci NOT NULL,
        `PatientId` char(36) COLLATE ascii_general_ci NOT NULL,
        `RequestId` char(36) COLLATE ascii_general_ci NOT NULL,
        `PractitionerId` char(36) COLLATE ascii_general_ci NOT NULL,
        `OrganizationId` char(36) COLLATE ascii_general_ci NOT NULL,
        `Subject` varchar(200) CHARACTER SET utf8mb4 NOT NULL,
        `Purpose` varchar(200) CHARACTER SET utf8mb4 NOT NULL,
        `Scope` int NOT NULL,
        `ValidFrom` datetime(6) NOT NULL,
        `ValidUntil` datetime(6) NOT NULL,
        `RevokedAt` datetime(6) NULL,
        `Version` bigint NOT NULL,
        `CreatedAt` datetime(6) NOT NULL,
        CONSTRAINT `PK_consent_access_grant` PRIMARY KEY (`TenantId`, `Id`),
        CONSTRAINT `FK_consent_access_grant_consent_access_request_TenantId_Request~` FOREIGN KEY (`TenantId`, `RequestId`) REFERENCES `consent_access_request` (`TenantId`, `Id`) ON DELETE RESTRICT
    ) CHARACTER SET=utf8mb4;

    END IF;
END //
DELIMITER ;
CALL MigrationsScript();
DROP PROCEDURE MigrationsScript;

DROP PROCEDURE IF EXISTS MigrationsScript;
DELIMITER //
CREATE PROCEDURE MigrationsScript()
BEGIN
    IF NOT EXISTS(SELECT 1 FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20261005171820_InitialTrustMvp') THEN

    CREATE INDEX `IX_audit_event_TenantId_PatientId_CreatedAt` ON `audit_event` (`TenantId`, `PatientId`, `CreatedAt`);

    END IF;
END //
DELIMITER ;
CALL MigrationsScript();
DROP PROCEDURE MigrationsScript;

DROP PROCEDURE IF EXISTS MigrationsScript;
DELIMITER //
CREATE PROCEDURE MigrationsScript()
BEGIN
    IF NOT EXISTS(SELECT 1 FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20261005171820_InitialTrustMvp') THEN

    CREATE INDEX `IX_consent_access_grant_TenantId_PatientId_Subject_ValidUntil` ON `consent_access_grant` (`TenantId`, `PatientId`, `Subject`, `ValidUntil`);

    END IF;
END //
DELIMITER ;
CALL MigrationsScript();
DROP PROCEDURE MigrationsScript;

DROP PROCEDURE IF EXISTS MigrationsScript;
DELIMITER //
CREATE PROCEDURE MigrationsScript()
BEGIN
    IF NOT EXISTS(SELECT 1 FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20261005171820_InitialTrustMvp') THEN

    CREATE UNIQUE INDEX `IX_consent_access_grant_TenantId_RequestId` ON `consent_access_grant` (`TenantId`, `RequestId`);

    END IF;
END //
DELIMITER ;
CALL MigrationsScript();
DROP PROCEDURE MigrationsScript;

DROP PROCEDURE IF EXISTS MigrationsScript;
DELIMITER //
CREATE PROCEDURE MigrationsScript()
BEGIN
    IF NOT EXISTS(SELECT 1 FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20261005171820_InitialTrustMvp') THEN

    CREATE UNIQUE INDEX `IX_consent_access_request_TenantId_ChallengeId` ON `consent_access_request` (`TenantId`, `ChallengeId`);

    END IF;
END //
DELIMITER ;
CALL MigrationsScript();
DROP PROCEDURE MigrationsScript;

DROP PROCEDURE IF EXISTS MigrationsScript;
DELIMITER //
CREATE PROCEDURE MigrationsScript()
BEGIN
    IF NOT EXISTS(SELECT 1 FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20261005171820_InitialTrustMvp') THEN

    CREATE INDEX `IX_consent_access_request_TenantId_PatientId_Status_CreatedAt` ON `consent_access_request` (`TenantId`, `PatientId`, `Status`, `CreatedAt`);

    END IF;
END //
DELIMITER ;
CALL MigrationsScript();
DROP PROCEDURE MigrationsScript;

DROP PROCEDURE IF EXISTS MigrationsScript;
DELIMITER //
CREATE PROCEDURE MigrationsScript()
BEGIN
    IF NOT EXISTS(SELECT 1 FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20261005171820_InitialTrustMvp') THEN

    CREATE INDEX `IX_consent_access_request_TenantId_PractitionerId` ON `consent_access_request` (`TenantId`, `PractitionerId`);

    END IF;
END //
DELIMITER ;
CALL MigrationsScript();
DROP PROCEDURE MigrationsScript;

DROP PROCEDURE IF EXISTS MigrationsScript;
DELIMITER //
CREATE PROCEDURE MigrationsScript()
BEGIN
    IF NOT EXISTS(SELECT 1 FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20261005171820_InitialTrustMvp') THEN

    CREATE UNIQUE INDEX `IX_consent_qr_challenge_TenantId_NonceHash` ON `consent_qr_challenge` (`TenantId`, `NonceHash`);

    END IF;
END //
DELIMITER ;
CALL MigrationsScript();
DROP PROCEDURE MigrationsScript;

DROP PROCEDURE IF EXISTS MigrationsScript;
DELIMITER //
CREATE PROCEDURE MigrationsScript()
BEGIN
    IF NOT EXISTS(SELECT 1 FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20261005171820_InitialTrustMvp') THEN

    CREATE INDEX `IX_consent_qr_challenge_TenantId_PatientId` ON `consent_qr_challenge` (`TenantId`, `PatientId`);

    END IF;
END //
DELIMITER ;
CALL MigrationsScript();
DROP PROCEDURE MigrationsScript;

DROP PROCEDURE IF EXISTS MigrationsScript;
DELIMITER //
CREATE PROCEDURE MigrationsScript()
BEGIN
    IF NOT EXISTS(SELECT 1 FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20261005171820_InitialTrustMvp') THEN

    CREATE UNIQUE INDEX `IX_identity_account_TenantId_Subject` ON `identity_account` (`TenantId`, `Subject`);

    END IF;
END //
DELIMITER ;
CALL MigrationsScript();
DROP PROCEDURE MigrationsScript;

DROP PROCEDURE IF EXISTS MigrationsScript;
DELIMITER //
CREATE PROCEDURE MigrationsScript()
BEGIN
    IF NOT EXISTS(SELECT 1 FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20261005171820_InitialTrustMvp') THEN

    CREATE INDEX `IX_outbox_message_TenantId_DeliveredAt_CreatedAt` ON `outbox_message` (`TenantId`, `DeliveredAt`, `CreatedAt`);

    END IF;
END //
DELIMITER ;
CALL MigrationsScript();
DROP PROCEDURE MigrationsScript;

DROP PROCEDURE IF EXISTS MigrationsScript;
DELIMITER //
CREATE PROCEDURE MigrationsScript()
BEGIN
    IF NOT EXISTS(SELECT 1 FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20261005171820_InitialTrustMvp') THEN

    CREATE UNIQUE INDEX `IX_patient_profile_TenantId_Subject` ON `patient_profile` (`TenantId`, `Subject`);

    END IF;
END //
DELIMITER ;
CALL MigrationsScript();
DROP PROCEDURE MigrationsScript;

DROP PROCEDURE IF EXISTS MigrationsScript;
DELIMITER //
CREATE PROCEDURE MigrationsScript()
BEGIN
    IF NOT EXISTS(SELECT 1 FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20261005171820_InitialTrustMvp') THEN

    CREATE INDEX `IX_practitioner_TenantId_OrganizationId` ON `practitioner` (`TenantId`, `OrganizationId`);

    END IF;
END //
DELIMITER ;
CALL MigrationsScript();
DROP PROCEDURE MigrationsScript;

DROP PROCEDURE IF EXISTS MigrationsScript;
DELIMITER //
CREATE PROCEDURE MigrationsScript()
BEGIN
    IF NOT EXISTS(SELECT 1 FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20261005171820_InitialTrustMvp') THEN

    CREATE UNIQUE INDEX `IX_practitioner_TenantId_Subject` ON `practitioner` (`TenantId`, `Subject`);

    END IF;
END //
DELIMITER ;
CALL MigrationsScript();
DROP PROCEDURE MigrationsScript;

DROP PROCEDURE IF EXISTS MigrationsScript;
DELIMITER //
CREATE PROCEDURE MigrationsScript()
BEGIN
    IF NOT EXISTS(SELECT 1 FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20261005171820_InitialTrustMvp') THEN

    INSERT INTO `__EFMigrationsHistory` (`MigrationId`, `ProductVersion`)
    VALUES ('20261005171820_InitialTrustMvp', '9.0.20');

    END IF;
END //
DELIMITER ;
CALL MigrationsScript();
DROP PROCEDURE MigrationsScript;

COMMIT;

