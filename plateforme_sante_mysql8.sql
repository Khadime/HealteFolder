-- Generated from Dossier_conception_plateforme_sante_orientee_patient(1).md
-- Target: MySQL 8.0+
-- UUID columns use BINARY(16); the application must generate UUIDv7 values.
-- The script is non-destructive: it creates missing objects and never drops business tables.

SET NAMES utf8mb4;
SET @OLD_SQL_MODE = @@SQL_MODE;
SET SQL_MODE = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

CREATE DATABASE IF NOT EXISTS `plateforme_sante`
  CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE `plateforme_sante`;

CREATE TABLE IF NOT EXISTS `meta__schema_migration` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `version` VARCHAR(50) NOT NULL,
  `description` VARCHAR(255) NOT NULL,
  `checksum_sha256` CHAR(64) NULL,
  `applied_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_meta_schema_migration_version` (`version`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SET FOREIGN_KEY_CHECKS = 0;
CREATE TABLE IF NOT EXISTS `core__tenant` (
  `id` BINARY(16) NOT NULL,
  `code` VARCHAR(50) NULL,
  `name` VARCHAR(200) NULL,
  `status` VARCHAR(20) NULL,
  `default_jurisdiction_id` BINARY(16) NULL,
  `data_region` VARCHAR(50) NULL,
  `settings` JSON NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_core__tenant_code` (`code`),
  KEY `ix_core__tenant_status` (`status`),
  KEY `ix_core__tenant_code` (`code`),
  KEY `ix_core__tenant_created_at` (`created_at`),
  KEY `ix_core__tenant_default_jurisdiction_id` (`default_jurisdiction_id`),
  KEY `ix_core__tenant_source_system_id` (`source_system_id`),
  KEY `ix_core__tenant_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Locataire';

CREATE TABLE IF NOT EXISTS `core__tenant_domain` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `domain` VARCHAR(253) NULL,
  `verified_at` DATETIME(6) NULL,
  `verification_method` VARCHAR(100) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_core__tenant_domain_domain` (`domain`),
  KEY `ix_core__tenant_domain_tenant_id` (`tenant_id`),
  KEY `ix_core__tenant_domain_created_at` (`created_at`),
  KEY `ix_core__tenant_domain_source_system_id` (`source_system_id`),
  KEY `ix_core__tenant_domain_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Domaines validés';

CREATE TABLE IF NOT EXISTS `core__jurisdiction` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `code` VARCHAR(20) NULL,
  `country_code` CHAR(2) NULL,
  `parent_id` BINARY(16) NULL,
  `timezone` VARCHAR(64) NULL,
  `effective_from` DATETIME(6) NULL,
  `effective_to` DATETIME(6) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_core__jurisdiction_tenant_id` (`tenant_id`),
  KEY `ix_core__jurisdiction_code` (`code`),
  KEY `ix_core__jurisdiction_created_at` (`created_at`),
  KEY `ix_core__jurisdiction_parent_id` (`parent_id`),
  KEY `ix_core__jurisdiction_source_system_id` (`source_system_id`),
  KEY `ix_core__jurisdiction_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Pays/province/État';

CREATE TABLE IF NOT EXISTS `core__feature_flag` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `key` VARCHAR(100) NULL,
  `enabled` BOOLEAN NULL,
  `rules` JSON NULL,
  `effective_from` DATETIME(6) NULL,
  `effective_to` DATETIME(6) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_core__feature_flag_tenant_id` (`tenant_id`),
  KEY `ix_core__feature_flag_created_at` (`created_at`),
  KEY `ix_core__feature_flag_source_system_id` (`source_system_id`),
  KEY `ix_core__feature_flag_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Fonction par tenant';

CREATE TABLE IF NOT EXISTS `core__configuration` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `scope_type` VARCHAR(100) NULL,
  `scope_id` BINARY(16) NULL,
  `key` VARCHAR(255) NULL,
  `value` JSON NULL,
  `schema_version` VARCHAR(255) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_core__configuration_tenant_id` (`tenant_id`),
  KEY `ix_core__configuration_created_at` (`created_at`),
  KEY `ix_core__configuration_scope_id` (`scope_id`),
  KEY `ix_core__configuration_source_system_id` (`source_system_id`),
  KEY `ix_core__configuration_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Paramètre non secret';

CREATE TABLE IF NOT EXISTS `core__legal_text` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `type` VARCHAR(100) NULL,
  `locale` VARCHAR(64) NULL,
  `version` VARCHAR(255) NULL,
  `content_uri` VARCHAR(512) NULL,
  `effective_at` DATETIME(6) NULL,
  `retired_at` DATETIME(6) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_core__legal_text_tenant_id` (`tenant_id`),
  KEY `ix_core__legal_text_created_at` (`created_at`),
  KEY `ix_core__legal_text_source_system_id` (`source_system_id`),
  KEY `ix_core__legal_text_external_id` (`external_id`),
  KEY `ix_core__legal_text_effective_at` (`effective_at`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Texte légal versionné';

CREATE TABLE IF NOT EXISTS `core__acceptance_record` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `legal_text_id` BINARY(16) NULL,
  `actor_user_id` BINARY(16) NULL,
  `accepted_at` DATETIME(6) NULL,
  `channel` VARCHAR(100) NULL,
  `evidence_hash` VARBINARY(1024) NULL,
  `ip_prefix` VARCHAR(255) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_core__acceptance_record_tenant_id` (`tenant_id`),
  KEY `ix_core__acceptance_record_created_at` (`created_at`),
  KEY `ix_core__acceptance_record_legal_text_id` (`legal_text_id`),
  KEY `ix_core__acceptance_record_actor_user_id` (`actor_user_id`),
  KEY `ix_core__acceptance_record_source_system_id` (`source_system_id`),
  KEY `ix_core__acceptance_record_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Acceptation';

CREATE TABLE IF NOT EXISTS `core__sequence_registry` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `sequence_key` VARCHAR(255) NULL,
  `next_value` BIGINT NULL,
  `prefix` VARCHAR(255) NULL,
  `year_scope` INT NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_core__sequence_registry_tenant_id` (`tenant_id`),
  KEY `ix_core__sequence_registry_created_at` (`created_at`),
  KEY `ix_core__sequence_registry_source_system_id` (`source_system_id`),
  KEY `ix_core__sequence_registry_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Séquences lisibles';

CREATE TABLE IF NOT EXISTS `iam__user_account` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `subject` VARCHAR(150) NULL,
  `account_type` VARCHAR(100) NULL,
  `status` VARCHAR(100) NULL,
  `locale` VARCHAR(64) NULL,
  `last_login_at` DATETIME(6) NULL,
  `locked_until` DATETIME(6) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_iam__user_account_tenant_id_subject` (`tenant_id`, `subject`),
  KEY `ix_iam__user_account_tenant_id` (`tenant_id`),
  KEY `ix_iam__user_account_status` (`status`),
  KEY `ix_iam__user_account_created_at` (`created_at`),
  KEY `ix_iam__user_account_source_system_id` (`source_system_id`),
  KEY `ix_iam__user_account_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Compte';

CREATE TABLE IF NOT EXISTS `iam__user_identity` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `user_id` BINARY(16) NULL,
  `issuer` VARCHAR(255) NULL,
  `provider_subject` VARCHAR(255) NULL,
  `assurance_level` VARCHAR(100) NULL,
  `verified_at` DATETIME(6) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_iam__user_identity_issuer_provider_subject` (`issuer`, `provider_subject`),
  KEY `ix_iam__user_identity_tenant_id` (`tenant_id`),
  KEY `ix_iam__user_identity_created_at` (`created_at`),
  KEY `ix_iam__user_identity_user_id` (`user_id`),
  KEY `ix_iam__user_identity_source_system_id` (`source_system_id`),
  KEY `ix_iam__user_identity_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Identité fédérée';

CREATE TABLE IF NOT EXISTS `iam__credential_factor` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `user_id` BINARY(16) NULL,
  `factor_type` VARCHAR(100) NULL,
  `credential_ref` VARCHAR(255) NULL,
  `public_key` VARBINARY(1024) NULL,
  `status` VARCHAR(100) NULL,
  `enrolled_at` DATETIME(6) NULL,
  `last_used_at` DATETIME(6) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_iam__credential_factor_tenant_id` (`tenant_id`),
  KEY `ix_iam__credential_factor_status` (`status`),
  KEY `ix_iam__credential_factor_created_at` (`created_at`),
  KEY `ix_iam__credential_factor_user_id` (`user_id`),
  KEY `ix_iam__credential_factor_source_system_id` (`source_system_id`),
  KEY `ix_iam__credential_factor_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Facteur';

CREATE TABLE IF NOT EXISTS `iam__recovery_method` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `user_id` BINARY(16) NULL,
  `method_type` VARCHAR(100) NULL,
  `value_hmac` VARBINARY(1024) NULL,
  `verified_at` DATETIME(6) NULL,
  `status` VARCHAR(100) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_iam__recovery_method_tenant_id` (`tenant_id`),
  KEY `ix_iam__recovery_method_status` (`status`),
  KEY `ix_iam__recovery_method_created_at` (`created_at`),
  KEY `ix_iam__recovery_method_user_id` (`user_id`),
  KEY `ix_iam__recovery_method_source_system_id` (`source_system_id`),
  KEY `ix_iam__recovery_method_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Récupération';

CREATE TABLE IF NOT EXISTS `iam__device` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `user_id` BINARY(16) NULL,
  `device_fingerprint_hmac` VARBINARY(1024) NULL,
  `platform` VARCHAR(100) NULL,
  `attestation_level` VARCHAR(100) NULL,
  `trusted_until` DATETIME(6) NULL,
  `revoked_at` DATETIME(6) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_iam__device_tenant_id` (`tenant_id`),
  KEY `ix_iam__device_created_at` (`created_at`),
  KEY `ix_iam__device_user_id` (`user_id`),
  KEY `ix_iam__device_source_system_id` (`source_system_id`),
  KEY `ix_iam__device_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Appareil';

CREATE TABLE IF NOT EXISTS `iam__session` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `user_id` BINARY(16) NULL,
  `device_id` BINARY(16) NULL,
  `started_at` DATETIME(6) NULL,
  `expires_at` DATETIME(6) NULL,
  `last_seen_at` DATETIME(6) NULL,
  `risk_score` DECIMAL(5,2) NULL,
  `revoked_at` DATETIME(6) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_iam__session_tenant_id` (`tenant_id`),
  KEY `ix_iam__session_created_at` (`created_at`),
  KEY `ix_iam__session_user_id` (`user_id`),
  KEY `ix_iam__session_device_id` (`device_id`),
  KEY `ix_iam__session_source_system_id` (`source_system_id`),
  KEY `ix_iam__session_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Session';

CREATE TABLE IF NOT EXISTS `iam__role` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `code` VARCHAR(100) NULL,
  `name` VARCHAR(255) NULL,
  `role_type` VARCHAR(100) NULL,
  `description` TEXT NULL,
  `system_role` BOOLEAN NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_iam__role_tenant_id_code` (`tenant_id`, `code`),
  KEY `ix_iam__role_tenant_id` (`tenant_id`),
  KEY `ix_iam__role_code` (`code`),
  KEY `ix_iam__role_created_at` (`created_at`),
  KEY `ix_iam__role_source_system_id` (`source_system_id`),
  KEY `ix_iam__role_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Rôle';

CREATE TABLE IF NOT EXISTS `iam__permission` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `code` VARCHAR(100) NULL,
  `resource_type` VARCHAR(100) NULL,
  `action` VARCHAR(100) NULL,
  `description` TEXT NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_iam__permission_tenant_id_code` (`tenant_id`, `code`),
  KEY `ix_iam__permission_tenant_id` (`tenant_id`),
  KEY `ix_iam__permission_code` (`code`),
  KEY `ix_iam__permission_created_at` (`created_at`),
  KEY `ix_iam__permission_source_system_id` (`source_system_id`),
  KEY `ix_iam__permission_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Permission atomique';

CREATE TABLE IF NOT EXISTS `iam__role_permission` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `role_id` BINARY(16) NULL,
  `permission_id` BINARY(16) NULL,
  `effect` VARCHAR(100) NULL,
  `conditions` JSON NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_iam__role_permission_tenant_id` (`tenant_id`),
  KEY `ix_iam__role_permission_created_at` (`created_at`),
  KEY `ix_iam__role_permission_role_id` (`role_id`),
  KEY `ix_iam__role_permission_permission_id` (`permission_id`),
  KEY `ix_iam__role_permission_source_system_id` (`source_system_id`),
  KEY `ix_iam__role_permission_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Liaison';

CREATE TABLE IF NOT EXISTS `iam__user_role_assignment` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `user_id` BINARY(16) NULL,
  `role_id` BINARY(16) NULL,
  `organization_id` BINARY(16) NULL,
  `valid_from` DATETIME(6) NULL,
  `valid_to` DATETIME(6) NULL,
  `approved_by` BINARY(16) NULL,
  `status` VARCHAR(100) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_iam__user_role_assignment_tenant_id` (`tenant_id`),
  KEY `ix_iam__user_role_assignment_status` (`status`),
  KEY `ix_iam__user_role_assignment_created_at` (`created_at`),
  KEY `ix_iam__user_role_assignment_user_id` (`user_id`),
  KEY `ix_iam__user_role_assignment_role_id` (`role_id`),
  KEY `ix_iam__user_role_assignment_organization_id` (`organization_id`),
  KEY `ix_iam__user_role_assignment_source_system_id` (`source_system_id`),
  KEY `ix_iam__user_role_assignment_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Attribution';

CREATE TABLE IF NOT EXISTS `iam__service_principal` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `client_id` BINARY(16) NULL,
  `name` VARCHAR(255) NULL,
  `owner_org_id` BINARY(16) NULL,
  `auth_method` VARCHAR(100) NULL,
  `status` VARCHAR(100) NULL,
  `jwks_uri` VARCHAR(512) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_iam__service_principal_tenant_id` (`tenant_id`),
  KEY `ix_iam__service_principal_status` (`status`),
  KEY `ix_iam__service_principal_created_at` (`created_at`),
  KEY `ix_iam__service_principal_client_id` (`client_id`),
  KEY `ix_iam__service_principal_owner_org_id` (`owner_org_id`),
  KEY `ix_iam__service_principal_source_system_id` (`source_system_id`),
  KEY `ix_iam__service_principal_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Client machine';

CREATE TABLE IF NOT EXISTS `iam__service_scope` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `service_principal_id` BINARY(16) NULL,
  `scope` JSON NULL,
  `valid_from` DATETIME(6) NULL,
  `valid_to` DATETIME(6) NULL,
  `approved_by` BINARY(16) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_iam__service_scope_tenant_id` (`tenant_id`),
  KEY `ix_iam__service_scope_created_at` (`created_at`),
  KEY `ix_iam__service_scope_service_principal_id` (`service_principal_id`),
  KEY `ix_iam__service_scope_source_system_id` (`source_system_id`),
  KEY `ix_iam__service_scope_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Scopes client';

CREATE TABLE IF NOT EXISTS `iam__login_event` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `user_id` BINARY(16) NULL,
  `occurred_at` DATETIME(6) NULL,
  `outcome` VARCHAR(100) NULL,
  `factor_types` JSON NULL,
  `risk_score` DECIMAL(19,6) NULL,
  `network_hmac` VARBINARY(1024) NULL,
  `reason_code` TEXT NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_iam__login_event_tenant_id` (`tenant_id`),
  KEY `ix_iam__login_event_created_at` (`created_at`),
  KEY `ix_iam__login_event_user_id` (`user_id`),
  KEY `ix_iam__login_event_source_system_id` (`source_system_id`),
  KEY `ix_iam__login_event_external_id` (`external_id`),
  KEY `ix_iam__login_event_occurred_at` (`occurred_at`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Authentification';

CREATE TABLE IF NOT EXISTS `patient__patient` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `user_id` BINARY(16) NULL,
  `status` VARCHAR(100) NULL,
  `birth_date` DATE NULL,
  `deceased_at` DATETIME(6) NULL,
  `administrative_sex` VARCHAR(255) NULL,
  `gender_identity` VARCHAR(255) NULL,
  `preferred_language` VARCHAR(255) NULL,
  `identity_confidence` DECIMAL(19,6) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_patient__patient_tenant_id` (`tenant_id`),
  KEY `ix_patient__patient_status` (`status`),
  KEY `ix_patient__patient_created_at` (`created_at`),
  KEY `ix_patient__patient_user_id` (`user_id`),
  KEY `ix_patient__patient_source_system_id` (`source_system_id`),
  KEY `ix_patient__patient_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Identité maître';

CREATE TABLE IF NOT EXISTS `patient__patient_name` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `use` VARCHAR(100) NULL,
  `family` VARCHAR(255) NULL,
  `given` JSON NULL,
  `prefix` VARCHAR(255) NULL,
  `suffix` VARCHAR(255) NULL,
  `valid_from` DATETIME(6) NULL,
  `valid_to` DATETIME(6) NULL,
  `normalized_hmac` VARBINARY(1024) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_patient__patient_name_tenant_id` (`tenant_id`),
  KEY `ix_patient__patient_name_patient_id` (`patient_id`),
  KEY `ix_patient__patient_name_created_at` (`created_at`),
  KEY `ix_patient__patient_name_source_system_id` (`source_system_id`),
  KEY `ix_patient__patient_name_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Noms';

CREATE TABLE IF NOT EXISTS `patient__patient_identifier` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `type` VARCHAR(100) NULL,
  `system` VARCHAR(100) NULL,
  `value_ciphertext` VARBINARY(1024) NULL,
  `value_hmac` VARBINARY(1024) NULL,
  `assigner_org_id` BINARY(16) NULL,
  `valid_from` DATETIME(6) NULL,
  `valid_to` DATETIME(6) NULL,
  `status` VARCHAR(100) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_patient__patient_identifier_tenant_id_system_value_hmac` (`tenant_id`, `system`, `value_hmac`),
  KEY `ix_patient__patient_identifier_tenant_id` (`tenant_id`),
  KEY `ix_patient__patient_identifier_patient_id` (`patient_id`),
  KEY `ix_patient__patient_identifier_status` (`status`),
  KEY `ix_patient__patient_identifier_created_at` (`created_at`),
  KEY `ix_patient__patient_identifier_assigner_org_id` (`assigner_org_id`),
  KEY `ix_patient__patient_identifier_source_system_id` (`source_system_id`),
  KEY `ix_patient__patient_identifier_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Identifiants';

CREATE TABLE IF NOT EXISTS `patient__patient_address` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `use` VARCHAR(100) NULL,
  `city` VARCHAR(255) NULL,
  `region` VARCHAR(255) NULL,
  `postal_hmac` VARBINARY(1024) NULL,
  `country` CHAR(3) NULL,
  `valid_from` DATETIME(6) NULL,
  `valid_to` DATETIME(6) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_patient__patient_address_tenant_id` (`tenant_id`),
  KEY `ix_patient__patient_address_patient_id` (`patient_id`),
  KEY `ix_patient__patient_address_created_at` (`created_at`),
  KEY `ix_patient__patient_address_source_system_id` (`source_system_id`),
  KEY `ix_patient__patient_address_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Adresse';

CREATE TABLE IF NOT EXISTS `patient__patient_contact_point` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `system` VARCHAR(100) NULL,
  `use` VARCHAR(100) NULL,
  `value_ciphertext` VARBINARY(1024) NULL,
  `value_hmac` VARBINARY(1024) NULL,
  `verified_at` DATETIME(6) NULL,
  `rank` INT NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_patient__patient_contact_point_tenant_id` (`tenant_id`),
  KEY `ix_patient__patient_contact_point_patient_id` (`patient_id`),
  KEY `ix_patient__patient_contact_point_created_at` (`created_at`),
  KEY `ix_patient__patient_contact_point_source_system_id` (`source_system_id`),
  KEY `ix_patient__patient_contact_point_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Téléphone/courriel';

CREATE TABLE IF NOT EXISTS `patient__emergency_contact` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `related_person_id` BINARY(16) NULL,
  `name_ciphertext` VARBINARY(1024) NULL,
  `relationship_code` VARCHAR(100) NULL,
  `priority` INT NULL,
  `active` BOOLEAN NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_patient__emergency_contact_tenant_id` (`tenant_id`),
  KEY `ix_patient__emergency_contact_patient_id` (`patient_id`),
  KEY `ix_patient__emergency_contact_created_at` (`created_at`),
  KEY `ix_patient__emergency_contact_related_person_id` (`related_person_id`),
  KEY `ix_patient__emergency_contact_source_system_id` (`source_system_id`),
  KEY `ix_patient__emergency_contact_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Contact';

CREATE TABLE IF NOT EXISTS `patient__related_person` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `user_id` BINARY(16) NULL,
  `birth_date` DATE NULL,
  `identity_status` VARCHAR(100) NULL,
  `display_name_ciphertext` VARBINARY(1024) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_patient__related_person_tenant_id` (`tenant_id`),
  KEY `ix_patient__related_person_created_at` (`created_at`),
  KEY `ix_patient__related_person_user_id` (`user_id`),
  KEY `ix_patient__related_person_source_system_id` (`source_system_id`),
  KEY `ix_patient__related_person_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Proche';

CREATE TABLE IF NOT EXISTS `patient__patient_relationship` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `related_person_id` BINARY(16) NULL,
  `relationship_code` VARCHAR(100) NULL,
  `authority_type` VARCHAR(100) NULL,
  `valid_from` DATETIME(6) NULL,
  `valid_to` DATETIME(6) NULL,
  `evidence_document_id` BINARY(16) NULL,
  `status` VARCHAR(100) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_patient__patient_relationship_tenant_id` (`tenant_id`),
  KEY `ix_patient__patient_relationship_patient_id` (`patient_id`),
  KEY `ix_patient__patient_relationship_status` (`status`),
  KEY `ix_patient__patient_relationship_created_at` (`created_at`),
  KEY `ix_patient__patient_relationship_related_person_id` (`related_person_id`),
  KEY `ix_patient__patient_relationship_evidence_document_id` (`evidence_document_id`),
  KEY `ix_patient__patient_relationship_source_system_id` (`source_system_id`),
  KEY `ix_patient__patient_relationship_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Relation';

CREATE TABLE IF NOT EXISTS `patient__communication_preference` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `channel` VARCHAR(100) NULL,
  `purpose` VARCHAR(100) NULL,
  `locale` VARCHAR(64) NULL,
  `allowed` BOOLEAN NULL,
  `quiet_hours` JSON NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_patient__communication_preference_tenant_id` (`tenant_id`),
  KEY `ix_patient__communication_preference_patient_id` (`patient_id`),
  KEY `ix_patient__communication_preference_created_at` (`created_at`),
  KEY `ix_patient__communication_preference_source_system_id` (`source_system_id`),
  KEY `ix_patient__communication_preference_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Préférences';

CREATE TABLE IF NOT EXISTS `patient__accessibility_need` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `type_code` VARCHAR(100) NULL,
  `description` TEXT NULL,
  `severity` VARCHAR(255) NULL,
  `accommodation` TEXT NULL,
  `active` BOOLEAN NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_patient__accessibility_need_tenant_id` (`tenant_id`),
  KEY `ix_patient__accessibility_need_patient_id` (`patient_id`),
  KEY `ix_patient__accessibility_need_type_code` (`type_code`),
  KEY `ix_patient__accessibility_need_created_at` (`created_at`),
  KEY `ix_patient__accessibility_need_source_system_id` (`source_system_id`),
  KEY `ix_patient__accessibility_need_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Besoin';

CREATE TABLE IF NOT EXISTS `patient__advance_directive` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `directive_type` VARCHAR(100) NULL,
  `status` VARCHAR(100) NULL,
  `effective_date` DATE NULL,
  `document_id` BINARY(16) NULL,
  `custodian_org_id` BINARY(16) NULL,
  `verified_at` DATETIME(6) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_patient__advance_directive_tenant_id` (`tenant_id`),
  KEY `ix_patient__advance_directive_patient_id` (`patient_id`),
  KEY `ix_patient__advance_directive_status` (`status`),
  KEY `ix_patient__advance_directive_created_at` (`created_at`),
  KEY `ix_patient__advance_directive_document_id` (`document_id`),
  KEY `ix_patient__advance_directive_custodian_org_id` (`custodian_org_id`),
  KEY `ix_patient__advance_directive_source_system_id` (`source_system_id`),
  KEY `ix_patient__advance_directive_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Directive';

CREATE TABLE IF NOT EXISTS `patient__patient_declaration` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `declaration_type` VARCHAR(100) NULL,
  `value_code` VARCHAR(100) NULL,
  `effective_from` DATETIME(6) NULL,
  `effective_to` DATETIME(6) NULL,
  `evidence_document_id` BINARY(16) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_patient__patient_declaration_tenant_id` (`tenant_id`),
  KEY `ix_patient__patient_declaration_patient_id` (`patient_id`),
  KEY `ix_patient__patient_declaration_created_at` (`created_at`),
  KEY `ix_patient__patient_declaration_evidence_document_id` (`evidence_document_id`),
  KEY `ix_patient__patient_declaration_source_system_id` (`source_system_id`),
  KEY `ix_patient__patient_declaration_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Don d’organes/autres volontés';

CREATE TABLE IF NOT EXISTS `patient__patient_link` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `other_patient_id` BINARY(16) NULL,
  `link_type` VARCHAR(100) NULL,
  `confidence` DECIMAL(19,6) NULL,
  `status` VARCHAR(100) NULL,
  `adjudicated_by` VARCHAR(255) NULL,
  `reason` TEXT NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_patient__patient_link_tenant_id` (`tenant_id`),
  KEY `ix_patient__patient_link_patient_id` (`patient_id`),
  KEY `ix_patient__patient_link_status` (`status`),
  KEY `ix_patient__patient_link_created_at` (`created_at`),
  KEY `ix_patient__patient_link_other_patient_id` (`other_patient_id`),
  KEY `ix_patient__patient_link_source_system_id` (`source_system_id`),
  KEY `ix_patient__patient_link_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='MPI';

CREATE TABLE IF NOT EXISTS `patient__merge_history` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `surviving_patient_id` BINARY(16) NULL,
  `merged_patient_id` BINARY(16) NULL,
  `merged_at` DATETIME(6) NULL,
  `reason` TEXT NULL,
  `snapshot_uri` VARCHAR(512) NULL,
  `reversed_at` DATETIME(6) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_patient__merge_history_tenant_id` (`tenant_id`),
  KEY `ix_patient__merge_history_created_at` (`created_at`),
  KEY `ix_patient__merge_history_surviving_patient_id` (`surviving_patient_id`),
  KEY `ix_patient__merge_history_merged_patient_id` (`merged_patient_id`),
  KEY `ix_patient__merge_history_source_system_id` (`source_system_id`),
  KEY `ix_patient__merge_history_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Fusion réversible';

CREATE TABLE IF NOT EXISTS `patient__identity_match_case` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `score` DECIMAL(19,6) NULL,
  `match_features` JSON NULL,
  `status` VARCHAR(100) NULL,
  `assigned_to` BINARY(16) NULL,
  `resolved_at` DATETIME(6) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_patient__identity_match_case_tenant_id` (`tenant_id`),
  KEY `ix_patient__identity_match_case_status` (`status`),
  KEY `ix_patient__identity_match_case_created_at` (`created_at`),
  KEY `ix_patient__identity_match_case_source_system_id` (`source_system_id`),
  KEY `ix_patient__identity_match_case_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Revue MPI';

CREATE TABLE IF NOT EXISTS `org__organization` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `parent_id` BINARY(16) NULL,
  `type_code` VARCHAR(100) NULL,
  `legal_name` VARCHAR(255) NULL,
  `display_name` VARCHAR(255) NULL,
  `registration_no_hmac` VARBINARY(1024) NULL,
  `status` VARCHAR(100) NULL,
  `jurisdiction_id` BINARY(16) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_org__organization_tenant_id` (`tenant_id`),
  KEY `ix_org__organization_status` (`status`),
  KEY `ix_org__organization_type_code` (`type_code`),
  KEY `ix_org__organization_created_at` (`created_at`),
  KEY `ix_org__organization_parent_id` (`parent_id`),
  KEY `ix_org__organization_jurisdiction_id` (`jurisdiction_id`),
  KEY `ix_org__organization_source_system_id` (`source_system_id`),
  KEY `ix_org__organization_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Organisation';

CREATE TABLE IF NOT EXISTS `org__organization_identifier` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `organization_id` BINARY(16) NULL,
  `system` VARCHAR(100) NULL,
  `value` DECIMAL(19,6) NULL,
  `type` VARCHAR(100) NULL,
  `valid_from` DATETIME(6) NULL,
  `valid_to` DATETIME(6) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_org__organization_identifier_tenant_id_system_value` (`tenant_id`, `system`, `value`),
  KEY `ix_org__organization_identifier_tenant_id` (`tenant_id`),
  KEY `ix_org__organization_identifier_created_at` (`created_at`),
  KEY `ix_org__organization_identifier_organization_id` (`organization_id`),
  KEY `ix_org__organization_identifier_source_system_id` (`source_system_id`),
  KEY `ix_org__organization_identifier_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Identifiants';

CREATE TABLE IF NOT EXISTS `org__location` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `organization_id` BINARY(16) NULL,
  `parent_id` BINARY(16) NULL,
  `type_code` VARCHAR(100) NULL,
  `name` VARCHAR(255) NULL,
  `timezone` VARCHAR(64) NULL,
  `status` VARCHAR(100) NULL,
  `physical_type` VARCHAR(100) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_org__location_tenant_id` (`tenant_id`),
  KEY `ix_org__location_status` (`status`),
  KEY `ix_org__location_type_code` (`type_code`),
  KEY `ix_org__location_created_at` (`created_at`),
  KEY `ix_org__location_organization_id` (`organization_id`),
  KEY `ix_org__location_parent_id` (`parent_id`),
  KEY `ix_org__location_source_system_id` (`source_system_id`),
  KEY `ix_org__location_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Lieu';

CREATE TABLE IF NOT EXISTS `org__location_address` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `location_id` BINARY(16) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_org__location_address_tenant_id` (`tenant_id`),
  KEY `ix_org__location_address_created_at` (`created_at`),
  KEY `ix_org__location_address_location_id` (`location_id`),
  KEY `ix_org__location_address_source_system_id` (`source_system_id`),
  KEY `ix_org__location_address_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Adresse';

CREATE TABLE IF NOT EXISTS `org__department` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `organization_id` BINARY(16) NULL,
  `parent_id` BINARY(16) NULL,
  `code` VARCHAR(100) NULL,
  `name` VARCHAR(255) NULL,
  `status` VARCHAR(100) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_org__department_tenant_id` (`tenant_id`),
  KEY `ix_org__department_status` (`status`),
  KEY `ix_org__department_code` (`code`),
  KEY `ix_org__department_created_at` (`created_at`),
  KEY `ix_org__department_organization_id` (`organization_id`),
  KEY `ix_org__department_parent_id` (`parent_id`),
  KEY `ix_org__department_source_system_id` (`source_system_id`),
  KEY `ix_org__department_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Département';

CREATE TABLE IF NOT EXISTS `org__healthcare_service` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `organization_id` BINARY(16) NULL,
  `location_id` BINARY(16) NULL,
  `type_code` VARCHAR(100) NULL,
  `name` VARCHAR(255) NULL,
  `referral_required` VARCHAR(255) NULL,
  `virtual_available` VARCHAR(255) NULL,
  `active` BOOLEAN NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_org__healthcare_service_tenant_id` (`tenant_id`),
  KEY `ix_org__healthcare_service_type_code` (`type_code`),
  KEY `ix_org__healthcare_service_created_at` (`created_at`),
  KEY `ix_org__healthcare_service_organization_id` (`organization_id`),
  KEY `ix_org__healthcare_service_location_id` (`location_id`),
  KEY `ix_org__healthcare_service_source_system_id` (`source_system_id`),
  KEY `ix_org__healthcare_service_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Service';

CREATE TABLE IF NOT EXISTS `org__service_schedule` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `healthcare_service_id` BINARY(16) NULL,
  `day_of_week` VARCHAR(255) NULL,
  `start_time` VARCHAR(255) NULL,
  `end_time` VARCHAR(255) NULL,
  `effective_from` DATETIME(6) NULL,
  `effective_to` DATETIME(6) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_org__service_schedule_tenant_id` (`tenant_id`),
  KEY `ix_org__service_schedule_created_at` (`created_at`),
  KEY `ix_org__service_schedule_healthcare_service_id` (`healthcare_service_id`),
  KEY `ix_org__service_schedule_source_system_id` (`source_system_id`),
  KEY `ix_org__service_schedule_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Horaire';

CREATE TABLE IF NOT EXISTS `org__organization_endpoint` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `organization_id` BINARY(16) NULL,
  `endpoint_id` BINARY(16) NULL,
  `purpose` VARCHAR(100) NULL,
  `status` VARCHAR(100) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_org__organization_endpoint_tenant_id` (`tenant_id`),
  KEY `ix_org__organization_endpoint_status` (`status`),
  KEY `ix_org__organization_endpoint_created_at` (`created_at`),
  KEY `ix_org__organization_endpoint_organization_id` (`organization_id`),
  KEY `ix_org__organization_endpoint_endpoint_id` (`endpoint_id`),
  KEY `ix_org__organization_endpoint_source_system_id` (`source_system_id`),
  KEY `ix_org__organization_endpoint_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Endpoint métier';

CREATE TABLE IF NOT EXISTS `pro__practitioner` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `user_id` BINARY(16) NULL,
  `status` VARCHAR(100) NULL,
  `display_name` VARCHAR(255) NULL,
  `birth_date` DATE NULL,
  `professional_type` VARCHAR(100) NULL,
  `identity_verified_at` DATETIME(6) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_pro__practitioner_tenant_id` (`tenant_id`),
  KEY `ix_pro__practitioner_status` (`status`),
  KEY `ix_pro__practitioner_created_at` (`created_at`),
  KEY `ix_pro__practitioner_user_id` (`user_id`),
  KEY `ix_pro__practitioner_source_system_id` (`source_system_id`),
  KEY `ix_pro__practitioner_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Professionnel';

CREATE TABLE IF NOT EXISTS `pro__practitioner_identifier` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `practitioner_id` BINARY(16) NULL,
  `system` VARCHAR(100) NULL,
  `value_hmac` VARBINARY(1024) NULL,
  `jurisdiction_id` BINARY(16) NULL,
  `type` VARCHAR(100) NULL,
  `valid_from` DATETIME(6) NULL,
  `valid_to` DATETIME(6) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_pro__practitioner_identifier_tenant_id_system_value_hmac` (`tenant_id`, `system`, `value_hmac`),
  KEY `ix_pro__practitioner_identifier_tenant_id` (`tenant_id`),
  KEY `ix_pro__practitioner_identifier_created_at` (`created_at`),
  KEY `ix_pro__practitioner_identifier_practitioner_id` (`practitioner_id`),
  KEY `ix_pro__practitioner_identifier_jurisdiction_id` (`jurisdiction_id`),
  KEY `ix_pro__practitioner_identifier_source_system_id` (`source_system_id`),
  KEY `ix_pro__practitioner_identifier_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Numéro d’ordre';

CREATE TABLE IF NOT EXISTS `pro__license` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `practitioner_id` BINARY(16) NULL,
  `license_no_hmac` VARBINARY(1024) NULL,
  `profession_code` VARCHAR(100) NULL,
  `jurisdiction_id` BINARY(16) NULL,
  `status` VARCHAR(100) NULL,
  `issued_on` DATE NULL,
  `expires_on` DATE NULL,
  `restrictions` TEXT NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_pro__license_tenant_id` (`tenant_id`),
  KEY `ix_pro__license_status` (`status`),
  KEY `ix_pro__license_created_at` (`created_at`),
  KEY `ix_pro__license_practitioner_id` (`practitioner_id`),
  KEY `ix_pro__license_jurisdiction_id` (`jurisdiction_id`),
  KEY `ix_pro__license_source_system_id` (`source_system_id`),
  KEY `ix_pro__license_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Licence';

CREATE TABLE IF NOT EXISTS `pro__qualification` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `practitioner_id` BINARY(16) NULL,
  `type_code` VARCHAR(100) NULL,
  `title` VARCHAR(255) NULL,
  `issuer` VARCHAR(255) NULL,
  `issued_on` DATE NULL,
  `expires_on` DATE NULL,
  `verification_status` VARCHAR(100) NULL,
  `document_id` BINARY(16) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_pro__qualification_tenant_id` (`tenant_id`),
  KEY `ix_pro__qualification_type_code` (`type_code`),
  KEY `ix_pro__qualification_created_at` (`created_at`),
  KEY `ix_pro__qualification_practitioner_id` (`practitioner_id`),
  KEY `ix_pro__qualification_document_id` (`document_id`),
  KEY `ix_pro__qualification_source_system_id` (`source_system_id`),
  KEY `ix_pro__qualification_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Diplôme/certification';

CREATE TABLE IF NOT EXISTS `pro__specialty` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `practitioner_id` BINARY(16) NULL,
  `specialty_code` VARCHAR(100) NULL,
  `is_primary` BOOLEAN NULL,
  `verified_at` DATETIME(6) NULL,
  `valid_from` DATETIME(6) NULL,
  `valid_to` DATETIME(6) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_pro__specialty_tenant_id` (`tenant_id`),
  KEY `ix_pro__specialty_created_at` (`created_at`),
  KEY `ix_pro__specialty_practitioner_id` (`practitioner_id`),
  KEY `ix_pro__specialty_source_system_id` (`source_system_id`),
  KEY `ix_pro__specialty_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Spécialité';

CREATE TABLE IF NOT EXISTS `pro__affiliation` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `practitioner_id` BINARY(16) NULL,
  `organization_id` BINARY(16) NULL,
  `department_id` BINARY(16) NULL,
  `role_code` VARCHAR(100) NULL,
  `employment_status` VARCHAR(100) NULL,
  `valid_from` DATETIME(6) NULL,
  `valid_to` DATETIME(6) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_pro__affiliation_tenant_id` (`tenant_id`),
  KEY `ix_pro__affiliation_created_at` (`created_at`),
  KEY `ix_pro__affiliation_practitioner_id` (`practitioner_id`),
  KEY `ix_pro__affiliation_organization_id` (`organization_id`),
  KEY `ix_pro__affiliation_department_id` (`department_id`),
  KEY `ix_pro__affiliation_source_system_id` (`source_system_id`),
  KEY `ix_pro__affiliation_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Affiliation';

CREATE TABLE IF NOT EXISTS `pro__privilege` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `affiliation_id` BINARY(16) NULL,
  `privilege_code` VARCHAR(100) NULL,
  `location_id` BINARY(16) NULL,
  `valid_from` DATETIME(6) NULL,
  `valid_to` DATETIME(6) NULL,
  `status` VARCHAR(100) NULL,
  `approved_by` BINARY(16) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_pro__privilege_tenant_id` (`tenant_id`),
  KEY `ix_pro__privilege_status` (`status`),
  KEY `ix_pro__privilege_created_at` (`created_at`),
  KEY `ix_pro__privilege_affiliation_id` (`affiliation_id`),
  KEY `ix_pro__privilege_location_id` (`location_id`),
  KEY `ix_pro__privilege_source_system_id` (`source_system_id`),
  KEY `ix_pro__privilege_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Privilège clinique';

CREATE TABLE IF NOT EXISTS `pro__professional_address` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `practitioner_id` BINARY(16) NULL,
  `organization_id` BINARY(16) NULL,
  `location_id` BINARY(16) NULL,
  `is_primary` BOOLEAN NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_pro__professional_address_tenant_id` (`tenant_id`),
  KEY `ix_pro__professional_address_created_at` (`created_at`),
  KEY `ix_pro__professional_address_practitioner_id` (`practitioner_id`),
  KEY `ix_pro__professional_address_organization_id` (`organization_id`),
  KEY `ix_pro__professional_address_location_id` (`location_id`),
  KEY `ix_pro__professional_address_source_system_id` (`source_system_id`),
  KEY `ix_pro__professional_address_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Coordonnées';

CREATE TABLE IF NOT EXISTS `pro__availability` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `practitioner_id` BINARY(16) NULL,
  `location_id` BINARY(16) NULL,
  `day_of_week` VARCHAR(255) NULL,
  `start_time` VARCHAR(255) NULL,
  `end_time` VARCHAR(255) NULL,
  `appointment_type` VARCHAR(100) NULL,
  `effective_from` DATETIME(6) NULL,
  `effective_to` DATETIME(6) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_pro__availability_tenant_id` (`tenant_id`),
  KEY `ix_pro__availability_created_at` (`created_at`),
  KEY `ix_pro__availability_practitioner_id` (`practitioner_id`),
  KEY `ix_pro__availability_location_id` (`location_id`),
  KEY `ix_pro__availability_source_system_id` (`source_system_id`),
  KEY `ix_pro__availability_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Disponibilité';

CREATE TABLE IF NOT EXISTS `pro__signature_credential` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `practitioner_id` BINARY(16) NULL,
  `certificate_ref` VARCHAR(255) NULL,
  `serial_hmac` VARBINARY(1024) NULL,
  `issuer` VARCHAR(255) NULL,
  `valid_from` DATETIME(6) NULL,
  `valid_to` DATETIME(6) NULL,
  `revoked_at` DATETIME(6) NULL,
  `assurance_level` VARCHAR(100) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_pro__signature_credential_tenant_id` (`tenant_id`),
  KEY `ix_pro__signature_credential_created_at` (`created_at`),
  KEY `ix_pro__signature_credential_practitioner_id` (`practitioner_id`),
  KEY `ix_pro__signature_credential_source_system_id` (`source_system_id`),
  KEY `ix_pro__signature_credential_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Certificat';

CREATE TABLE IF NOT EXISTS `pro__verification_check` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `practitioner_id` BINARY(16) NULL,
  `check_type` VARCHAR(100) NULL,
  `source` VARCHAR(255) NULL,
  `checked_at` DATETIME(6) NULL,
  `outcome` VARCHAR(100) NULL,
  `evidence_hash` VARBINARY(1024) NULL,
  `next_due_at` DATETIME(6) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_pro__verification_check_tenant_id` (`tenant_id`),
  KEY `ix_pro__verification_check_created_at` (`created_at`),
  KEY `ix_pro__verification_check_practitioner_id` (`practitioner_id`),
  KEY `ix_pro__verification_check_source_system_id` (`source_system_id`),
  KEY `ix_pro__verification_check_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Vérification registre';

CREATE TABLE IF NOT EXISTS `consent__consent_directive` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `grantor_type` VARCHAR(100) NULL,
  `grantor_id` BINARY(16) NULL,
  `category` VARCHAR(255) NULL,
  `status` VARCHAR(100) NULL,
  `current_version_no` VARCHAR(255) NULL,
  `effective_from` DATETIME(6) NULL,
  `effective_to` DATETIME(6) NULL,
  `revoked_at` DATETIME(6) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_consent__consent_directive_tenant_id` (`tenant_id`),
  KEY `ix_consent__consent_directive_patient_id` (`patient_id`),
  KEY `ix_consent__consent_directive_status` (`status`),
  KEY `ix_consent__consent_directive_created_at` (`created_at`),
  KEY `ix_consent__consent_directive_grantor_id` (`grantor_id`),
  KEY `ix_consent__consent_directive_source_system_id` (`source_system_id`),
  KEY `ix_consent__consent_directive_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Agrégat';

CREATE TABLE IF NOT EXISTS `consent__consent_version` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `consent_id` BINARY(16) NULL,
  `version_no` INT NULL,
  `policy_text_id` BINARY(16) NULL,
  `language` VARCHAR(64) NULL,
  `decision` VARCHAR(255) NULL,
  `purpose_codes` JSON NULL,
  `compiled_policy` JSON NULL,
  `evidence_hash` VARBINARY(1024) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_consent__consent_version_tenant_id` (`tenant_id`),
  KEY `ix_consent__consent_version_created_at` (`created_at`),
  KEY `ix_consent__consent_version_consent_id` (`consent_id`),
  KEY `ix_consent__consent_version_policy_text_id` (`policy_text_id`),
  KEY `ix_consent__consent_version_source_system_id` (`source_system_id`),
  KEY `ix_consent__consent_version_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Version';

CREATE TABLE IF NOT EXISTS `consent__consent_grantee` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `consent_version_id` BINARY(16) NULL,
  `grantee_type` VARCHAR(100) NULL,
  `practitioner_id` BINARY(16) NULL,
  `organization_id` BINARY(16) NULL,
  `related_person_id` BINARY(16) NULL,
  `role_code` VARCHAR(100) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_consent__consent_grantee_tenant_id` (`tenant_id`),
  KEY `ix_consent__consent_grantee_created_at` (`created_at`),
  KEY `ix_consent__consent_grantee_consent_version_id` (`consent_version_id`),
  KEY `ix_consent__consent_grantee_practitioner_id` (`practitioner_id`),
  KEY `ix_consent__consent_grantee_organization_id` (`organization_id`),
  KEY `ix_consent__consent_grantee_related_person_id` (`related_person_id`),
  KEY `ix_consent__consent_grantee_source_system_id` (`source_system_id`),
  KEY `ix_consent__consent_grantee_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Bénéficiaire';

CREATE TABLE IF NOT EXISTS `consent__consent_scope` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `consent_version_id` BINARY(16) NULL,
  `resource_type` VARCHAR(100) NULL,
  `category_code` VARCHAR(100) NULL,
  `action` VARCHAR(100) NULL,
  `clinical_from` DATETIME(6) NULL,
  `clinical_to` DATETIME(6) NULL,
  `security_labels` JSON NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_consent__consent_scope_tenant_id` (`tenant_id`),
  KEY `ix_consent__consent_scope_created_at` (`created_at`),
  KEY `ix_consent__consent_scope_consent_version_id` (`consent_version_id`),
  KEY `ix_consent__consent_scope_source_system_id` (`source_system_id`),
  KEY `ix_consent__consent_scope_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Portée';

CREATE TABLE IF NOT EXISTS `consent__consent_exclusion` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `consent_version_id` BINARY(16) NULL,
  `resource_id` BINARY(16) NULL,
  `code` VARCHAR(100) NULL,
  `author_id` BINARY(16) NULL,
  `organization_id` BINARY(16) NULL,
  `reason` TEXT NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_consent__consent_exclusion_tenant_id` (`tenant_id`),
  KEY `ix_consent__consent_exclusion_code` (`code`),
  KEY `ix_consent__consent_exclusion_created_at` (`created_at`),
  KEY `ix_consent__consent_exclusion_consent_version_id` (`consent_version_id`),
  KEY `ix_consent__consent_exclusion_resource_id` (`resource_id`),
  KEY `ix_consent__consent_exclusion_author_id` (`author_id`),
  KEY `ix_consent__consent_exclusion_organization_id` (`organization_id`),
  KEY `ix_consent__consent_exclusion_source_system_id` (`source_system_id`),
  KEY `ix_consent__consent_exclusion_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Exclusion';

CREATE TABLE IF NOT EXISTS `consent__consent_obligation` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `consent_version_id` BINARY(16) NULL,
  `obligation_code` VARCHAR(100) NULL,
  `parameters` JSON NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_consent__consent_obligation_tenant_id` (`tenant_id`),
  KEY `ix_consent__consent_obligation_created_at` (`created_at`),
  KEY `ix_consent__consent_obligation_consent_version_id` (`consent_version_id`),
  KEY `ix_consent__consent_obligation_source_system_id` (`source_system_id`),
  KEY `ix_consent__consent_obligation_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Obligation';

CREATE TABLE IF NOT EXISTS `consent__consent_evidence` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `consent_version_id` BINARY(16) NULL,
  `evidence_type` VARCHAR(100) NULL,
  `document_id` BINARY(16) NULL,
  `signed_at` DATETIME(6) NULL,
  `signature_id` BINARY(16) NULL,
  `channel` VARCHAR(100) NULL,
  `ip_prefix` VARCHAR(255) NULL,
  `device_id` BINARY(16) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_consent__consent_evidence_tenant_id` (`tenant_id`),
  KEY `ix_consent__consent_evidence_created_at` (`created_at`),
  KEY `ix_consent__consent_evidence_consent_version_id` (`consent_version_id`),
  KEY `ix_consent__consent_evidence_document_id` (`document_id`),
  KEY `ix_consent__consent_evidence_signature_id` (`signature_id`),
  KEY `ix_consent__consent_evidence_device_id` (`device_id`),
  KEY `ix_consent__consent_evidence_source_system_id` (`source_system_id`),
  KEY `ix_consent__consent_evidence_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Preuve';

CREATE TABLE IF NOT EXISTS `consent__access_request` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `requester_practitioner_id` BINARY(16) NULL,
  `requester_org_id` BINARY(16) NULL,
  `purpose_code` VARCHAR(100) NULL,
  `requested_from` DATETIME(6) NULL,
  `requested_to` DATETIME(6) NULL,
  `status` VARCHAR(100) NULL,
  `expires_at` DATETIME(6) NULL,
  `qr_challenge_id` BINARY(16) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_consent__access_request_tenant_id` (`tenant_id`),
  KEY `ix_consent__access_request_patient_id` (`patient_id`),
  KEY `ix_consent__access_request_status` (`status`),
  KEY `ix_consent__access_request_created_at` (`created_at`),
  KEY `ix_consent__access_request_requester_practitioner_id` (`requester_practitioner_id`),
  KEY `ix_consent__access_request_requester_org_id` (`requester_org_id`),
  KEY `ix_consent__access_request_qr_challenge_id` (`qr_challenge_id`),
  KEY `ix_consent__access_request_source_system_id` (`source_system_id`),
  KEY `ix_consent__access_request_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Demande';

CREATE TABLE IF NOT EXISTS `consent__access_request_scope` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `access_request_id` BINARY(16) NULL,
  `resource_type` VARCHAR(100) NULL,
  `category_code` VARCHAR(100) NULL,
  `action` VARCHAR(100) NULL,
  `date_from` DATETIME(6) NULL,
  `date_to` DATETIME(6) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_consent__access_request_scope_tenant_id` (`tenant_id`),
  KEY `ix_consent__access_request_scope_created_at` (`created_at`),
  KEY `ix_consent__access_request_scope_access_request_id` (`access_request_id`),
  KEY `ix_consent__access_request_scope_source_system_id` (`source_system_id`),
  KEY `ix_consent__access_request_scope_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Portée demandée';

CREATE TABLE IF NOT EXISTS `consent__access_decision` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `access_request_id` BINARY(16) NULL,
  `decider_user_id` BINARY(16) NULL,
  `decision` VARCHAR(255) NULL,
  `reason_code` TEXT NULL,
  `decided_at` DATETIME(6) NULL,
  `consent_version_id` BINARY(16) NULL,
  `policy_result_id` BINARY(16) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_consent__access_decision_tenant_id` (`tenant_id`),
  KEY `ix_consent__access_decision_created_at` (`created_at`),
  KEY `ix_consent__access_decision_access_request_id` (`access_request_id`),
  KEY `ix_consent__access_decision_decider_user_id` (`decider_user_id`),
  KEY `ix_consent__access_decision_consent_version_id` (`consent_version_id`),
  KEY `ix_consent__access_decision_policy_result_id` (`policy_result_id`),
  KEY `ix_consent__access_decision_source_system_id` (`source_system_id`),
  KEY `ix_consent__access_decision_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Décision';

CREATE TABLE IF NOT EXISTS `consent__access_grant` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `subject_user_id` BINARY(16) NULL,
  `organization_id` BINARY(16) NULL,
  `consent_version_id` BINARY(16) NULL,
  `purpose_code` VARCHAR(100) NULL,
  `valid_from` DATETIME(6) NULL,
  `valid_to` DATETIME(6) NULL,
  `status` VARCHAR(100) NULL,
  `max_uses` INT NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_consent__access_grant_tenant_id` (`tenant_id`),
  KEY `ix_consent__access_grant_patient_id` (`patient_id`),
  KEY `ix_consent__access_grant_status` (`status`),
  KEY `ix_consent__access_grant_created_at` (`created_at`),
  KEY `ix_consent__access_grant_subject_user_id` (`subject_user_id`),
  KEY `ix_consent__access_grant_organization_id` (`organization_id`),
  KEY `ix_consent__access_grant_consent_version_id` (`consent_version_id`),
  KEY `ix_consent__access_grant_source_system_id` (`source_system_id`),
  KEY `ix_consent__access_grant_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Autorisation matérialisée';

CREATE TABLE IF NOT EXISTS `consent__access_grant_scope` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `grant_id` BINARY(16) NULL,
  `resource_type` VARCHAR(100) NULL,
  `category_code` VARCHAR(100) NULL,
  `action` VARCHAR(100) NULL,
  `field_mask` JSON NULL,
  `date_from` DATETIME(6) NULL,
  `date_to` DATETIME(6) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_consent__access_grant_scope_tenant_id` (`tenant_id`),
  KEY `ix_consent__access_grant_scope_created_at` (`created_at`),
  KEY `ix_consent__access_grant_scope_grant_id` (`grant_id`),
  KEY `ix_consent__access_grant_scope_source_system_id` (`source_system_id`),
  KEY `ix_consent__access_grant_scope_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Portée effective';

CREATE TABLE IF NOT EXISTS `consent__qr_challenge` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `token_version` VARCHAR(255) NULL,
  `expires_at` DATETIME(6) NULL,
  `consumed_at` DATETIME(6) NULL,
  `revoked_at` DATETIME(6) NULL,
  `preset_scope` JSON NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_consent__qr_challenge_tenant_id` (`tenant_id`),
  KEY `ix_consent__qr_challenge_patient_id` (`patient_id`),
  KEY `ix_consent__qr_challenge_created_at` (`created_at`),
  KEY `ix_consent__qr_challenge_source_system_id` (`source_system_id`),
  KEY `ix_consent__qr_challenge_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Challenge';

CREATE TABLE IF NOT EXISTS `consent__break_glass_event` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `practitioner_id` BINARY(16) NULL,
  `organization_id` BINARY(16) NULL,
  `reason_code` TEXT NULL,
  `justification` VARCHAR(255) NULL,
  `started_at` DATETIME(6) NULL,
  `expires_at` DATETIME(6) NULL,
  `review_status` VARCHAR(100) NULL,
  `reviewer_id` BINARY(16) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_consent__break_glass_event_tenant_id` (`tenant_id`),
  KEY `ix_consent__break_glass_event_patient_id` (`patient_id`),
  KEY `ix_consent__break_glass_event_created_at` (`created_at`),
  KEY `ix_consent__break_glass_event_practitioner_id` (`practitioner_id`),
  KEY `ix_consent__break_glass_event_organization_id` (`organization_id`),
  KEY `ix_consent__break_glass_event_reviewer_id` (`reviewer_id`),
  KEY `ix_consent__break_glass_event_source_system_id` (`source_system_id`),
  KEY `ix_consent__break_glass_event_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Urgence';

CREATE TABLE IF NOT EXISTS `consent__policy` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `code` VARCHAR(100) NULL,
  `name` VARCHAR(255) NULL,
  `jurisdiction_id` BINARY(16) NULL,
  `version` VARCHAR(255) NULL,
  `language` VARCHAR(64) NULL,
  `source_uri` VARCHAR(512) NULL,
  `status` VARCHAR(100) NULL,
  `effective_from` DATETIME(6) NULL,
  `effective_to` DATETIME(6) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_consent__policy_tenant_id` (`tenant_id`),
  KEY `ix_consent__policy_status` (`status`),
  KEY `ix_consent__policy_code` (`code`),
  KEY `ix_consent__policy_created_at` (`created_at`),
  KEY `ix_consent__policy_jurisdiction_id` (`jurisdiction_id`),
  KEY `ix_consent__policy_source_system_id` (`source_system_id`),
  KEY `ix_consent__policy_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Politique';

CREATE TABLE IF NOT EXISTS `consent__policy_rule` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `policy_id` BINARY(16) NULL,
  `priority` INT NULL,
  `effect` VARCHAR(100) NULL,
  `target` JSON NULL,
  `condition_expression` TEXT NULL,
  `obligations` JSON NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_consent__policy_rule_tenant_id` (`tenant_id`),
  KEY `ix_consent__policy_rule_created_at` (`created_at`),
  KEY `ix_consent__policy_rule_policy_id` (`policy_id`),
  KEY `ix_consent__policy_rule_source_system_id` (`source_system_id`),
  KEY `ix_consent__policy_rule_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Règle';

CREATE TABLE IF NOT EXISTS `consent__policy_decision_log` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `request_hash` VARBINARY(1024) NULL,
  `subject_id` BINARY(16) NULL,
  `patient_id` BINARY(16) NULL,
  `resource_ref` VARCHAR(255) NULL,
  `action` VARCHAR(100) NULL,
  `decision` VARCHAR(255) NULL,
  `matched_rule_ids` JSON NULL,
  `obligations` VARCHAR(255) NULL,
  `decided_at` DATETIME(6) NULL,
  `latency_ms` VARCHAR(255) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_consent__policy_decision_log_tenant_id` (`tenant_id`),
  KEY `ix_consent__policy_decision_log_patient_id` (`patient_id`),
  KEY `ix_consent__policy_decision_log_created_at` (`created_at`),
  KEY `ix_consent__policy_decision_log_subject_id` (`subject_id`),
  KEY `ix_consent__policy_decision_log_source_system_id` (`source_system_id`),
  KEY `ix_consent__policy_decision_log_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Résultat PDP';

CREATE TABLE IF NOT EXISTS `consent__revocation_event` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `target_type` VARCHAR(100) NULL,
  `target_id` BINARY(16) NULL,
  `reason` TEXT NULL,
  `effective_at` DATETIME(6) NULL,
  `initiated_by` BINARY(16) NULL,
  `propagated_at` DATETIME(6) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_consent__revocation_event_tenant_id` (`tenant_id`),
  KEY `ix_consent__revocation_event_created_at` (`created_at`),
  KEY `ix_consent__revocation_event_target_id` (`target_id`),
  KEY `ix_consent__revocation_event_source_system_id` (`source_system_id`),
  KEY `ix_consent__revocation_event_external_id` (`external_id`),
  KEY `ix_consent__revocation_event_effective_at` (`effective_at`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Révocation';

CREATE TABLE IF NOT EXISTS `clinical__episode_of_care` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `type_code` VARCHAR(100) NULL,
  `status` VARCHAR(100) NULL,
  `managing_org_id` BINARY(16) NULL,
  `start_at` DATETIME(6) NULL,
  `start_end_at` DATETIME(6) NULL,
  `care_manager_id` BINARY(16) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_clinical__episode_of_care_tenant_id` (`tenant_id`),
  KEY `ix_clinical__episode_of_care_patient_id` (`patient_id`),
  KEY `ix_clinical__episode_of_care_status` (`status`),
  KEY `ix_clinical__episode_of_care_type_code` (`type_code`),
  KEY `ix_clinical__episode_of_care_created_at` (`created_at`),
  KEY `ix_clinical__episode_of_care_managing_org_id` (`managing_org_id`),
  KEY `ix_clinical__episode_of_care_care_manager_id` (`care_manager_id`),
  KEY `ix_clinical__episode_of_care_source_system_id` (`source_system_id`),
  KEY `ix_clinical__episode_of_care_external_id` (`external_id`),
  KEY `ix_clinical__episode_of_care_start_at` (`start_at`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Épisode';

CREATE TABLE IF NOT EXISTS `clinical__encounter` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `episode_id` BINARY(16) NULL,
  `class_code` VARCHAR(100) NULL,
  `type_code` VARCHAR(100) NULL,
  `status` VARCHAR(100) NULL,
  `service_org_id` BINARY(16) NULL,
  `location_id` BINARY(16) NULL,
  `start_at` DATETIME(6) NULL,
  `start_end_at` DATETIME(6) NULL,
  `reason_text` TEXT NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_clinical__encounter_tenant_id` (`tenant_id`),
  KEY `ix_clinical__encounter_patient_id` (`patient_id`),
  KEY `ix_clinical__encounter_status` (`status`),
  KEY `ix_clinical__encounter_type_code` (`type_code`),
  KEY `ix_clinical__encounter_created_at` (`created_at`),
  KEY `ix_clinical__encounter_episode_id` (`episode_id`),
  KEY `ix_clinical__encounter_service_org_id` (`service_org_id`),
  KEY `ix_clinical__encounter_location_id` (`location_id`),
  KEY `ix_clinical__encounter_source_system_id` (`source_system_id`),
  KEY `ix_clinical__encounter_external_id` (`external_id`),
  KEY `ix_clinical__encounter_start_at` (`start_at`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Rencontre';

CREATE TABLE IF NOT EXISTS `clinical__encounter_participant` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `encounter_id` BINARY(16) NULL,
  `practitioner_id` BINARY(16) NULL,
  `role_code` VARCHAR(100) NULL,
  `period_start` DATETIME(6) NULL,
  `period_end` DATETIME(6) NULL,
  `primary_participant` VARCHAR(255) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_clinical__encounter_participant_tenant_id` (`tenant_id`),
  KEY `ix_clinical__encounter_participant_created_at` (`created_at`),
  KEY `ix_clinical__encounter_participant_encounter_id` (`encounter_id`),
  KEY `ix_clinical__encounter_participant_practitioner_id` (`practitioner_id`),
  KEY `ix_clinical__encounter_participant_source_system_id` (`source_system_id`),
  KEY `ix_clinical__encounter_participant_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Participant';

CREATE TABLE IF NOT EXISTS `clinical__problem` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `clinical_status` VARCHAR(100) NULL,
  `verification_status` VARCHAR(100) NULL,
  `code` VARCHAR(100) NULL,
  `onset_at` DATETIME(6) NULL,
  `abatement_at` DATETIME(6) NULL,
  `severity_code` VARCHAR(100) NULL,
  `asserter_id` BINARY(16) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_clinical__problem_tenant_id` (`tenant_id`),
  KEY `ix_clinical__problem_patient_id` (`patient_id`),
  KEY `ix_clinical__problem_code` (`code`),
  KEY `ix_clinical__problem_created_at` (`created_at`),
  KEY `ix_clinical__problem_asserter_id` (`asserter_id`),
  KEY `ix_clinical__problem_source_system_id` (`source_system_id`),
  KEY `ix_clinical__problem_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Problème';

CREATE TABLE IF NOT EXISTS `clinical__diagnosis` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `encounter_id` BINARY(16) NULL,
  `patient_id` BINARY(16) NULL,
  `condition_id` BINARY(16) NULL,
  `code` VARCHAR(100) NULL,
  `rank` INT NULL,
  `use_code` VARCHAR(100) NULL,
  `certainty` VARCHAR(255) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_clinical__diagnosis_tenant_id` (`tenant_id`),
  KEY `ix_clinical__diagnosis_patient_id` (`patient_id`),
  KEY `ix_clinical__diagnosis_code` (`code`),
  KEY `ix_clinical__diagnosis_created_at` (`created_at`),
  KEY `ix_clinical__diagnosis_encounter_id` (`encounter_id`),
  KEY `ix_clinical__diagnosis_condition_id` (`condition_id`),
  KEY `ix_clinical__diagnosis_source_system_id` (`source_system_id`),
  KEY `ix_clinical__diagnosis_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Diagnostic de rencontre';

CREATE TABLE IF NOT EXISTS `clinical__allergy_intolerance` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `substance_code` VARCHAR(100) NULL,
  `clinical_status` VARCHAR(100) NULL,
  `verification_status` VARCHAR(100) NULL,
  `type` VARCHAR(100) NULL,
  `category` VARCHAR(255) NULL,
  `criticality` VARCHAR(255) NULL,
  `onset_at` DATETIME(6) NULL,
  `recorder_id` BINARY(16) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_clinical__allergy_intolerance_tenant_id` (`tenant_id`),
  KEY `ix_clinical__allergy_intolerance_patient_id` (`patient_id`),
  KEY `ix_clinical__allergy_intolerance_created_at` (`created_at`),
  KEY `ix_clinical__allergy_intolerance_recorder_id` (`recorder_id`),
  KEY `ix_clinical__allergy_intolerance_source_system_id` (`source_system_id`),
  KEY `ix_clinical__allergy_intolerance_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Allergie';

CREATE TABLE IF NOT EXISTS `clinical__allergy_reaction` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `allergy_id` BINARY(16) NULL,
  `manifestation_code` VARCHAR(100) NULL,
  `severity` VARCHAR(255) NULL,
  `description` TEXT NULL,
  `onset_at` DATETIME(6) NULL,
  `exposure_route` VARCHAR(255) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_clinical__allergy_reaction_tenant_id` (`tenant_id`),
  KEY `ix_clinical__allergy_reaction_created_at` (`created_at`),
  KEY `ix_clinical__allergy_reaction_allergy_id` (`allergy_id`),
  KEY `ix_clinical__allergy_reaction_source_system_id` (`source_system_id`),
  KEY `ix_clinical__allergy_reaction_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Réaction';

CREATE TABLE IF NOT EXISTS `clinical__family_history` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `relationship_code` VARCHAR(100) NULL,
  `relative_sex` VARCHAR(255) NULL,
  `relative_birth_period` VARCHAR(255) NULL,
  `deceased` BOOLEAN NULL,
  `note` TEXT NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_clinical__family_history_tenant_id` (`tenant_id`),
  KEY `ix_clinical__family_history_patient_id` (`patient_id`),
  KEY `ix_clinical__family_history_created_at` (`created_at`),
  KEY `ix_clinical__family_history_source_system_id` (`source_system_id`),
  KEY `ix_clinical__family_history_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Antécédent familial';

CREATE TABLE IF NOT EXISTS `clinical__family_history_condition` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `family_history_id` BINARY(16) NULL,
  `condition_code` VARCHAR(100) NULL,
  `onset_age` VARCHAR(255) NULL,
  `outcome_code` VARCHAR(100) NULL,
  `contributed_to_death` VARCHAR(255) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_clinical__family_history_condition_tenant_id` (`tenant_id`),
  KEY `ix_clinical__family_history_condition_created_at` (`created_at`),
  KEY `ix_clinical__family_history_condition_family_history_id` (`family_history_id`),
  KEY `ix_clinical__family_history_condition_source_system_id` (`source_system_id`),
  KEY `ix_clinical__family_history_condition_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Condition familiale';

CREATE TABLE IF NOT EXISTS `clinical__procedure` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `encounter_id` BINARY(16) NULL,
  `code` VARCHAR(100) NULL,
  `status` VARCHAR(100) NULL,
  `performed_start` VARCHAR(255) NULL,
  `performed_end` VARCHAR(255) NULL,
  `body_site_code` TEXT NULL,
  `outcome_code` VARCHAR(100) NULL,
  `performer_org_id` BINARY(16) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_clinical__procedure_tenant_id` (`tenant_id`),
  KEY `ix_clinical__procedure_patient_id` (`patient_id`),
  KEY `ix_clinical__procedure_status` (`status`),
  KEY `ix_clinical__procedure_code` (`code`),
  KEY `ix_clinical__procedure_created_at` (`created_at`),
  KEY `ix_clinical__procedure_encounter_id` (`encounter_id`),
  KEY `ix_clinical__procedure_performer_org_id` (`performer_org_id`),
  KEY `ix_clinical__procedure_source_system_id` (`source_system_id`),
  KEY `ix_clinical__procedure_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Procédure';

CREATE TABLE IF NOT EXISTS `clinical__procedure_participant` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `procedure_id` BINARY(16) NULL,
  `practitioner_id` BINARY(16) NULL,
  `role_code` VARCHAR(100) NULL,
  `organization_id` BINARY(16) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_clinical__procedure_participant_tenant_id` (`tenant_id`),
  KEY `ix_clinical__procedure_participant_created_at` (`created_at`),
  KEY `ix_clinical__procedure_participant_procedure_id` (`procedure_id`),
  KEY `ix_clinical__procedure_participant_practitioner_id` (`practitioner_id`),
  KEY `ix_clinical__procedure_participant_organization_id` (`organization_id`),
  KEY `ix_clinical__procedure_participant_source_system_id` (`source_system_id`),
  KEY `ix_clinical__procedure_participant_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Participants';

CREATE TABLE IF NOT EXISTS `clinical__hospitalization` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `encounter_id` BINARY(16) NULL,
  `admit_source` VARCHAR(255) NULL,
  `discharge_disposition` VARCHAR(255) NULL,
  `pre_admission_id` BINARY(16) NULL,
  `diet_preference` VARCHAR(255) NULL,
  `special_courtesy` VARCHAR(255) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_clinical__hospitalization_tenant_id` (`tenant_id`),
  KEY `ix_clinical__hospitalization_created_at` (`created_at`),
  KEY `ix_clinical__hospitalization_encounter_id` (`encounter_id`),
  KEY `ix_clinical__hospitalization_pre_admission_id` (`pre_admission_id`),
  KEY `ix_clinical__hospitalization_source_system_id` (`source_system_id`),
  KEY `ix_clinical__hospitalization_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Séjour';

CREATE TABLE IF NOT EXISTS `clinical__care_plan` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `encounter_id` BINARY(16) NULL,
  `status` VARCHAR(100) NULL,
  `intent` VARCHAR(255) NULL,
  `title` VARCHAR(255) NULL,
  `period_start` DATETIME(6) NULL,
  `period_end` DATETIME(6) NULL,
  `author_id` BINARY(16) NULL,
  `replaces_id` BINARY(16) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_clinical__care_plan_tenant_id` (`tenant_id`),
  KEY `ix_clinical__care_plan_patient_id` (`patient_id`),
  KEY `ix_clinical__care_plan_status` (`status`),
  KEY `ix_clinical__care_plan_created_at` (`created_at`),
  KEY `ix_clinical__care_plan_encounter_id` (`encounter_id`),
  KEY `ix_clinical__care_plan_author_id` (`author_id`),
  KEY `ix_clinical__care_plan_replaces_id` (`replaces_id`),
  KEY `ix_clinical__care_plan_source_system_id` (`source_system_id`),
  KEY `ix_clinical__care_plan_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Plan';

CREATE TABLE IF NOT EXISTS `clinical__care_goal` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `care_plan_id` BINARY(16) NULL,
  `patient_id` BINARY(16) NULL,
  `description` TEXT NULL,
  `priority` INT NULL,
  `status` VARCHAR(100) NULL,
  `target_measure_code` VARCHAR(100) NULL,
  `target_value` VARCHAR(255) NULL,
  `target_due_date` DATE NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_clinical__care_goal_tenant_id` (`tenant_id`),
  KEY `ix_clinical__care_goal_patient_id` (`patient_id`),
  KEY `ix_clinical__care_goal_status` (`status`),
  KEY `ix_clinical__care_goal_created_at` (`created_at`),
  KEY `ix_clinical__care_goal_care_plan_id` (`care_plan_id`),
  KEY `ix_clinical__care_goal_source_system_id` (`source_system_id`),
  KEY `ix_clinical__care_goal_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Objectif';

CREATE TABLE IF NOT EXISTS `clinical__care_activity` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `care_plan_id` BINARY(16) NULL,
  `goal_id` BINARY(16) NULL,
  `kind` VARCHAR(255) NULL,
  `code` VARCHAR(100) NULL,
  `status` VARCHAR(100) NULL,
  `scheduled_at` DATETIME(6) NULL,
  `performer_id` BINARY(16) NULL,
  `outcome` VARCHAR(100) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_clinical__care_activity_tenant_id` (`tenant_id`),
  KEY `ix_clinical__care_activity_status` (`status`),
  KEY `ix_clinical__care_activity_code` (`code`),
  KEY `ix_clinical__care_activity_created_at` (`created_at`),
  KEY `ix_clinical__care_activity_care_plan_id` (`care_plan_id`),
  KEY `ix_clinical__care_activity_goal_id` (`goal_id`),
  KEY `ix_clinical__care_activity_performer_id` (`performer_id`),
  KEY `ix_clinical__care_activity_source_system_id` (`source_system_id`),
  KEY `ix_clinical__care_activity_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Activité';

CREATE TABLE IF NOT EXISTS `clinical__clinical_note` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `encounter_id` BINARY(16) NULL,
  `note_type` TEXT NULL,
  `title` VARCHAR(255) NULL,
  `status` VARCHAR(100) NULL,
  `author_id` BINARY(16) NULL,
  `content_ciphertext` VARBINARY(1024) NULL,
  `signed_at` DATETIME(6) NULL,
  `supersedes_id` BINARY(16) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_clinical__clinical_note_tenant_id` (`tenant_id`),
  KEY `ix_clinical__clinical_note_patient_id` (`patient_id`),
  KEY `ix_clinical__clinical_note_status` (`status`),
  KEY `ix_clinical__clinical_note_created_at` (`created_at`),
  KEY `ix_clinical__clinical_note_encounter_id` (`encounter_id`),
  KEY `ix_clinical__clinical_note_author_id` (`author_id`),
  KEY `ix_clinical__clinical_note_supersedes_id` (`supersedes_id`),
  KEY `ix_clinical__clinical_note_source_system_id` (`source_system_id`),
  KEY `ix_clinical__clinical_note_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Note';

CREATE TABLE IF NOT EXISTS `clinical__social_history` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `category_code` VARCHAR(100) NULL,
  `value_code` VARCHAR(100) NULL,
  `value_text` VARCHAR(255) NULL,
  `effective_from` DATETIME(6) NULL,
  `effective_to` DATETIME(6) NULL,
  `verification_status` VARCHAR(100) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_clinical__social_history_tenant_id` (`tenant_id`),
  KEY `ix_clinical__social_history_patient_id` (`patient_id`),
  KEY `ix_clinical__social_history_created_at` (`created_at`),
  KEY `ix_clinical__social_history_source_system_id` (`source_system_id`),
  KEY `ix_clinical__social_history_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Habitude/déterminant';

CREATE TABLE IF NOT EXISTS `clinical__functional_status` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `assessment_code` VARCHAR(100) NULL,
  `value_code` VARCHAR(100) NULL,
  `value_score` DECIMAL(19,6) NULL,
  `assessed_at` DATETIME(6) NULL,
  `performer_id` BINARY(16) NULL,
  `instrument_version` VARCHAR(255) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_clinical__functional_status_tenant_id` (`tenant_id`),
  KEY `ix_clinical__functional_status_patient_id` (`patient_id`),
  KEY `ix_clinical__functional_status_created_at` (`created_at`),
  KEY `ix_clinical__functional_status_performer_id` (`performer_id`),
  KEY `ix_clinical__functional_status_source_system_id` (`source_system_id`),
  KEY `ix_clinical__functional_status_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Fonction';

CREATE TABLE IF NOT EXISTS `clinical__device_use` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `device_id` BINARY(16) NULL,
  `status` VARCHAR(100) NULL,
  `implanted_at` DATETIME(6) NULL,
  `explanted_at` DATETIME(6) NULL,
  `body_site` TEXT NULL,
  `udi_carrier` VARCHAR(255) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_clinical__device_use_tenant_id` (`tenant_id`),
  KEY `ix_clinical__device_use_patient_id` (`patient_id`),
  KEY `ix_clinical__device_use_status` (`status`),
  KEY `ix_clinical__device_use_created_at` (`created_at`),
  KEY `ix_clinical__device_use_device_id` (`device_id`),
  KEY `ix_clinical__device_use_source_system_id` (`source_system_id`),
  KEY `ix_clinical__device_use_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Dispositif/implant';

CREATE TABLE IF NOT EXISTS `clinical__adverse_event` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `encounter_id` BINARY(16) NULL,
  `category` VARCHAR(255) NULL,
  `event_code` VARCHAR(100) NULL,
  `seriousness` VARCHAR(255) NULL,
  `occurred_at` DATETIME(6) NULL,
  `detected_at` DATETIME(6) NULL,
  `outcome` VARCHAR(100) NULL,
  `status` VARCHAR(100) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_clinical__adverse_event_tenant_id` (`tenant_id`),
  KEY `ix_clinical__adverse_event_patient_id` (`patient_id`),
  KEY `ix_clinical__adverse_event_status` (`status`),
  KEY `ix_clinical__adverse_event_created_at` (`created_at`),
  KEY `ix_clinical__adverse_event_encounter_id` (`encounter_id`),
  KEY `ix_clinical__adverse_event_source_system_id` (`source_system_id`),
  KEY `ix_clinical__adverse_event_external_id` (`external_id`),
  KEY `ix_clinical__adverse_event_occurred_at` (`occurred_at`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Événement indésirable';

CREATE TABLE IF NOT EXISTS `clinical__pregnancy` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `status` VARCHAR(100) NULL,
  `estimated_due_date` DATE NULL,
  `last_menstrual_date` DATE NULL,
  `gravida` INT NULL,
  `para` INT NULL,
  `multiple_gestation` VARCHAR(255) NULL,
  `outcome_code` VARCHAR(100) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_clinical__pregnancy_tenant_id` (`tenant_id`),
  KEY `ix_clinical__pregnancy_patient_id` (`patient_id`),
  KEY `ix_clinical__pregnancy_status` (`status`),
  KEY `ix_clinical__pregnancy_created_at` (`created_at`),
  KEY `ix_clinical__pregnancy_source_system_id` (`source_system_id`),
  KEY `ix_clinical__pregnancy_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Grossesse';

CREATE TABLE IF NOT EXISTS `clinical__pregnancy_event` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `pregnancy_id` BINARY(16) NULL,
  `event_type` VARCHAR(100) NULL,
  `occurred_at` DATETIME(6) NULL,
  `gestational_age_days` INT NULL,
  `outcome` VARCHAR(100) NULL,
  `encounter_id` BINARY(16) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_clinical__pregnancy_event_tenant_id` (`tenant_id`),
  KEY `ix_clinical__pregnancy_event_created_at` (`created_at`),
  KEY `ix_clinical__pregnancy_event_pregnancy_id` (`pregnancy_id`),
  KEY `ix_clinical__pregnancy_event_encounter_id` (`encounter_id`),
  KEY `ix_clinical__pregnancy_event_source_system_id` (`source_system_id`),
  KEY `ix_clinical__pregnancy_event_external_id` (`external_id`),
  KEY `ix_clinical__pregnancy_event_occurred_at` (`occurred_at`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Événement obstétrical';

CREATE TABLE IF NOT EXISTS `clinical__mental_health_assessment` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `encounter_id` BINARY(16) NULL,
  `instrument_code` VARCHAR(100) NULL,
  `score` DECIMAL(19,6) NULL,
  `interpretation` VARCHAR(255) NULL,
  `assessed_at` DATETIME(6) NULL,
  `performer_id` BINARY(16) NULL,
  `risk_level` VARCHAR(100) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_clinical__mental_health_assessment_tenant_id` (`tenant_id`),
  KEY `ix_clinical__mental_health_assessment_patient_id` (`patient_id`),
  KEY `ix_clinical__mental_health_assessment_created_at` (`created_at`),
  KEY `ix_clinical__mental_health_assessment_encounter_id` (`encounter_id`),
  KEY `ix_clinical__mental_health_assessment_performer_id` (`performer_id`),
  KEY `ix_clinical__mental_health_assessment_source_system_id` (`source_system_id`),
  KEY `ix_clinical__mental_health_assessment_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Évaluation';

CREATE TABLE IF NOT EXISTS `clinical__rehabilitation_plan` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `care_plan_id` BINARY(16) NULL,
  `discipline_code` VARCHAR(100) NULL,
  `status` VARCHAR(100) NULL,
  `baseline` VARCHAR(255) NULL,
  `start` VARCHAR(255) NULL,
  `end` VARCHAR(255) NULL,
  `therapist_id` BINARY(16) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_clinical__rehabilitation_plan_tenant_id` (`tenant_id`),
  KEY `ix_clinical__rehabilitation_plan_patient_id` (`patient_id`),
  KEY `ix_clinical__rehabilitation_plan_status` (`status`),
  KEY `ix_clinical__rehabilitation_plan_created_at` (`created_at`),
  KEY `ix_clinical__rehabilitation_plan_care_plan_id` (`care_plan_id`),
  KEY `ix_clinical__rehabilitation_plan_therapist_id` (`therapist_id`),
  KEY `ix_clinical__rehabilitation_plan_source_system_id` (`source_system_id`),
  KEY `ix_clinical__rehabilitation_plan_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Réadaptation';

CREATE TABLE IF NOT EXISTS `clinical__nutrition_assessment` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `encounter_id` BINARY(16) NULL,
  `assessment_at` DATETIME(6) NULL,
  `diet_code` VARCHAR(100) NULL,
  `risk_score` DECIMAL(19,6) NULL,
  `energy_target` VARCHAR(255) NULL,
  `author_id` BINARY(16) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_clinical__nutrition_assessment_tenant_id` (`tenant_id`),
  KEY `ix_clinical__nutrition_assessment_patient_id` (`patient_id`),
  KEY `ix_clinical__nutrition_assessment_created_at` (`created_at`),
  KEY `ix_clinical__nutrition_assessment_encounter_id` (`encounter_id`),
  KEY `ix_clinical__nutrition_assessment_author_id` (`author_id`),
  KEY `ix_clinical__nutrition_assessment_source_system_id` (`source_system_id`),
  KEY `ix_clinical__nutrition_assessment_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Nutrition';

CREATE TABLE IF NOT EXISTS `clinical__immunization` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `vaccine_code` VARCHAR(100) NULL,
  `status` VARCHAR(100) NULL,
  `occurrence_at` DATETIME(6) NULL,
  `lot_no` VARCHAR(255) NULL,
  `manufacturer` VARCHAR(255) NULL,
  `dose_quantity` DECIMAL(19,6) NULL,
  `site_code` VARCHAR(100) NULL,
  `route_code` VARCHAR(100) NULL,
  `performer_id` BINARY(16) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_clinical__immunization_tenant_id` (`tenant_id`),
  KEY `ix_clinical__immunization_patient_id` (`patient_id`),
  KEY `ix_clinical__immunization_status` (`status`),
  KEY `ix_clinical__immunization_created_at` (`created_at`),
  KEY `ix_clinical__immunization_performer_id` (`performer_id`),
  KEY `ix_clinical__immunization_source_system_id` (`source_system_id`),
  KEY `ix_clinical__immunization_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Vaccination';

CREATE TABLE IF NOT EXISTS `clinical__immunization_recommendation` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `vaccine_code` VARCHAR(100) NULL,
  `forecast_status` VARCHAR(100) NULL,
  `due_date` DATE NULL,
  `overdue_date` DATE NULL,
  `reason_codes` JSON NULL,
  `algorithm_version` VARCHAR(255) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_clinical__immunization_recommendation_tenant_id` (`tenant_id`),
  KEY `ix_clinical__immunization_recommendation_patient_id` (`patient_id`),
  KEY `ix_clinical__immunization_recommendation_created_at` (`created_at`),
  KEY `ix_clinical__immunization_recommendation_source_system_id` (`source_system_id`),
  KEY `ix_clinical__immunization_recommendation_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Rappel';

CREATE TABLE IF NOT EXISTS `med__medication_catalog` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `code` VARCHAR(100) NULL,
  `code_system` VARCHAR(100) NULL,
  `brand_name` VARCHAR(255) NULL,
  `generic_name` VARCHAR(255) NULL,
  `form_code` VARCHAR(100) NULL,
  `strength_value` VARCHAR(255) NULL,
  `strength_unit` VARCHAR(255) NULL,
  `manufacturer` VARCHAR(255) NULL,
  `active` BOOLEAN NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_med__medication_catalog_tenant_id` (`tenant_id`),
  KEY `ix_med__medication_catalog_code` (`code`),
  KEY `ix_med__medication_catalog_created_at` (`created_at`),
  KEY `ix_med__medication_catalog_source_system_id` (`source_system_id`),
  KEY `ix_med__medication_catalog_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Produit';

CREATE TABLE IF NOT EXISTS `med__medication_ingredient` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `medication_id` BINARY(16) NULL,
  `substance_code` VARCHAR(100) NULL,
  `strength_numerator` VARCHAR(255) NULL,
  `strength_denominator` VARCHAR(255) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_med__medication_ingredient_tenant_id` (`tenant_id`),
  KEY `ix_med__medication_ingredient_created_at` (`created_at`),
  KEY `ix_med__medication_ingredient_medication_id` (`medication_id`),
  KEY `ix_med__medication_ingredient_source_system_id` (`source_system_id`),
  KEY `ix_med__medication_ingredient_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Ingrédient';

CREATE TABLE IF NOT EXISTS `med__prescription` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `encounter_id` BINARY(16) NULL,
  `prescriber_id` BINARY(16) NULL,
  `status` VARCHAR(100) NULL,
  `intent` VARCHAR(255) NULL,
  `authored_at` DATETIME(6) NULL,
  `valid_until` DATETIME(6) NULL,
  `prior_prescription_id` BINARY(16) NULL,
  `signature_id` BINARY(16) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_med__prescription_tenant_id` (`tenant_id`),
  KEY `ix_med__prescription_patient_id` (`patient_id`),
  KEY `ix_med__prescription_status` (`status`),
  KEY `ix_med__prescription_created_at` (`created_at`),
  KEY `ix_med__prescription_encounter_id` (`encounter_id`),
  KEY `ix_med__prescription_prescriber_id` (`prescriber_id`),
  KEY `ix_med__prescription_prior_prescription_id` (`prior_prescription_id`),
  KEY `ix_med__prescription_signature_id` (`signature_id`),
  KEY `ix_med__prescription_source_system_id` (`source_system_id`),
  KEY `ix_med__prescription_external_id` (`external_id`),
  KEY `ix_med__prescription_authored_at` (`authored_at`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Ordonnance';

CREATE TABLE IF NOT EXISTS `med__prescription_item` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `prescription_id` BINARY(16) NULL,
  `medication_id` BINARY(16) NULL,
  `sequence_no` INT NULL,
  `dose_text` VARCHAR(255) NULL,
  `route_code` VARCHAR(100) NULL,
  `frequency_code` VARCHAR(100) NULL,
  `duration` VARCHAR(255) NULL,
  `quantity` DECIMAL(19,6) NULL,
  `refills` INT NULL,
  `substitution_allowed` BOOLEAN NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_med__prescription_item_tenant_id` (`tenant_id`),
  KEY `ix_med__prescription_item_created_at` (`created_at`),
  KEY `ix_med__prescription_item_prescription_id` (`prescription_id`),
  KEY `ix_med__prescription_item_medication_id` (`medication_id`),
  KEY `ix_med__prescription_item_source_system_id` (`source_system_id`),
  KEY `ix_med__prescription_item_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Ligne';

CREATE TABLE IF NOT EXISTS `med__dosage_instruction` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `prescription_item_id` BINARY(16) NULL,
  `sequence` INT NULL,
  `timing` JSON NULL,
  `as_needed` BOOLEAN NULL,
  `dose_value` VARCHAR(255) NULL,
  `dose_unit` VARCHAR(255) NULL,
  `rate` DECIMAL(19,6) NULL,
  `max_dose` VARCHAR(255) NULL,
  `site_code` VARCHAR(100) NULL,
  `patient_instruction` TEXT NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_med__dosage_instruction_tenant_id` (`tenant_id`),
  KEY `ix_med__dosage_instruction_created_at` (`created_at`),
  KEY `ix_med__dosage_instruction_prescription_item_id` (`prescription_item_id`),
  KEY `ix_med__dosage_instruction_source_system_id` (`source_system_id`),
  KEY `ix_med__dosage_instruction_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Posologie structurée';

CREATE TABLE IF NOT EXISTS `med__prescription_validation` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `prescription_id` BINARY(16) NULL,
  `check_type` VARCHAR(100) NULL,
  `severity` VARCHAR(255) NULL,
  `message` VARCHAR(255) NULL,
  `evidence` VARCHAR(255) NULL,
  `outcome` VARCHAR(100) NULL,
  `resolved_by` BINARY(16) NULL,
  `resolved_at` DATETIME(6) NULL,
  `override_reason` TEXT NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_med__prescription_validation_tenant_id` (`tenant_id`),
  KEY `ix_med__prescription_validation_created_at` (`created_at`),
  KEY `ix_med__prescription_validation_prescription_id` (`prescription_id`),
  KEY `ix_med__prescription_validation_source_system_id` (`source_system_id`),
  KEY `ix_med__prescription_validation_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Contrôle';

CREATE TABLE IF NOT EXISTS `med__renewal_request` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `prescription_id` BINARY(16) NULL,
  `requester_type` VARCHAR(100) NULL,
  `requester_id` BINARY(16) NULL,
  `requested_at` DATETIME(6) NULL,
  `status` VARCHAR(100) NULL,
  `reason` TEXT NULL,
  `decided_by` VARCHAR(255) NULL,
  `decided_at` DATETIME(6) NULL,
  `new_prescription_id` BINARY(16) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_med__renewal_request_tenant_id` (`tenant_id`),
  KEY `ix_med__renewal_request_status` (`status`),
  KEY `ix_med__renewal_request_created_at` (`created_at`),
  KEY `ix_med__renewal_request_prescription_id` (`prescription_id`),
  KEY `ix_med__renewal_request_requester_id` (`requester_id`),
  KEY `ix_med__renewal_request_new_prescription_id` (`new_prescription_id`),
  KEY `ix_med__renewal_request_source_system_id` (`source_system_id`),
  KEY `ix_med__renewal_request_external_id` (`external_id`),
  KEY `ix_med__renewal_request_requested_at` (`requested_at`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Renouvellement';

CREATE TABLE IF NOT EXISTS `med__dispense` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `prescription_item_id` BINARY(16) NULL,
  `pharmacy_org_id` BINARY(16) NULL,
  `status` VARCHAR(100) NULL,
  `dispensed_at` DATETIME(6) NULL,
  `quantity` DECIMAL(19,6) NULL,
  `days_supply` VARCHAR(255) NULL,
  `lot_no` VARCHAR(255) NULL,
  `substitution_code` VARCHAR(100) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_med__dispense_tenant_id` (`tenant_id`),
  KEY `ix_med__dispense_patient_id` (`patient_id`),
  KEY `ix_med__dispense_status` (`status`),
  KEY `ix_med__dispense_created_at` (`created_at`),
  KEY `ix_med__dispense_prescription_item_id` (`prescription_item_id`),
  KEY `ix_med__dispense_pharmacy_org_id` (`pharmacy_org_id`),
  KEY `ix_med__dispense_source_system_id` (`source_system_id`),
  KEY `ix_med__dispense_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Dispensation';

CREATE TABLE IF NOT EXISTS `med__medication_administration` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `prescription_item_id` BINARY(16) NULL,
  `encounter_id` BINARY(16) NULL,
  `status` VARCHAR(100) NULL,
  `effective_at` DATETIME(6) NULL,
  `dose_value` VARCHAR(255) NULL,
  `dose_unit` VARCHAR(255) NULL,
  `route_code` VARCHAR(100) NULL,
  `performer_id` BINARY(16) NULL,
  `reason_not_given` TEXT NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_med__medication_administration_tenant_id` (`tenant_id`),
  KEY `ix_med__medication_administration_patient_id` (`patient_id`),
  KEY `ix_med__medication_administration_status` (`status`),
  KEY `ix_med__medication_administration_created_at` (`created_at`),
  KEY `ix_med__medication_administration_prescription_item_id` (`prescription_item_id`),
  KEY `ix_med__medication_administration_encounter_id` (`encounter_id`),
  KEY `ix_med__medication_administration_performer_id` (`performer_id`),
  KEY `ix_med__medication_administration_source_system_id` (`source_system_id`),
  KEY `ix_med__medication_administration_external_id` (`external_id`),
  KEY `ix_med__medication_administration_effective_at` (`effective_at`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Administration';

CREATE TABLE IF NOT EXISTS `med__medication_statement` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `medication_id` BINARY(16) NULL,
  `status` VARCHAR(100) NULL,
  `effective_from` DATETIME(6) NULL,
  `effective_to` DATETIME(6) NULL,
  `source_type` VARCHAR(100) NULL,
  `information_source_id` BINARY(16) NULL,
  `adherence_code` VARCHAR(100) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_med__medication_statement_tenant_id` (`tenant_id`),
  KEY `ix_med__medication_statement_patient_id` (`patient_id`),
  KEY `ix_med__medication_statement_status` (`status`),
  KEY `ix_med__medication_statement_created_at` (`created_at`),
  KEY `ix_med__medication_statement_medication_id` (`medication_id`),
  KEY `ix_med__medication_statement_information_source_id` (`information_source_id`),
  KEY `ix_med__medication_statement_source_system_id` (`source_system_id`),
  KEY `ix_med__medication_statement_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Déclaration d’usage';

CREATE TABLE IF NOT EXISTS `med__reconciliation` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `encounter_id` BINARY(16) NULL,
  `performed_by` BINARY(16) NULL,
  `performed_at` DATETIME(6) NULL,
  `status` VARCHAR(100) NULL,
  `summary` TEXT NULL,
  `signature_id` BINARY(16) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_med__reconciliation_tenant_id` (`tenant_id`),
  KEY `ix_med__reconciliation_patient_id` (`patient_id`),
  KEY `ix_med__reconciliation_status` (`status`),
  KEY `ix_med__reconciliation_created_at` (`created_at`),
  KEY `ix_med__reconciliation_encounter_id` (`encounter_id`),
  KEY `ix_med__reconciliation_signature_id` (`signature_id`),
  KEY `ix_med__reconciliation_source_system_id` (`source_system_id`),
  KEY `ix_med__reconciliation_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Rapprochement';

CREATE TABLE IF NOT EXISTS `med__reconciliation_item` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `reconciliation_id` BINARY(16) NULL,
  `medication_statement_id` BINARY(16) NULL,
  `prescription_item_id` BINARY(16) NULL,
  `decision` VARCHAR(255) NULL,
  `reason` TEXT NULL,
  `resulting_statement_id` BINARY(16) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_med__reconciliation_item_tenant_id` (`tenant_id`),
  KEY `ix_med__reconciliation_item_created_at` (`created_at`),
  KEY `ix_med__reconciliation_item_reconciliation_id` (`reconciliation_id`),
  KEY `ix_med__reconciliation_item_medication_statement_id` (`medication_statement_id`),
  KEY `ix_med__reconciliation_item_prescription_item_id` (`prescription_item_id`),
  KEY `ix_med__reconciliation_item_resulting_statement_id` (`resulting_statement_id`),
  KEY `ix_med__reconciliation_item_source_system_id` (`source_system_id`),
  KEY `ix_med__reconciliation_item_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Décision';

CREATE TABLE IF NOT EXISTS `lab__service_request` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `encounter_id` BINARY(16) NULL,
  `requester_id` BINARY(16) NULL,
  `performer_org_id` BINARY(16) NULL,
  `code` VARCHAR(100) NULL,
  `status` VARCHAR(100) NULL,
  `intent` VARCHAR(255) NULL,
  `priority` INT NULL,
  `authored_at` DATETIME(6) NULL,
  `occurrence_at` DATETIME(6) NULL,
  `reason_codes` JSON NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_lab__service_request_tenant_id` (`tenant_id`),
  KEY `ix_lab__service_request_patient_id` (`patient_id`),
  KEY `ix_lab__service_request_status` (`status`),
  KEY `ix_lab__service_request_code` (`code`),
  KEY `ix_lab__service_request_created_at` (`created_at`),
  KEY `ix_lab__service_request_encounter_id` (`encounter_id`),
  KEY `ix_lab__service_request_requester_id` (`requester_id`),
  KEY `ix_lab__service_request_performer_org_id` (`performer_org_id`),
  KEY `ix_lab__service_request_source_system_id` (`source_system_id`),
  KEY `ix_lab__service_request_external_id` (`external_id`),
  KEY `ix_lab__service_request_authored_at` (`authored_at`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Demande';

CREATE TABLE IF NOT EXISTS `lab__service_request_item` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `service_request_id` BINARY(16) NULL,
  `sequence_no` INT NULL,
  `loinc_code` VARCHAR(100) NULL,
  `specimen_type` VARCHAR(100) NULL,
  `body_site` TEXT NULL,
  `instructions` TEXT NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_lab__service_request_item_tenant_id` (`tenant_id`),
  KEY `ix_lab__service_request_item_created_at` (`created_at`),
  KEY `ix_lab__service_request_item_service_request_id` (`service_request_id`),
  KEY `ix_lab__service_request_item_source_system_id` (`source_system_id`),
  KEY `ix_lab__service_request_item_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Analyse demandée';

CREATE TABLE IF NOT EXISTS `lab__specimen` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `service_request_id` BINARY(16) NULL,
  `accession_no_hmac` VARBINARY(1024) NULL,
  `type_code` VARCHAR(100) NULL,
  `status` VARCHAR(100) NULL,
  `collected_at` DATETIME(6) NULL,
  `received_at` DATETIME(6) NULL,
  `collector_id` BINARY(16) NULL,
  `container_code` VARCHAR(100) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_lab__specimen_tenant_id` (`tenant_id`),
  KEY `ix_lab__specimen_patient_id` (`patient_id`),
  KEY `ix_lab__specimen_status` (`status`),
  KEY `ix_lab__specimen_type_code` (`type_code`),
  KEY `ix_lab__specimen_created_at` (`created_at`),
  KEY `ix_lab__specimen_service_request_id` (`service_request_id`),
  KEY `ix_lab__specimen_collector_id` (`collector_id`),
  KEY `ix_lab__specimen_source_system_id` (`source_system_id`),
  KEY `ix_lab__specimen_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Spécimen';

CREATE TABLE IF NOT EXISTS `lab__specimen_event` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `specimen_id` BINARY(16) NULL,
  `event_type` VARCHAR(100) NULL,
  `occurred_at` DATETIME(6) NULL,
  `actor_id` BINARY(16) NULL,
  `organization_id` BINARY(16) NULL,
  `location_id` BINARY(16) NULL,
  `condition_code` VARCHAR(100) NULL,
  `evidence_hash` VARBINARY(1024) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_lab__specimen_event_tenant_id` (`tenant_id`),
  KEY `ix_lab__specimen_event_created_at` (`created_at`),
  KEY `ix_lab__specimen_event_specimen_id` (`specimen_id`),
  KEY `ix_lab__specimen_event_actor_id` (`actor_id`),
  KEY `ix_lab__specimen_event_organization_id` (`organization_id`),
  KEY `ix_lab__specimen_event_location_id` (`location_id`),
  KEY `ix_lab__specimen_event_source_system_id` (`source_system_id`),
  KEY `ix_lab__specimen_event_external_id` (`external_id`),
  KEY `ix_lab__specimen_event_occurred_at` (`occurred_at`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Chaîne de possession';

CREATE TABLE IF NOT EXISTS `lab__diagnostic_report` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `service_request_id` BINARY(16) NULL,
  `status` VARCHAR(100) NULL,
  `category_code` VARCHAR(100) NULL,
  `code` VARCHAR(100) NULL,
  `effective_at` DATETIME(6) NULL,
  `issued_at` DATETIME(6) NULL,
  `performer_org_id` BINARY(16) NULL,
  `conclusion` TEXT NULL,
  `document_id` BINARY(16) NULL,
  `signature_id` BINARY(16) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_lab__diagnostic_report_tenant_id` (`tenant_id`),
  KEY `ix_lab__diagnostic_report_patient_id` (`patient_id`),
  KEY `ix_lab__diagnostic_report_status` (`status`),
  KEY `ix_lab__diagnostic_report_code` (`code`),
  KEY `ix_lab__diagnostic_report_created_at` (`created_at`),
  KEY `ix_lab__diagnostic_report_service_request_id` (`service_request_id`),
  KEY `ix_lab__diagnostic_report_performer_org_id` (`performer_org_id`),
  KEY `ix_lab__diagnostic_report_document_id` (`document_id`),
  KEY `ix_lab__diagnostic_report_signature_id` (`signature_id`),
  KEY `ix_lab__diagnostic_report_source_system_id` (`source_system_id`),
  KEY `ix_lab__diagnostic_report_external_id` (`external_id`),
  KEY `ix_lab__diagnostic_report_effective_at` (`effective_at`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Rapport';

CREATE TABLE IF NOT EXISTS `lab__observation` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `encounter_id` BINARY(16) NULL,
  `report_id` BINARY(16) NULL,
  `specimen_id` BINARY(16) NULL,
  `loinc_code` VARCHAR(100) NULL,
  `status` VARCHAR(100) NULL,
  `effective_at` DATETIME(6) NULL,
  `value_type` VARCHAR(100) NULL,
  `interpretation_code` VARCHAR(100) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_lab__observation_tenant_id` (`tenant_id`),
  KEY `ix_lab__observation_patient_id` (`patient_id`),
  KEY `ix_lab__observation_status` (`status`),
  KEY `ix_lab__observation_created_at` (`created_at`),
  KEY `ix_lab__observation_encounter_id` (`encounter_id`),
  KEY `ix_lab__observation_report_id` (`report_id`),
  KEY `ix_lab__observation_specimen_id` (`specimen_id`),
  KEY `ix_lab__observation_source_system_id` (`source_system_id`),
  KEY `ix_lab__observation_external_id` (`external_id`),
  KEY `ix_lab__observation_effective_at` (`effective_at`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Résultat';

CREATE TABLE IF NOT EXISTS `lab__observation_component` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `observation_id` BINARY(16) NULL,
  `code` VARCHAR(100) NULL,
  `value_type` VARCHAR(100) NULL,
  `unit_code` VARCHAR(100) NULL,
  `interpretation_code` VARCHAR(100) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_lab__observation_component_tenant_id` (`tenant_id`),
  KEY `ix_lab__observation_component_code` (`code`),
  KEY `ix_lab__observation_component_created_at` (`created_at`),
  KEY `ix_lab__observation_component_observation_id` (`observation_id`),
  KEY `ix_lab__observation_component_source_system_id` (`source_system_id`),
  KEY `ix_lab__observation_component_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Composante';

CREATE TABLE IF NOT EXISTS `lab__reference_range` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `observation_id` BINARY(16) NULL,
  `component_id` BINARY(16) NULL,
  `low` DECIMAL(19,6) NULL,
  `high` DECIMAL(19,6) NULL,
  `unit_code` VARCHAR(100) NULL,
  `type_code` VARCHAR(100) NULL,
  `age_min` VARCHAR(255) NULL,
  `age_max` VARCHAR(255) NULL,
  `sex_code` VARCHAR(100) NULL,
  `text` VARCHAR(255) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_lab__reference_range_tenant_id` (`tenant_id`),
  KEY `ix_lab__reference_range_type_code` (`type_code`),
  KEY `ix_lab__reference_range_created_at` (`created_at`),
  KEY `ix_lab__reference_range_observation_id` (`observation_id`),
  KEY `ix_lab__reference_range_component_id` (`component_id`),
  KEY `ix_lab__reference_range_source_system_id` (`source_system_id`),
  KEY `ix_lab__reference_range_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Référence';

CREATE TABLE IF NOT EXISTS `lab__result_correction` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `report_id` BINARY(16) NULL,
  `observation_id` BINARY(16) NULL,
  `previous_version_id` BINARY(16) NULL,
  `reason_code` TEXT NULL,
  `reason_text` TEXT NULL,
  `corrected_by` VARCHAR(255) NULL,
  `corrected_at` DATETIME(6) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_lab__result_correction_tenant_id` (`tenant_id`),
  KEY `ix_lab__result_correction_created_at` (`created_at`),
  KEY `ix_lab__result_correction_report_id` (`report_id`),
  KEY `ix_lab__result_correction_observation_id` (`observation_id`),
  KEY `ix_lab__result_correction_previous_version_id` (`previous_version_id`),
  KEY `ix_lab__result_correction_source_system_id` (`source_system_id`),
  KEY `ix_lab__result_correction_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Correction';

CREATE TABLE IF NOT EXISTS `lab__critical_result` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `observation_id` BINARY(16) NULL,
  `severity` VARCHAR(255) NULL,
  `rule_id` BINARY(16) NULL,
  `detected_at` DATETIME(6) NULL,
  `status` VARCHAR(100) NULL,
  `assigned_to` BINARY(16) NULL,
  `acknowledged_at` DATETIME(6) NULL,
  `closed_at` DATETIME(6) NULL,
  `action_summary` TEXT NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_lab__critical_result_tenant_id` (`tenant_id`),
  KEY `ix_lab__critical_result_status` (`status`),
  KEY `ix_lab__critical_result_created_at` (`created_at`),
  KEY `ix_lab__critical_result_observation_id` (`observation_id`),
  KEY `ix_lab__critical_result_rule_id` (`rule_id`),
  KEY `ix_lab__critical_result_source_system_id` (`source_system_id`),
  KEY `ix_lab__critical_result_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Criticité';

CREATE TABLE IF NOT EXISTS `lab__ocr_extraction` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `document_id` BINARY(16) NULL,
  `engine` VARCHAR(255) NULL,
  `model_version` VARCHAR(255) NULL,
  `raw_output_uri` VARCHAR(512) NULL,
  `confidence` DECIMAL(19,6) NULL,
  `status` VARCHAR(100) NULL,
  `reviewed_by` BINARY(16) NULL,
  `reviewed_at` DATETIME(6) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_lab__ocr_extraction_tenant_id` (`tenant_id`),
  KEY `ix_lab__ocr_extraction_status` (`status`),
  KEY `ix_lab__ocr_extraction_created_at` (`created_at`),
  KEY `ix_lab__ocr_extraction_document_id` (`document_id`),
  KEY `ix_lab__ocr_extraction_source_system_id` (`source_system_id`),
  KEY `ix_lab__ocr_extraction_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='OCR';

CREATE TABLE IF NOT EXISTS `imaging__imaging_order` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `encounter_id` BINARY(16) NULL,
  `requester_id` BINARY(16) NULL,
  `performer_org_id` BINARY(16) NULL,
  `modality_code` VARCHAR(100) NULL,
  `procedure_code` VARCHAR(100) NULL,
  `status` VARCHAR(100) NULL,
  `priority` INT NULL,
  `reason` TEXT NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_imaging__imaging_order_tenant_id` (`tenant_id`),
  KEY `ix_imaging__imaging_order_patient_id` (`patient_id`),
  KEY `ix_imaging__imaging_order_status` (`status`),
  KEY `ix_imaging__imaging_order_created_at` (`created_at`),
  KEY `ix_imaging__imaging_order_encounter_id` (`encounter_id`),
  KEY `ix_imaging__imaging_order_requester_id` (`requester_id`),
  KEY `ix_imaging__imaging_order_performer_org_id` (`performer_org_id`),
  KEY `ix_imaging__imaging_order_source_system_id` (`source_system_id`),
  KEY `ix_imaging__imaging_order_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Ordonnance';

CREATE TABLE IF NOT EXISTS `imaging__study` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `imaging_order_id` BINARY(16) NULL,
  `study_instance_uid` VARCHAR(255) NULL,
  `accession_no_hmac` VARBINARY(1024) NULL,
  `modality_codes` JSON NULL,
  `started_at` DATETIME(6) NULL,
  `status` VARCHAR(100) NULL,
  `pacs_endpoint_id` BINARY(16) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_imaging__study_study_instance_uid` (`study_instance_uid`),
  KEY `ix_imaging__study_tenant_id` (`tenant_id`),
  KEY `ix_imaging__study_patient_id` (`patient_id`),
  KEY `ix_imaging__study_status` (`status`),
  KEY `ix_imaging__study_created_at` (`created_at`),
  KEY `ix_imaging__study_imaging_order_id` (`imaging_order_id`),
  KEY `ix_imaging__study_pacs_endpoint_id` (`pacs_endpoint_id`),
  KEY `ix_imaging__study_source_system_id` (`source_system_id`),
  KEY `ix_imaging__study_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Étude';

CREATE TABLE IF NOT EXISTS `imaging__series` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `study_id` BINARY(16) NULL,
  `series_instance_uid` VARCHAR(255) NULL,
  `series_no` INT NULL,
  `modality` VARCHAR(255) NULL,
  `description` TEXT NULL,
  `body_part` TEXT NULL,
  `instance_count` INT NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_imaging__series_series_instance_uid` (`series_instance_uid`),
  KEY `ix_imaging__series_tenant_id` (`tenant_id`),
  KEY `ix_imaging__series_created_at` (`created_at`),
  KEY `ix_imaging__series_study_id` (`study_id`),
  KEY `ix_imaging__series_source_system_id` (`source_system_id`),
  KEY `ix_imaging__series_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Série';

CREATE TABLE IF NOT EXISTS `imaging__instance` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `series_id` BINARY(16) NULL,
  `sop_instance_uid` VARCHAR(255) NULL,
  `sop_class_uid` VARCHAR(255) NULL,
  `instance_no` INT NULL,
  `object_uri` VARCHAR(512) NULL,
  `content_hash` VARBINARY(1024) NULL,
  `size_bytes` VARCHAR(255) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_imaging__instance_sop_instance_uid` (`sop_instance_uid`),
  KEY `ix_imaging__instance_tenant_id` (`tenant_id`),
  KEY `ix_imaging__instance_created_at` (`created_at`),
  KEY `ix_imaging__instance_series_id` (`series_id`),
  KEY `ix_imaging__instance_source_system_id` (`source_system_id`),
  KEY `ix_imaging__instance_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Instance';

CREATE TABLE IF NOT EXISTS `imaging__report` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `study_id` BINARY(16) NULL,
  `patient_id` BINARY(16) NULL,
  `status` VARCHAR(100) NULL,
  `radiologist_id` BINARY(16) NULL,
  `findings` TEXT NULL,
  `impression` TEXT NULL,
  `issued_at` DATETIME(6) NULL,
  `document_id` BINARY(16) NULL,
  `signature_id` BINARY(16) NULL,
  `supersedes_id` BINARY(16) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_imaging__report_tenant_id` (`tenant_id`),
  KEY `ix_imaging__report_patient_id` (`patient_id`),
  KEY `ix_imaging__report_status` (`status`),
  KEY `ix_imaging__report_created_at` (`created_at`),
  KEY `ix_imaging__report_study_id` (`study_id`),
  KEY `ix_imaging__report_radiologist_id` (`radiologist_id`),
  KEY `ix_imaging__report_document_id` (`document_id`),
  KEY `ix_imaging__report_signature_id` (`signature_id`),
  KEY `ix_imaging__report_supersedes_id` (`supersedes_id`),
  KEY `ix_imaging__report_source_system_id` (`source_system_id`),
  KEY `ix_imaging__report_external_id` (`external_id`),
  KEY `ix_imaging__report_issued_at` (`issued_at`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Compte rendu';

CREATE TABLE IF NOT EXISTS `imaging__report_addendum` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `report_id` BINARY(16) NULL,
  `author_id` BINARY(16) NULL,
  `content` TEXT NULL,
  `signed_at` DATETIME(6) NULL,
  `signature_id` BINARY(16) NULL,
  `reason` TEXT NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_imaging__report_addendum_tenant_id` (`tenant_id`),
  KEY `ix_imaging__report_addendum_created_at` (`created_at`),
  KEY `ix_imaging__report_addendum_report_id` (`report_id`),
  KEY `ix_imaging__report_addendum_author_id` (`author_id`),
  KEY `ix_imaging__report_addendum_signature_id` (`signature_id`),
  KEY `ix_imaging__report_addendum_source_system_id` (`source_system_id`),
  KEY `ix_imaging__report_addendum_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Addenda';

CREATE TABLE IF NOT EXISTS `imaging__dose_record` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `study_id` BINARY(16) NULL,
  `patient_id` BINARY(16) NULL,
  `modality` VARCHAR(255) NULL,
  `dose_type` VARCHAR(100) NULL,
  `value` DECIMAL(19,6) NULL,
  `unit_code` VARCHAR(100) NULL,
  `body_region` TEXT NULL,
  `recorded_at` DATETIME(6) NULL,
  `source_instance_id` BINARY(16) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_imaging__dose_record_tenant_id` (`tenant_id`),
  KEY `ix_imaging__dose_record_patient_id` (`patient_id`),
  KEY `ix_imaging__dose_record_created_at` (`created_at`),
  KEY `ix_imaging__dose_record_study_id` (`study_id`),
  KEY `ix_imaging__dose_record_source_instance_id` (`source_instance_id`),
  KEY `ix_imaging__dose_record_source_system_id` (`source_system_id`),
  KEY `ix_imaging__dose_record_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Dose';

CREATE TABLE IF NOT EXISTS `imaging__contrast_administration` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `study_id` BINARY(16) NULL,
  `substance_code` VARCHAR(100) NULL,
  `lot_no` VARCHAR(255) NULL,
  `dose` DECIMAL(19,6) NULL,
  `route_code` VARCHAR(100) NULL,
  `administered_at` DATETIME(6) NULL,
  `performer_id` BINARY(16) NULL,
  `reaction_event_id` BINARY(16) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_imaging__contrast_administration_tenant_id` (`tenant_id`),
  KEY `ix_imaging__contrast_administration_created_at` (`created_at`),
  KEY `ix_imaging__contrast_administration_study_id` (`study_id`),
  KEY `ix_imaging__contrast_administration_performer_id` (`performer_id`),
  KEY `ix_imaging__contrast_administration_reaction_event_id` (`reaction_event_id`),
  KEY `ix_imaging__contrast_administration_source_system_id` (`source_system_id`),
  KEY `ix_imaging__contrast_administration_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Contraste';

CREATE TABLE IF NOT EXISTS `imaging__viewer_session` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `study_id` BINARY(16) NULL,
  `user_id` BINARY(16) NULL,
  `grant_id` BINARY(16) NULL,
  `started_at` DATETIME(6) NULL,
  `expires_at` DATETIME(6) NULL,
  `watermark_id` BINARY(16) NULL,
  `download_allowed` BOOLEAN NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_imaging__viewer_session_tenant_id` (`tenant_id`),
  KEY `ix_imaging__viewer_session_created_at` (`created_at`),
  KEY `ix_imaging__viewer_session_study_id` (`study_id`),
  KEY `ix_imaging__viewer_session_user_id` (`user_id`),
  KEY `ix_imaging__viewer_session_grant_id` (`grant_id`),
  KEY `ix_imaging__viewer_session_watermark_id` (`watermark_id`),
  KEY `ix_imaging__viewer_session_source_system_id` (`source_system_id`),
  KEY `ix_imaging__viewer_session_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Session visualiseur';

CREATE TABLE IF NOT EXISTS `document__document` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `type_code` VARCHAR(100) NULL,
  `title` VARCHAR(255) NULL,
  `status` VARCHAR(100) NULL,
  `custodian_org_id` BINARY(16) NULL,
  `clinical_date` DATE NULL,
  `current_version_id` BINARY(16) NULL,
  `confidentiality_code` VARCHAR(100) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_document__document_tenant_id` (`tenant_id`),
  KEY `ix_document__document_patient_id` (`patient_id`),
  KEY `ix_document__document_status` (`status`),
  KEY `ix_document__document_type_code` (`type_code`),
  KEY `ix_document__document_created_at` (`created_at`),
  KEY `ix_document__document_custodian_org_id` (`custodian_org_id`),
  KEY `ix_document__document_current_version_id` (`current_version_id`),
  KEY `ix_document__document_source_system_id` (`source_system_id`),
  KEY `ix_document__document_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Métadonnée';

CREATE TABLE IF NOT EXISTS `document__document_version` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `document_id` BINARY(16) NULL,
  `version_no` INT NULL,
  `object_uri` VARCHAR(512) NULL,
  `mime_type` VARCHAR(100) NULL,
  `size_bytes` VARCHAR(255) NULL,
  `content_hash` VARBINARY(1024) NULL,
  `encryption_key_ref` VARCHAR(255) NULL,
  `language` VARCHAR(64) NULL,
  `created_reason` TEXT NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_document__document_version_tenant_id` (`tenant_id`),
  KEY `ix_document__document_version_created_at` (`created_at`),
  KEY `ix_document__document_version_document_id` (`document_id`),
  KEY `ix_document__document_version_source_system_id` (`source_system_id`),
  KEY `ix_document__document_version_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Version';

CREATE TABLE IF NOT EXISTS `document__document_relation` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `source_document_id` BINARY(16) NULL,
  `target_document_id` BINARY(16) NULL,
  `relation_type` VARCHAR(100) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_document__document_relation_tenant_id` (`tenant_id`),
  KEY `ix_document__document_relation_created_at` (`created_at`),
  KEY `ix_document__document_relation_source_document_id` (`source_document_id`),
  KEY `ix_document__document_relation_target_document_id` (`target_document_id`),
  KEY `ix_document__document_relation_source_system_id` (`source_system_id`),
  KEY `ix_document__document_relation_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Relation';

CREATE TABLE IF NOT EXISTS `document__document_tag` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `document_id` BINARY(16) NULL,
  `tag_code` VARCHAR(100) NULL,
  `tag_value` VARCHAR(255) NULL,
  `security_label` VARCHAR(255) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_document__document_tag_tenant_id` (`tenant_id`),
  KEY `ix_document__document_tag_created_at` (`created_at`),
  KEY `ix_document__document_tag_document_id` (`document_id`),
  KEY `ix_document__document_tag_source_system_id` (`source_system_id`),
  KEY `ix_document__document_tag_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Tag';

CREATE TABLE IF NOT EXISTS `document__signature` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `signer_user_id` BINARY(16) NULL,
  `signature_type` VARCHAR(100) NULL,
  `signed_at` DATETIME(6) NULL,
  `payload_hash` VARBINARY(1024) NULL,
  `algorithm` VARCHAR(255) NULL,
  `certificate_ref` VARCHAR(255) NULL,
  `timestamp_token_uri` VARCHAR(512) NULL,
  `validation_status` VARCHAR(100) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_document__signature_tenant_id` (`tenant_id`),
  KEY `ix_document__signature_created_at` (`created_at`),
  KEY `ix_document__signature_signer_user_id` (`signer_user_id`),
  KEY `ix_document__signature_source_system_id` (`source_system_id`),
  KEY `ix_document__signature_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Signature';

CREATE TABLE IF NOT EXISTS `document__signature_target` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `signature_id` BINARY(16) NULL,
  `target_type` VARCHAR(100) NULL,
  `target_id` BINARY(16) NULL,
  `target_version` VARCHAR(255) NULL,
  `canonical_hash` VARBINARY(1024) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_document__signature_target_tenant_id` (`tenant_id`),
  KEY `ix_document__signature_target_created_at` (`created_at`),
  KEY `ix_document__signature_target_signature_id` (`signature_id`),
  KEY `ix_document__signature_target_target_id` (`target_id`),
  KEY `ix_document__signature_target_source_system_id` (`source_system_id`),
  KEY `ix_document__signature_target_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Objet signé';

CREATE TABLE IF NOT EXISTS `document__upload_session` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `user_id` BINARY(16) NULL,
  `purpose` VARCHAR(100) NULL,
  `expected_size` VARCHAR(255) NULL,
  `allowed_mime_types` JSON NULL,
  `expires_at` DATETIME(6) NULL,
  `status` VARCHAR(100) NULL,
  `malware_status` VARCHAR(100) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_document__upload_session_tenant_id` (`tenant_id`),
  KEY `ix_document__upload_session_status` (`status`),
  KEY `ix_document__upload_session_created_at` (`created_at`),
  KEY `ix_document__upload_session_user_id` (`user_id`),
  KEY `ix_document__upload_session_source_system_id` (`source_system_id`),
  KEY `ix_document__upload_session_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Téléversement';

CREATE TABLE IF NOT EXISTS `document__retention_assignment` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `document_id` BINARY(16) NULL,
  `policy_id` BINARY(16) NULL,
  `retain_until` DATETIME(6) NULL,
  `legal_hold` BOOLEAN NULL,
  `disposition_status` VARCHAR(100) NULL,
  `disposed_at` DATETIME(6) NULL,
  `certificate_id` BINARY(16) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_document__retention_assignment_tenant_id` (`tenant_id`),
  KEY `ix_document__retention_assignment_created_at` (`created_at`),
  KEY `ix_document__retention_assignment_document_id` (`document_id`),
  KEY `ix_document__retention_assignment_policy_id` (`policy_id`),
  KEY `ix_document__retention_assignment_certificate_id` (`certificate_id`),
  KEY `ix_document__retention_assignment_source_system_id` (`source_system_id`),
  KEY `ix_document__retention_assignment_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Conservation';

CREATE TABLE IF NOT EXISTS `document__form_template` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `code` VARCHAR(100) NULL,
  `version` VARCHAR(255) NULL,
  `locale` VARCHAR(64) NULL,
  `schema_json` VARCHAR(255) NULL,
  `render_uri` VARCHAR(512) NULL,
  `status` VARCHAR(100) NULL,
  `effective_from` DATETIME(6) NULL,
  `effective_to` DATETIME(6) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_document__form_template_tenant_id` (`tenant_id`),
  KEY `ix_document__form_template_status` (`status`),
  KEY `ix_document__form_template_code` (`code`),
  KEY `ix_document__form_template_created_at` (`created_at`),
  KEY `ix_document__form_template_source_system_id` (`source_system_id`),
  KEY `ix_document__form_template_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Formulaire';

CREATE TABLE IF NOT EXISTS `document__form_response` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `template_id` BINARY(16) NULL,
  `patient_id` BINARY(16) NULL,
  `respondent_user_id` BINARY(16) NULL,
  `encounter_id` BINARY(16) NULL,
  `status` VARCHAR(100) NULL,
  `answers` JSON NULL,
  `completed_at` DATETIME(6) NULL,
  `signature_id` BINARY(16) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_document__form_response_tenant_id` (`tenant_id`),
  KEY `ix_document__form_response_patient_id` (`patient_id`),
  KEY `ix_document__form_response_status` (`status`),
  KEY `ix_document__form_response_created_at` (`created_at`),
  KEY `ix_document__form_response_template_id` (`template_id`),
  KEY `ix_document__form_response_respondent_user_id` (`respondent_user_id`),
  KEY `ix_document__form_response_encounter_id` (`encounter_id`),
  KEY `ix_document__form_response_signature_id` (`signature_id`),
  KEY `ix_document__form_response_source_system_id` (`source_system_id`),
  KEY `ix_document__form_response_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Réponse';

CREATE TABLE IF NOT EXISTS `schedule__appointment_type` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `code` VARCHAR(100) NULL,
  `name` VARCHAR(255) NULL,
  `duration_minutes` INT NULL,
  `service_id` BINARY(16) NULL,
  `virtual_allowed` VARCHAR(255) NULL,
  `booking_rules` JSON NULL,
  `active` BOOLEAN NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_schedule__appointment_type_tenant_id` (`tenant_id`),
  KEY `ix_schedule__appointment_type_code` (`code`),
  KEY `ix_schedule__appointment_type_created_at` (`created_at`),
  KEY `ix_schedule__appointment_type_service_id` (`service_id`),
  KEY `ix_schedule__appointment_type_source_system_id` (`source_system_id`),
  KEY `ix_schedule__appointment_type_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Type';

CREATE TABLE IF NOT EXISTS `schedule__slot` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `practitioner_id` BINARY(16) NULL,
  `location_id` BINARY(16) NULL,
  `appointment_type_id` BINARY(16) NULL,
  `start_at` DATETIME(6) NULL,
  `start_end_at` DATETIME(6) NULL,
  `status` VARCHAR(100) NULL,
  `capacity` INT NULL,
  `overbook_limit` INT NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_schedule__slot_tenant_id` (`tenant_id`),
  KEY `ix_schedule__slot_status` (`status`),
  KEY `ix_schedule__slot_created_at` (`created_at`),
  KEY `ix_schedule__slot_practitioner_id` (`practitioner_id`),
  KEY `ix_schedule__slot_location_id` (`location_id`),
  KEY `ix_schedule__slot_appointment_type_id` (`appointment_type_id`),
  KEY `ix_schedule__slot_source_system_id` (`source_system_id`),
  KEY `ix_schedule__slot_external_id` (`external_id`),
  KEY `ix_schedule__slot_start_at` (`start_at`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Plage';

CREATE TABLE IF NOT EXISTS `schedule__appointment` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `type_id` BINARY(16) NULL,
  `status` VARCHAR(100) NULL,
  `start_at` DATETIME(6) NULL,
  `start_end_at` DATETIME(6) NULL,
  `location_id` BINARY(16) NULL,
  `virtual` BOOLEAN NULL,
  `reason` TEXT NULL,
  `booked_by` BINARY(16) NULL,
  `encounter_id` BINARY(16) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_schedule__appointment_tenant_id` (`tenant_id`),
  KEY `ix_schedule__appointment_patient_id` (`patient_id`),
  KEY `ix_schedule__appointment_status` (`status`),
  KEY `ix_schedule__appointment_created_at` (`created_at`),
  KEY `ix_schedule__appointment_type_id` (`type_id`),
  KEY `ix_schedule__appointment_location_id` (`location_id`),
  KEY `ix_schedule__appointment_encounter_id` (`encounter_id`),
  KEY `ix_schedule__appointment_source_system_id` (`source_system_id`),
  KEY `ix_schedule__appointment_external_id` (`external_id`),
  KEY `ix_schedule__appointment_start_at` (`start_at`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Rendez-vous';

CREATE TABLE IF NOT EXISTS `schedule__appointment_participant` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `appointment_id` BINARY(16) NULL,
  `actor_type` VARCHAR(100) NULL,
  `actor_id` BINARY(16) NULL,
  `role_code` VARCHAR(100) NULL,
  `status` VARCHAR(100) NULL,
  `required` BOOLEAN NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_schedule__appointment_participant_tenant_id` (`tenant_id`),
  KEY `ix_schedule__appointment_participant_status` (`status`),
  KEY `ix_schedule__appointment_participant_created_at` (`created_at`),
  KEY `ix_schedule__appointment_participant_appointment_id` (`appointment_id`),
  KEY `ix_schedule__appointment_participant_actor_id` (`actor_id`),
  KEY `ix_schedule__appointment_participant_source_system_id` (`source_system_id`),
  KEY `ix_schedule__appointment_participant_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Participant';

CREATE TABLE IF NOT EXISTS `schedule__waitlist_entry` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `appointment_type_id` BINARY(16) NULL,
  `priority` INT NULL,
  `earliest` VARCHAR(255) NULL,
  `latest` VARCHAR(255) NULL,
  `preferences` JSON NULL,
  `status` VARCHAR(100) NULL,
  `offered_slot_id` BINARY(16) NULL,
  `offer_expires_at` DATETIME(6) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_schedule__waitlist_entry_tenant_id` (`tenant_id`),
  KEY `ix_schedule__waitlist_entry_patient_id` (`patient_id`),
  KEY `ix_schedule__waitlist_entry_status` (`status`),
  KEY `ix_schedule__waitlist_entry_created_at` (`created_at`),
  KEY `ix_schedule__waitlist_entry_appointment_type_id` (`appointment_type_id`),
  KEY `ix_schedule__waitlist_entry_offered_slot_id` (`offered_slot_id`),
  KEY `ix_schedule__waitlist_entry_source_system_id` (`source_system_id`),
  KEY `ix_schedule__waitlist_entry_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Attente';

CREATE TABLE IF NOT EXISTS `schedule__reminder` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `appointment_id` BINARY(16) NULL,
  `channel` VARCHAR(100) NULL,
  `scheduled_at` DATETIME(6) NULL,
  `status` VARCHAR(100) NULL,
  `sent_at` DATETIME(6) NULL,
  `template_code` VARCHAR(100) NULL,
  `attempt_count` INT NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_schedule__reminder_tenant_id` (`tenant_id`),
  KEY `ix_schedule__reminder_status` (`status`),
  KEY `ix_schedule__reminder_created_at` (`created_at`),
  KEY `ix_schedule__reminder_appointment_id` (`appointment_id`),
  KEY `ix_schedule__reminder_source_system_id` (`source_system_id`),
  KEY `ix_schedule__reminder_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Rappel';

CREATE TABLE IF NOT EXISTS `schedule__availability_exception` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `actor_type` VARCHAR(100) NULL,
  `actor_id` BINARY(16) NULL,
  `start_at` DATETIME(6) NULL,
  `start_end_at` DATETIME(6) NULL,
  `exception_type` VARCHAR(100) NULL,
  `reason` TEXT NULL,
  `recurrence_id` BINARY(16) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_schedule__availability_exception_tenant_id` (`tenant_id`),
  KEY `ix_schedule__availability_exception_created_at` (`created_at`),
  KEY `ix_schedule__availability_exception_actor_id` (`actor_id`),
  KEY `ix_schedule__availability_exception_recurrence_id` (`recurrence_id`),
  KEY `ix_schedule__availability_exception_source_system_id` (`source_system_id`),
  KEY `ix_schedule__availability_exception_external_id` (`external_id`),
  KEY `ix_schedule__availability_exception_start_at` (`start_at`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Absence/ouverture';

CREATE TABLE IF NOT EXISTS `telecare__session` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `appointment_id` BINARY(16) NULL,
  `patient_id` BINARY(16) NULL,
  `host_practitioner_id` BINARY(16) NULL,
  `status` VARCHAR(100) NULL,
  `room_ref` VARCHAR(255) NULL,
  `scheduled_at` DATETIME(6) NULL,
  `started_at` DATETIME(6) NULL,
  `ended_at` DATETIME(6) NULL,
  `recording_allowed` BOOLEAN NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_telecare__session_tenant_id` (`tenant_id`),
  KEY `ix_telecare__session_patient_id` (`patient_id`),
  KEY `ix_telecare__session_status` (`status`),
  KEY `ix_telecare__session_created_at` (`created_at`),
  KEY `ix_telecare__session_appointment_id` (`appointment_id`),
  KEY `ix_telecare__session_host_practitioner_id` (`host_practitioner_id`),
  KEY `ix_telecare__session_source_system_id` (`source_system_id`),
  KEY `ix_telecare__session_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Téléconsultation';

CREATE TABLE IF NOT EXISTS `telecare__participant` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `session_id` BINARY(16) NULL,
  `user_id` BINARY(16) NULL,
  `role_code` VARCHAR(100) NULL,
  `joined_at` DATETIME(6) NULL,
  `left_at` DATETIME(6) NULL,
  `network_quality` VARCHAR(255) NULL,
  `consent_confirmed_at` DATETIME(6) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_telecare__participant_tenant_id` (`tenant_id`),
  KEY `ix_telecare__participant_created_at` (`created_at`),
  KEY `ix_telecare__participant_session_id` (`session_id`),
  KEY `ix_telecare__participant_user_id` (`user_id`),
  KEY `ix_telecare__participant_source_system_id` (`source_system_id`),
  KEY `ix_telecare__participant_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Présence';

CREATE TABLE IF NOT EXISTS `telecare__session_event` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `session_id` BINARY(16) NULL,
  `event_type` VARCHAR(100) NULL,
  `occurred_at` DATETIME(6) NULL,
  `actor_id` BINARY(16) NULL,
  `metadata_redacted` JSON NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_telecare__session_event_tenant_id` (`tenant_id`),
  KEY `ix_telecare__session_event_created_at` (`created_at`),
  KEY `ix_telecare__session_event_session_id` (`session_id`),
  KEY `ix_telecare__session_event_actor_id` (`actor_id`),
  KEY `ix_telecare__session_event_source_system_id` (`source_system_id`),
  KEY `ix_telecare__session_event_external_id` (`external_id`),
  KEY `ix_telecare__session_event_occurred_at` (`occurred_at`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Événement';

CREATE TABLE IF NOT EXISTS `telecare__recording` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `session_id` BINARY(16) NULL,
  `document_id` BINARY(16) NULL,
  `consent_version_id` BINARY(16) NULL,
  `started_at` DATETIME(6) NULL,
  `started_end_at` DATETIME(6) NULL,
  `retention_policy_id` BINARY(16) NULL,
  `status` VARCHAR(100) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_telecare__recording_tenant_id` (`tenant_id`),
  KEY `ix_telecare__recording_status` (`status`),
  KEY `ix_telecare__recording_created_at` (`created_at`),
  KEY `ix_telecare__recording_session_id` (`session_id`),
  KEY `ix_telecare__recording_document_id` (`document_id`),
  KEY `ix_telecare__recording_consent_version_id` (`consent_version_id`),
  KEY `ix_telecare__recording_retention_policy_id` (`retention_policy_id`),
  KEY `ix_telecare__recording_source_system_id` (`source_system_id`),
  KEY `ix_telecare__recording_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Captation exceptionnelle';

CREATE TABLE IF NOT EXISTS `collab__conversation` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `encounter_id` BINARY(16) NULL,
  `subject` VARCHAR(255) NULL,
  `type_code` VARCHAR(100) NULL,
  `status` VARCHAR(100) NULL,
  `sensitivity` VARCHAR(255) NULL,
  `created_by` BINARY(16) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_collab__conversation_tenant_id` (`tenant_id`),
  KEY `ix_collab__conversation_patient_id` (`patient_id`),
  KEY `ix_collab__conversation_status` (`status`),
  KEY `ix_collab__conversation_type_code` (`type_code`),
  KEY `ix_collab__conversation_created_at` (`created_at`),
  KEY `ix_collab__conversation_encounter_id` (`encounter_id`),
  KEY `ix_collab__conversation_source_system_id` (`source_system_id`),
  KEY `ix_collab__conversation_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Conversation';

CREATE TABLE IF NOT EXISTS `collab__conversation_member` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `conversation_id` BINARY(16) NULL,
  `user_id` BINARY(16) NULL,
  `role_code` VARCHAR(100) NULL,
  `joined_at` DATETIME(6) NULL,
  `left_at` DATETIME(6) NULL,
  `can_post` BOOLEAN NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_collab__conversation_member_tenant_id` (`tenant_id`),
  KEY `ix_collab__conversation_member_created_at` (`created_at`),
  KEY `ix_collab__conversation_member_conversation_id` (`conversation_id`),
  KEY `ix_collab__conversation_member_user_id` (`user_id`),
  KEY `ix_collab__conversation_member_source_system_id` (`source_system_id`),
  KEY `ix_collab__conversation_member_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Membre';

CREATE TABLE IF NOT EXISTS `collab__message` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `conversation_id` BINARY(16) NULL,
  `sender_user_id` BINARY(16) NULL,
  `sent_at` DATETIME(6) NULL,
  `body_ciphertext` VARBINARY(1024) NULL,
  `status` VARCHAR(100) NULL,
  `reply_to_id` BINARY(16) NULL,
  `client_message_id` BINARY(16) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_collab__message_tenant_id` (`tenant_id`),
  KEY `ix_collab__message_status` (`status`),
  KEY `ix_collab__message_created_at` (`created_at`),
  KEY `ix_collab__message_conversation_id` (`conversation_id`),
  KEY `ix_collab__message_sender_user_id` (`sender_user_id`),
  KEY `ix_collab__message_reply_to_id` (`reply_to_id`),
  KEY `ix_collab__message_client_message_id` (`client_message_id`),
  KEY `ix_collab__message_source_system_id` (`source_system_id`),
  KEY `ix_collab__message_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Message';

CREATE TABLE IF NOT EXISTS `collab__message_attachment` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `message_id` BINARY(16) NULL,
  `document_id` BINARY(16) NULL,
  `display_name` VARCHAR(255) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_collab__message_attachment_tenant_id` (`tenant_id`),
  KEY `ix_collab__message_attachment_created_at` (`created_at`),
  KEY `ix_collab__message_attachment_message_id` (`message_id`),
  KEY `ix_collab__message_attachment_document_id` (`document_id`),
  KEY `ix_collab__message_attachment_source_system_id` (`source_system_id`),
  KEY `ix_collab__message_attachment_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Pièce';

CREATE TABLE IF NOT EXISTS `collab__message_receipt` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `message_id` BINARY(16) NULL,
  `user_id` BINARY(16) NULL,
  `delivered_at` DATETIME(6) NULL,
  `read_at` DATETIME(6) NULL,
  `acknowledged_at` DATETIME(6) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_collab__message_receipt_tenant_id` (`tenant_id`),
  KEY `ix_collab__message_receipt_created_at` (`created_at`),
  KEY `ix_collab__message_receipt_message_id` (`message_id`),
  KEY `ix_collab__message_receipt_user_id` (`user_id`),
  KEY `ix_collab__message_receipt_source_system_id` (`source_system_id`),
  KEY `ix_collab__message_receipt_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Reçu';

CREATE TABLE IF NOT EXISTS `collab__task` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `encounter_id` BINARY(16) NULL,
  `type_code` VARCHAR(100) NULL,
  `title` VARCHAR(255) NULL,
  `priority` INT NULL,
  `status` VARCHAR(100) NULL,
  `due_at` DATETIME(6) NULL,
  `assigned_user_id` BINARY(16) NULL,
  `assigned_user_team_id` BINARY(16) NULL,
  `created_by` BINARY(16) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_collab__task_tenant_id` (`tenant_id`),
  KEY `ix_collab__task_patient_id` (`patient_id`),
  KEY `ix_collab__task_status` (`status`),
  KEY `ix_collab__task_type_code` (`type_code`),
  KEY `ix_collab__task_created_at` (`created_at`),
  KEY `ix_collab__task_encounter_id` (`encounter_id`),
  KEY `ix_collab__task_assigned_user_id` (`assigned_user_id`),
  KEY `ix_collab__task_assigned_user_team_id` (`assigned_user_team_id`),
  KEY `ix_collab__task_source_system_id` (`source_system_id`),
  KEY `ix_collab__task_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Tâche';

CREATE TABLE IF NOT EXISTS `collab__task_event` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `task_id` BINARY(16) NULL,
  `event_type` VARCHAR(100) NULL,
  `actor_id` BINARY(16) NULL,
  `occurred_at` DATETIME(6) NULL,
  `details` JSON NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  PRIMARY KEY (`id`),
  KEY `ix_collab__task_event_tenant_id` (`tenant_id`),
  KEY `ix_collab__task_event_created_at` (`created_at`),
  KEY `ix_collab__task_event_task_id` (`task_id`),
  KEY `ix_collab__task_event_actor_id` (`actor_id`),
  KEY `ix_collab__task_event_source_system_id` (`source_system_id`),
  KEY `ix_collab__task_event_external_id` (`external_id`),
  KEY `ix_collab__task_event_occurred_at` (`occurred_at`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Historique';

CREATE TABLE IF NOT EXISTS `notify__notification` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `recipient_user_id` BINARY(16) NULL,
  `type_code` VARCHAR(100) NULL,
  `priority` INT NULL,
  `title_key` VARCHAR(255) NULL,
  `body_key` TEXT NULL,
  `deep_link` VARCHAR(255) NULL,
  `status` VARCHAR(100) NULL,
  `expires_at` DATETIME(6) NULL,
  `clinical_ref` VARCHAR(255) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_notify__notification_tenant_id` (`tenant_id`),
  KEY `ix_notify__notification_status` (`status`),
  KEY `ix_notify__notification_type_code` (`type_code`),
  KEY `ix_notify__notification_created_at` (`created_at`),
  KEY `ix_notify__notification_recipient_user_id` (`recipient_user_id`),
  KEY `ix_notify__notification_source_system_id` (`source_system_id`),
  KEY `ix_notify__notification_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Notification interne';

CREATE TABLE IF NOT EXISTS `notify__delivery` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `notification_id` BINARY(16) NULL,
  `channel` VARCHAR(100) NULL,
  `destination_hmac` VARBINARY(1024) NULL,
  `provider_ref` VARCHAR(255) NULL,
  `status` VARCHAR(100) NULL,
  `attempt_count` INT NULL,
  `sent_at` DATETIME(6) NULL,
  `delivered_at` DATETIME(6) NULL,
  `error_code` VARCHAR(100) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_notify__delivery_tenant_id` (`tenant_id`),
  KEY `ix_notify__delivery_status` (`status`),
  KEY `ix_notify__delivery_created_at` (`created_at`),
  KEY `ix_notify__delivery_notification_id` (`notification_id`),
  KEY `ix_notify__delivery_source_system_id` (`source_system_id`),
  KEY `ix_notify__delivery_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Livraison';

CREATE TABLE IF NOT EXISTS `notify__preference` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `user_id` BINARY(16) NULL,
  `notification_type` VARCHAR(100) NULL,
  `channel` VARCHAR(100) NULL,
  `enabled` BOOLEAN NULL,
  `quiet_hours` JSON NULL,
  `escalation_allowed` VARCHAR(255) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_notify__preference_tenant_id` (`tenant_id`),
  KEY `ix_notify__preference_created_at` (`created_at`),
  KEY `ix_notify__preference_user_id` (`user_id`),
  KEY `ix_notify__preference_source_system_id` (`source_system_id`),
  KEY `ix_notify__preference_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Préférence';

CREATE TABLE IF NOT EXISTS `notify__template` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `code` VARCHAR(100) NULL,
  `locale` VARCHAR(64) NULL,
  `channel` VARCHAR(100) NULL,
  `version` VARCHAR(255) NULL,
  `subject` VARCHAR(255) NULL,
  `body` TEXT NULL,
  `status` VARCHAR(100) NULL,
  `contains_phi_allowed` VARCHAR(255) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_notify__template_tenant_id` (`tenant_id`),
  KEY `ix_notify__template_status` (`status`),
  KEY `ix_notify__template_code` (`code`),
  KEY `ix_notify__template_created_at` (`created_at`),
  KEY `ix_notify__template_source_system_id` (`source_system_id`),
  KEY `ix_notify__template_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Gabarit';

CREATE TABLE IF NOT EXISTS `billing__payer` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `organization_id` BINARY(16) NULL,
  `payer_code` VARCHAR(100) NULL,
  `type_code` VARCHAR(100) NULL,
  `jurisdiction_id` BINARY(16) NULL,
  `electronic_endpoint_id` BINARY(16) NULL,
  `active` BOOLEAN NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_billing__payer_tenant_id` (`tenant_id`),
  KEY `ix_billing__payer_type_code` (`type_code`),
  KEY `ix_billing__payer_created_at` (`created_at`),
  KEY `ix_billing__payer_organization_id` (`organization_id`),
  KEY `ix_billing__payer_jurisdiction_id` (`jurisdiction_id`),
  KEY `ix_billing__payer_electronic_endpoint_id` (`electronic_endpoint_id`),
  KEY `ix_billing__payer_source_system_id` (`source_system_id`),
  KEY `ix_billing__payer_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Payeur';

CREATE TABLE IF NOT EXISTS `billing__coverage` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `payer_id` BINARY(16) NULL,
  `subscriber_id` BINARY(16) NULL,
  `policy_no_ciphertext` VARBINARY(1024) NULL,
  `policy_no_hmac` VARBINARY(1024) NULL,
  `group_no` VARCHAR(255) NULL,
  `type_code` VARCHAR(100) NULL,
  `status` VARCHAR(100) NULL,
  `period_start` DATETIME(6) NULL,
  `period_end` DATETIME(6) NULL,
  `priority` INT NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_billing__coverage_tenant_id` (`tenant_id`),
  KEY `ix_billing__coverage_patient_id` (`patient_id`),
  KEY `ix_billing__coverage_status` (`status`),
  KEY `ix_billing__coverage_type_code` (`type_code`),
  KEY `ix_billing__coverage_created_at` (`created_at`),
  KEY `ix_billing__coverage_payer_id` (`payer_id`),
  KEY `ix_billing__coverage_subscriber_id` (`subscriber_id`),
  KEY `ix_billing__coverage_source_system_id` (`source_system_id`),
  KEY `ix_billing__coverage_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Couverture';

CREATE TABLE IF NOT EXISTS `billing__coverage_benefit` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `coverage_id` BINARY(16) NULL,
  `category_code` VARCHAR(100) NULL,
  `network_code` VARCHAR(100) NULL,
  `benefit_type` VARCHAR(100) NULL,
  `value_amount` DECIMAL(19,6) NULL,
  `value_percent` DECIMAL(19,6) NULL,
  `limit_amount` DECIMAL(19,6) NULL,
  `period_code` VARCHAR(100) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_billing__coverage_benefit_tenant_id` (`tenant_id`),
  KEY `ix_billing__coverage_benefit_created_at` (`created_at`),
  KEY `ix_billing__coverage_benefit_coverage_id` (`coverage_id`),
  KEY `ix_billing__coverage_benefit_source_system_id` (`source_system_id`),
  KEY `ix_billing__coverage_benefit_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Avantage';

CREATE TABLE IF NOT EXISTS `billing__eligibility_check` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `coverage_id` BINARY(16) NULL,
  `service_code` VARCHAR(100) NULL,
  `requested_at` DATETIME(6) NULL,
  `response_at` DATETIME(6) NULL,
  `outcome` VARCHAR(100) NULL,
  `raw_response_document_id` BINARY(16) NULL,
  `valid_until` DATETIME(6) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_billing__eligibility_check_tenant_id` (`tenant_id`),
  KEY `ix_billing__eligibility_check_created_at` (`created_at`),
  KEY `ix_billing__eligibility_check_coverage_id` (`coverage_id`),
  KEY `ix_billing__eligibility_check_raw_response_document_id` (`raw_response_document_id`),
  KEY `ix_billing__eligibility_check_source_system_id` (`source_system_id`),
  KEY `ix_billing__eligibility_check_external_id` (`external_id`),
  KEY `ix_billing__eligibility_check_requested_at` (`requested_at`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Admissibilité';

CREATE TABLE IF NOT EXISTS `billing__price_schedule` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `payer_id` BINARY(16) NULL,
  `organization_id` BINARY(16) NULL,
  `code` VARCHAR(100) NULL,
  `amount` DECIMAL(19,6) NULL,
  `currency` CHAR(3) NULL,
  `effective_from` DATETIME(6) NULL,
  `effective_to` DATETIME(6) NULL,
  `conditions` JSON NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_billing__price_schedule_tenant_id` (`tenant_id`),
  KEY `ix_billing__price_schedule_code` (`code`),
  KEY `ix_billing__price_schedule_created_at` (`created_at`),
  KEY `ix_billing__price_schedule_payer_id` (`payer_id`),
  KEY `ix_billing__price_schedule_organization_id` (`organization_id`),
  KEY `ix_billing__price_schedule_source_system_id` (`source_system_id`),
  KEY `ix_billing__price_schedule_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Tarif';

CREATE TABLE IF NOT EXISTS `billing__estimate` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `appointment_id` BINARY(16) NULL,
  `coverage_id` BINARY(16) NULL,
  `status` VARCHAR(100) NULL,
  `total` DECIMAL(19,6) NULL,
  `patient_amount` DECIMAL(19,6) NULL,
  `payer_amount` DECIMAL(19,6) NULL,
  `currency` CHAR(3) NULL,
  `expires_at` DATETIME(6) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_billing__estimate_tenant_id` (`tenant_id`),
  KEY `ix_billing__estimate_patient_id` (`patient_id`),
  KEY `ix_billing__estimate_status` (`status`),
  KEY `ix_billing__estimate_created_at` (`created_at`),
  KEY `ix_billing__estimate_appointment_id` (`appointment_id`),
  KEY `ix_billing__estimate_coverage_id` (`coverage_id`),
  KEY `ix_billing__estimate_source_system_id` (`source_system_id`),
  KEY `ix_billing__estimate_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Estimation';

CREATE TABLE IF NOT EXISTS `billing__invoice` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `organization_id` BINARY(16) NULL,
  `invoice_no` VARCHAR(255) NULL,
  `status` VARCHAR(100) NULL,
  `issued_at` DATETIME(6) NULL,
  `due_at` DATETIME(6) NULL,
  `subtotal` DECIMAL(19,6) NULL,
  `tax` DECIMAL(19,6) NULL,
  `total` DECIMAL(19,6) NULL,
  `balance` DECIMAL(19,6) NULL,
  `currency` CHAR(3) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_billing__invoice_tenant_id` (`tenant_id`),
  KEY `ix_billing__invoice_patient_id` (`patient_id`),
  KEY `ix_billing__invoice_status` (`status`),
  KEY `ix_billing__invoice_created_at` (`created_at`),
  KEY `ix_billing__invoice_organization_id` (`organization_id`),
  KEY `ix_billing__invoice_source_system_id` (`source_system_id`),
  KEY `ix_billing__invoice_external_id` (`external_id`),
  KEY `ix_billing__invoice_issued_at` (`issued_at`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Facture';

CREATE TABLE IF NOT EXISTS `billing__invoice_line` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `invoice_id` BINARY(16) NULL,
  `sequence_no` INT NULL,
  `service_code` VARCHAR(100) NULL,
  `description` TEXT NULL,
  `quantity` DECIMAL(19,6) NULL,
  `unit_price` VARCHAR(255) NULL,
  `amount` DECIMAL(19,6) NULL,
  `encounter_id` BINARY(16) NULL,
  `practitioner_id` BINARY(16) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_billing__invoice_line_tenant_id` (`tenant_id`),
  KEY `ix_billing__invoice_line_created_at` (`created_at`),
  KEY `ix_billing__invoice_line_invoice_id` (`invoice_id`),
  KEY `ix_billing__invoice_line_encounter_id` (`encounter_id`),
  KEY `ix_billing__invoice_line_practitioner_id` (`practitioner_id`),
  KEY `ix_billing__invoice_line_source_system_id` (`source_system_id`),
  KEY `ix_billing__invoice_line_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Ligne';

CREATE TABLE IF NOT EXISTS `billing__payment` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `invoice_id` BINARY(16) NULL,
  `patient_id` BINARY(16) NULL,
  `amount` DECIMAL(19,6) NULL,
  `currency` CHAR(3) NULL,
  `method_code` VARCHAR(100) NULL,
  `processor_token_ref` VARCHAR(255) NULL,
  `status` VARCHAR(100) NULL,
  `paid_at` DATETIME(6) NULL,
  `external_ref` VARCHAR(255) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_billing__payment_tenant_id` (`tenant_id`),
  KEY `ix_billing__payment_patient_id` (`patient_id`),
  KEY `ix_billing__payment_status` (`status`),
  KEY `ix_billing__payment_created_at` (`created_at`),
  KEY `ix_billing__payment_invoice_id` (`invoice_id`),
  KEY `ix_billing__payment_source_system_id` (`source_system_id`),
  KEY `ix_billing__payment_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Paiement';

CREATE TABLE IF NOT EXISTS `billing__refund` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `payment_id` BINARY(16) NULL,
  `amount` DECIMAL(19,6) NULL,
  `reason_code` TEXT NULL,
  `status` VARCHAR(100) NULL,
  `requested_at` DATETIME(6) NULL,
  `processed_at` DATETIME(6) NULL,
  `external_ref` VARCHAR(255) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_billing__refund_tenant_id` (`tenant_id`),
  KEY `ix_billing__refund_status` (`status`),
  KEY `ix_billing__refund_created_at` (`created_at`),
  KEY `ix_billing__refund_payment_id` (`payment_id`),
  KEY `ix_billing__refund_source_system_id` (`source_system_id`),
  KEY `ix_billing__refund_external_id` (`external_id`),
  KEY `ix_billing__refund_requested_at` (`requested_at`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Remboursement';

CREATE TABLE IF NOT EXISTS `billing__claim` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `coverage_id` BINARY(16) NULL,
  `payer_id` BINARY(16) NULL,
  `provider_org_id` BINARY(16) NULL,
  `claim_no` VARCHAR(255) NULL,
  `status` VARCHAR(100) NULL,
  `use_code` VARCHAR(100) NULL,
  `submitted_at` DATETIME(6) NULL,
  `total` DECIMAL(19,6) NULL,
  `currency` CHAR(3) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_billing__claim_tenant_id` (`tenant_id`),
  KEY `ix_billing__claim_patient_id` (`patient_id`),
  KEY `ix_billing__claim_status` (`status`),
  KEY `ix_billing__claim_created_at` (`created_at`),
  KEY `ix_billing__claim_coverage_id` (`coverage_id`),
  KEY `ix_billing__claim_payer_id` (`payer_id`),
  KEY `ix_billing__claim_provider_org_id` (`provider_org_id`),
  KEY `ix_billing__claim_source_system_id` (`source_system_id`),
  KEY `ix_billing__claim_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Réclamation';

CREATE TABLE IF NOT EXISTS `billing__claim_item` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `claim_id` BINARY(16) NULL,
  `sequence_no` INT NULL,
  `service_code` VARCHAR(100) NULL,
  `diagnosis_refs` JSON NULL,
  `service_at` DATETIME(6) NULL,
  `quantity` DECIMAL(19,6) NULL,
  `unit_price` VARCHAR(255) NULL,
  `net_amount` DECIMAL(19,6) NULL,
  `practitioner_id` BINARY(16) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_billing__claim_item_tenant_id` (`tenant_id`),
  KEY `ix_billing__claim_item_created_at` (`created_at`),
  KEY `ix_billing__claim_item_claim_id` (`claim_id`),
  KEY `ix_billing__claim_item_practitioner_id` (`practitioner_id`),
  KEY `ix_billing__claim_item_source_system_id` (`source_system_id`),
  KEY `ix_billing__claim_item_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Ligne claim';

CREATE TABLE IF NOT EXISTS `billing__claim_response` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `claim_id` BINARY(16) NULL,
  `outcome` VARCHAR(100) NULL,
  `disposition` VARCHAR(255) NULL,
  `received_at` DATETIME(6) NULL,
  `approved_amount` DECIMAL(19,6) NULL,
  `patient_responsibility` VARCHAR(255) NULL,
  `document_id` BINARY(16) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_billing__claim_response_tenant_id` (`tenant_id`),
  KEY `ix_billing__claim_response_created_at` (`created_at`),
  KEY `ix_billing__claim_response_claim_id` (`claim_id`),
  KEY `ix_billing__claim_response_document_id` (`document_id`),
  KEY `ix_billing__claim_response_source_system_id` (`source_system_id`),
  KEY `ix_billing__claim_response_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Décision';

CREATE TABLE IF NOT EXISTS `billing__claim_adjudication` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `claim_response_id` BINARY(16) NULL,
  `claim_item_id` BINARY(16) NULL,
  `category_code` VARCHAR(100) NULL,
  `amount` DECIMAL(19,6) NULL,
  `reason_code` TEXT NULL,
  `note` TEXT NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_billing__claim_adjudication_tenant_id` (`tenant_id`),
  KEY `ix_billing__claim_adjudication_created_at` (`created_at`),
  KEY `ix_billing__claim_adjudication_claim_response_id` (`claim_response_id`),
  KEY `ix_billing__claim_adjudication_claim_item_id` (`claim_item_id`),
  KEY `ix_billing__claim_adjudication_source_system_id` (`source_system_id`),
  KEY `ix_billing__claim_adjudication_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Adjudication ligne';

CREATE TABLE IF NOT EXISTS `iot__device` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `device_type` VARCHAR(100) NULL,
  `manufacturer` VARCHAR(255) NULL,
  `model` VARCHAR(255) NULL,
  `serial_hmac` VARBINARY(1024) NULL,
  `udi` VARCHAR(255) NULL,
  `status` VARCHAR(100) NULL,
  `paired_at` DATETIME(6) NULL,
  `last_sync_at` DATETIME(6) NULL,
  `firmware` VARCHAR(255) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_iot__device_tenant_id` (`tenant_id`),
  KEY `ix_iot__device_patient_id` (`patient_id`),
  KEY `ix_iot__device_status` (`status`),
  KEY `ix_iot__device_created_at` (`created_at`),
  KEY `ix_iot__device_source_system_id` (`source_system_id`),
  KEY `ix_iot__device_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Appareil';

CREATE TABLE IF NOT EXISTS `iot__device_authorization` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `device_id` BINARY(16) NULL,
  `provider` VARCHAR(255) NULL,
  `scope` JSON NULL,
  `token_ref` VARCHAR(255) NULL,
  `status` VARCHAR(100) NULL,
  `granted_at` DATETIME(6) NULL,
  `revoked_at` DATETIME(6) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_iot__device_authorization_tenant_id` (`tenant_id`),
  KEY `ix_iot__device_authorization_patient_id` (`patient_id`),
  KEY `ix_iot__device_authorization_status` (`status`),
  KEY `ix_iot__device_authorization_created_at` (`created_at`),
  KEY `ix_iot__device_authorization_device_id` (`device_id`),
  KEY `ix_iot__device_authorization_source_system_id` (`source_system_id`),
  KEY `ix_iot__device_authorization_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Autorisation fournisseur';

CREATE TABLE IF NOT EXISTS `iot__measurement_batch` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `device_id` BINARY(16) NULL,
  `patient_id` BINARY(16) NULL,
  `started_at` DATETIME(6) NULL,
  `started_end_at` DATETIME(6) NULL,
  `received_at` DATETIME(6) NULL,
  `sample_count` INT NULL,
  `quality_score` DECIMAL(19,6) NULL,
  `source_hash` VARBINARY(1024) NULL,
  `status` VARCHAR(100) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_iot__measurement_batch_tenant_id` (`tenant_id`),
  KEY `ix_iot__measurement_batch_patient_id` (`patient_id`),
  KEY `ix_iot__measurement_batch_status` (`status`),
  KEY `ix_iot__measurement_batch_created_at` (`created_at`),
  KEY `ix_iot__measurement_batch_device_id` (`device_id`),
  KEY `ix_iot__measurement_batch_source_system_id` (`source_system_id`),
  KEY `ix_iot__measurement_batch_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Lot';

CREATE TABLE IF NOT EXISTS `iot__measurement` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `batch_id` BINARY(16) NULL,
  `patient_id` BINARY(16) NULL,
  `metric_code` VARCHAR(100) NULL,
  `measured_at` DATETIME(6) NULL,
  `value` DECIMAL(19,6) NULL,
  `unit_code` VARCHAR(100) NULL,
  `normalized_value` VARCHAR(255) NULL,
  `normalized_unit` VARCHAR(255) NULL,
  `quality_flag` VARCHAR(255) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_iot__measurement_tenant_id` (`tenant_id`),
  KEY `ix_iot__measurement_patient_id` (`patient_id`),
  KEY `ix_iot__measurement_created_at` (`created_at`),
  KEY `ix_iot__measurement_batch_id` (`batch_id`),
  KEY `ix_iot__measurement_source_system_id` (`source_system_id`),
  KEY `ix_iot__measurement_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Mesure';

CREATE TABLE IF NOT EXISTS `wellness__patient_reported_outcome` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `instrument_code` VARCHAR(100) NULL,
  `instrument_version` VARCHAR(255) NULL,
  `completed_at` DATETIME(6) NULL,
  `score` DECIMAL(19,6) NULL,
  `interpretation` VARCHAR(255) NULL,
  `form_response_id` BINARY(16) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_wellness__patient_reported_outcome_tenant_id` (`tenant_id`),
  KEY `ix_wellness__patient_reported_outcome_patient_id` (`patient_id`),
  KEY `ix_wellness__patient_reported_outcome_created_at` (`created_at`),
  KEY `ix_wellness__patient_reported_outcome_form_response_id` (`form_response_id`),
  KEY `ix_wellness__patient_reported_outcome_source_system_id` (`source_system_id`),
  KEY `ix_wellness__patient_reported_outcome_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='PROM';

CREATE TABLE IF NOT EXISTS `wellness__activity_summary` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `date` DATE NULL,
  `steps` VARCHAR(255) NULL,
  `distance_m` VARCHAR(255) NULL,
  `active_minutes` INT NULL,
  `energy_kcal` VARCHAR(255) NULL,
  `source_device_id` BINARY(16) NULL,
  `quality` VARCHAR(255) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_wellness__activity_summary_tenant_id` (`tenant_id`),
  KEY `ix_wellness__activity_summary_patient_id` (`patient_id`),
  KEY `ix_wellness__activity_summary_created_at` (`created_at`),
  KEY `ix_wellness__activity_summary_source_device_id` (`source_device_id`),
  KEY `ix_wellness__activity_summary_source_system_id` (`source_system_id`),
  KEY `ix_wellness__activity_summary_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Activité';

CREATE TABLE IF NOT EXISTS `wellness__sleep_summary` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `start_at` DATETIME(6) NULL,
  `start_end_at` DATETIME(6) NULL,
  `duration_minutes` INT NULL,
  `efficiency` VARCHAR(255) NULL,
  `stages` JSON NULL,
  `source_device_id` BINARY(16) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_wellness__sleep_summary_tenant_id` (`tenant_id`),
  KEY `ix_wellness__sleep_summary_patient_id` (`patient_id`),
  KEY `ix_wellness__sleep_summary_created_at` (`created_at`),
  KEY `ix_wellness__sleep_summary_source_device_id` (`source_device_id`),
  KEY `ix_wellness__sleep_summary_source_system_id` (`source_system_id`),
  KEY `ix_wellness__sleep_summary_external_id` (`external_id`),
  KEY `ix_wellness__sleep_summary_start_at` (`start_at`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Sommeil';

CREATE TABLE IF NOT EXISTS `wellness__nutrition_log` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `consumed_at` DATETIME(6) NULL,
  `food_code` VARCHAR(100) NULL,
  `description` TEXT NULL,
  `quantity` DECIMAL(19,6) NULL,
  `unit` VARCHAR(255) NULL,
  `nutrients` JSON NULL,
  `source` VARCHAR(255) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_wellness__nutrition_log_tenant_id` (`tenant_id`),
  KEY `ix_wellness__nutrition_log_patient_id` (`patient_id`),
  KEY `ix_wellness__nutrition_log_created_at` (`created_at`),
  KEY `ix_wellness__nutrition_log_source_system_id` (`source_system_id`),
  KEY `ix_wellness__nutrition_log_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Journal';

CREATE TABLE IF NOT EXISTS `genomics__genetic_test` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `service_request_id` BINARY(16) NULL,
  `laboratory_org_id` BINARY(16) NULL,
  `test_code` VARCHAR(100) NULL,
  `status` VARCHAR(100) NULL,
  `collected_at` DATETIME(6) NULL,
  `reported_at` DATETIME(6) NULL,
  `report_document_id` BINARY(16) NULL,
  `raw_data_uri` VARCHAR(512) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_genomics__genetic_test_tenant_id` (`tenant_id`),
  KEY `ix_genomics__genetic_test_patient_id` (`patient_id`),
  KEY `ix_genomics__genetic_test_status` (`status`),
  KEY `ix_genomics__genetic_test_created_at` (`created_at`),
  KEY `ix_genomics__genetic_test_service_request_id` (`service_request_id`),
  KEY `ix_genomics__genetic_test_laboratory_org_id` (`laboratory_org_id`),
  KEY `ix_genomics__genetic_test_report_document_id` (`report_document_id`),
  KEY `ix_genomics__genetic_test_source_system_id` (`source_system_id`),
  KEY `ix_genomics__genetic_test_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Test';

CREATE TABLE IF NOT EXISTS `genomics__variant` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `genetic_test_id` BINARY(16) NULL,
  `gene_code` VARCHAR(100) NULL,
  `hgvs_c` VARCHAR(255) NULL,
  `hgvs_p` VARCHAR(255) NULL,
  `genome_build` VARCHAR(255) NULL,
  `classification_code` VARCHAR(100) NULL,
  `zygosity` VARCHAR(255) NULL,
  `evidence_level` VARCHAR(100) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_genomics__variant_tenant_id` (`tenant_id`),
  KEY `ix_genomics__variant_created_at` (`created_at`),
  KEY `ix_genomics__variant_genetic_test_id` (`genetic_test_id`),
  KEY `ix_genomics__variant_source_system_id` (`source_system_id`),
  KEY `ix_genomics__variant_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Variante interprétée';

CREATE TABLE IF NOT EXISTS `genomics__disclosure_preference` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `category_code` VARCHAR(100) NULL,
  `receive_results` BOOLEAN NULL,
  `receive_secondary_findings` BOOLEAN NULL,
  `counseling_required` BOOLEAN NULL,
  `effective_from` DATETIME(6) NULL,
  `effective_to` DATETIME(6) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_genomics__disclosure_preference_tenant_id` (`tenant_id`),
  KEY `ix_genomics__disclosure_preference_patient_id` (`patient_id`),
  KEY `ix_genomics__disclosure_preference_created_at` (`created_at`),
  KEY `ix_genomics__disclosure_preference_source_system_id` (`source_system_id`),
  KEY `ix_genomics__disclosure_preference_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Préférence';

CREATE TABLE IF NOT EXISTS `audit__audit_event` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `occurred_at` DATETIME(6) NULL,
  `event_type` VARCHAR(100) NULL,
  `action` VARCHAR(100) NULL,
  `outcome` VARCHAR(100) NULL,
  `actor_user_id` BINARY(16) NULL,
  `actor_org_id` BINARY(16) NULL,
  `patient_id` BINARY(16) NULL,
  `purpose_code` VARCHAR(100) NULL,
  `resource_type` VARCHAR(100) NULL,
  `resource_id` BINARY(16) NULL,
  `grant_id` BINARY(16) NULL,
  `trace_id` BINARY(16) NULL,
  `details_redacted` VARCHAR(255) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_audit__audit_event_tenant_id` (`tenant_id`),
  KEY `ix_audit__audit_event_patient_id` (`patient_id`),
  KEY `ix_audit__audit_event_created_at` (`created_at`),
  KEY `ix_audit__audit_event_actor_user_id` (`actor_user_id`),
  KEY `ix_audit__audit_event_actor_org_id` (`actor_org_id`),
  KEY `ix_audit__audit_event_resource_id` (`resource_id`),
  KEY `ix_audit__audit_event_grant_id` (`grant_id`),
  KEY `ix_audit__audit_event_trace_id` (`trace_id`),
  KEY `ix_audit__audit_event_source_system_id` (`source_system_id`),
  KEY `ix_audit__audit_event_external_id` (`external_id`),
  KEY `ix_audit__audit_event_occurred_at` (`occurred_at`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Événement';

CREATE TABLE IF NOT EXISTS `audit__audit_entity` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `audit_event_id` BINARY(16) NULL,
  `entity_type` VARCHAR(100) NULL,
  `entity_id` BINARY(16) NULL,
  `role_code` VARCHAR(100) NULL,
  `query_hash` VARBINARY(1024) NULL,
  `security_labels` JSON NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_audit__audit_entity_tenant_id` (`tenant_id`),
  KEY `ix_audit__audit_entity_created_at` (`created_at`),
  KEY `ix_audit__audit_entity_audit_event_id` (`audit_event_id`),
  KEY `ix_audit__audit_entity_entity_id` (`entity_id`),
  KEY `ix_audit__audit_entity_source_system_id` (`source_system_id`),
  KEY `ix_audit__audit_entity_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Entité touchée';

CREATE TABLE IF NOT EXISTS `audit__audit_chain` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `partition_date` DATE NULL,
  `sequence_no` INT NULL,
  `event_id` BINARY(16) NULL,
  `previous_hash` VARBINARY(1024) NULL,
  `event_hash` VARBINARY(1024) NULL,
  `chain_hash` VARBINARY(1024) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_audit__audit_chain_tenant_id` (`tenant_id`),
  KEY `ix_audit__audit_chain_created_at` (`created_at`),
  KEY `ix_audit__audit_chain_event_id` (`event_id`),
  KEY `ix_audit__audit_chain_source_system_id` (`source_system_id`),
  KEY `ix_audit__audit_chain_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Chaînage';

CREATE TABLE IF NOT EXISTS `audit__audit_anchor` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `period_start` DATETIME(6) NULL,
  `period_end` DATETIME(6) NULL,
  `root_hash` VARBINARY(1024) NULL,
  `timestamp_authority_uri` VARCHAR(512) NULL,
  `token_uri` VARCHAR(512) NULL,
  `verified_at` DATETIME(6) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_audit__audit_anchor_tenant_id` (`tenant_id`),
  KEY `ix_audit__audit_anchor_created_at` (`created_at`),
  KEY `ix_audit__audit_anchor_source_system_id` (`source_system_id`),
  KEY `ix_audit__audit_anchor_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Ancrage';

CREATE TABLE IF NOT EXISTS `audit__data_export` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `requester_user_id` BINARY(16) NULL,
  `patient_id` BINARY(16) NULL,
  `purpose` VARCHAR(100) NULL,
  `scope` JSON NULL,
  `status` VARCHAR(100) NULL,
  `requested_at` DATETIME(6) NULL,
  `completed_at` DATETIME(6) NULL,
  `document_id` BINARY(16) NULL,
  `expires_at` DATETIME(6) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_audit__data_export_tenant_id` (`tenant_id`),
  KEY `ix_audit__data_export_patient_id` (`patient_id`),
  KEY `ix_audit__data_export_status` (`status`),
  KEY `ix_audit__data_export_created_at` (`created_at`),
  KEY `ix_audit__data_export_requester_user_id` (`requester_user_id`),
  KEY `ix_audit__data_export_document_id` (`document_id`),
  KEY `ix_audit__data_export_source_system_id` (`source_system_id`),
  KEY `ix_audit__data_export_external_id` (`external_id`),
  KEY `ix_audit__data_export_requested_at` (`requested_at`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Export';

CREATE TABLE IF NOT EXISTS `audit__data_access_review` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `audit_event_id` BINARY(16) NULL,
  `risk_score` DECIMAL(19,6) NULL,
  `review_status` VARCHAR(100) NULL,
  `assigned_to` BINARY(16) NULL,
  `reviewed_at` DATETIME(6) NULL,
  `finding_code` VARCHAR(100) NULL,
  `action` VARCHAR(100) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_audit__data_access_review_tenant_id` (`tenant_id`),
  KEY `ix_audit__data_access_review_created_at` (`created_at`),
  KEY `ix_audit__data_access_review_audit_event_id` (`audit_event_id`),
  KEY `ix_audit__data_access_review_source_system_id` (`source_system_id`),
  KEY `ix_audit__data_access_review_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Revue';

CREATE TABLE IF NOT EXISTS `compliance__privacy_request` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL,
  `request_type` VARCHAR(100) NULL,
  `status` VARCHAR(100) NULL,
  `received_at` DATETIME(6) NULL,
  `due_at` DATETIME(6) NULL,
  `identity_verified_at` DATETIME(6) NULL,
  `assigned_to` BINARY(16) NULL,
  `decision` VARCHAR(255) NULL,
  `completed_at` DATETIME(6) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_compliance__privacy_request_tenant_id` (`tenant_id`),
  KEY `ix_compliance__privacy_request_patient_id` (`patient_id`),
  KEY `ix_compliance__privacy_request_status` (`status`),
  KEY `ix_compliance__privacy_request_created_at` (`created_at`),
  KEY `ix_compliance__privacy_request_source_system_id` (`source_system_id`),
  KEY `ix_compliance__privacy_request_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Droit';

CREATE TABLE IF NOT EXISTS `compliance__incident` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `type_code` VARCHAR(100) NULL,
  `severity` VARCHAR(255) NULL,
  `status` VARCHAR(100) NULL,
  `detected_at` DATETIME(6) NULL,
  `reported_by` BINARY(16) NULL,
  `owner_id` BINARY(16) NULL,
  `contained_at` DATETIME(6) NULL,
  `closed_at` DATETIME(6) NULL,
  `jurisdictions` JSON NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_compliance__incident_tenant_id` (`tenant_id`),
  KEY `ix_compliance__incident_status` (`status`),
  KEY `ix_compliance__incident_type_code` (`type_code`),
  KEY `ix_compliance__incident_created_at` (`created_at`),
  KEY `ix_compliance__incident_owner_id` (`owner_id`),
  KEY `ix_compliance__incident_source_system_id` (`source_system_id`),
  KEY `ix_compliance__incident_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Incident';

CREATE TABLE IF NOT EXISTS `compliance__incident_subject` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `incident_id` BINARY(16) NULL,
  `patient_id` BINARY(16) NULL,
  `data_categories` VARCHAR(255) NULL,
  `risk_level` VARCHAR(100) NULL,
  `notified_at` DATETIME(6) NULL,
  `notification_method` VARCHAR(100) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_compliance__incident_subject_tenant_id` (`tenant_id`),
  KEY `ix_compliance__incident_subject_patient_id` (`patient_id`),
  KEY `ix_compliance__incident_subject_created_at` (`created_at`),
  KEY `ix_compliance__incident_subject_incident_id` (`incident_id`),
  KEY `ix_compliance__incident_subject_source_system_id` (`source_system_id`),
  KEY `ix_compliance__incident_subject_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Personne touchée';

CREATE TABLE IF NOT EXISTS `compliance__legal_hold` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `case_ref` VARCHAR(255) NULL,
  `scope_type` VARCHAR(100) NULL,
  `scope_id` BINARY(16) NULL,
  `reason` TEXT NULL,
  `issued_at` DATETIME(6) NULL,
  `released_at` DATETIME(6) NULL,
  `authority` VARCHAR(255) NULL,
  `status` VARCHAR(100) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_compliance__legal_hold_tenant_id` (`tenant_id`),
  KEY `ix_compliance__legal_hold_status` (`status`),
  KEY `ix_compliance__legal_hold_created_at` (`created_at`),
  KEY `ix_compliance__legal_hold_scope_id` (`scope_id`),
  KEY `ix_compliance__legal_hold_source_system_id` (`source_system_id`),
  KEY `ix_compliance__legal_hold_external_id` (`external_id`),
  KEY `ix_compliance__legal_hold_issued_at` (`issued_at`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Gel';

CREATE TABLE IF NOT EXISTS `compliance__retention_policy` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `code` VARCHAR(100) NULL,
  `jurisdiction_id` BINARY(16) NULL,
  `record_type` VARCHAR(100) NULL,
  `trigger_event` VARCHAR(255) NULL,
  `retention_period` VARCHAR(255) NULL,
  `disposition` VARCHAR(255) NULL,
  `version` VARCHAR(255) NULL,
  `effective_from` DATETIME(6) NULL,
  `effective_to` DATETIME(6) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_compliance__retention_policy_tenant_id` (`tenant_id`),
  KEY `ix_compliance__retention_policy_code` (`code`),
  KEY `ix_compliance__retention_policy_created_at` (`created_at`),
  KEY `ix_compliance__retention_policy_jurisdiction_id` (`jurisdiction_id`),
  KEY `ix_compliance__retention_policy_source_system_id` (`source_system_id`),
  KEY `ix_compliance__retention_policy_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Politique';

CREATE TABLE IF NOT EXISTS `compliance__disposition_event` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `policy_id` BINARY(16) NULL,
  `target_type` VARCHAR(100) NULL,
  `target_id` BINARY(16) NULL,
  `decision` VARCHAR(255) NULL,
  `executed_at` DATETIME(6) NULL,
  `certificate_hash` VARBINARY(1024) NULL,
  `blocked_by_hold` BOOLEAN NULL,
  `actor_service_id` BINARY(16) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_compliance__disposition_event_tenant_id` (`tenant_id`),
  KEY `ix_compliance__disposition_event_created_at` (`created_at`),
  KEY `ix_compliance__disposition_event_policy_id` (`policy_id`),
  KEY `ix_compliance__disposition_event_target_id` (`target_id`),
  KEY `ix_compliance__disposition_event_actor_service_id` (`actor_service_id`),
  KEY `ix_compliance__disposition_event_source_system_id` (`source_system_id`),
  KEY `ix_compliance__disposition_event_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Destruction/anonymisation';

CREATE TABLE IF NOT EXISTS `compliance__risk_assessment` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `scope` JSON NULL,
  `method` VARCHAR(100) NULL,
  `started_at` DATETIME(6) NULL,
  `completed_at` DATETIME(6) NULL,
  `owner_id` BINARY(16) NULL,
  `risk_level` VARCHAR(100) NULL,
  `report_document_id` BINARY(16) NULL,
  `next_review_at` DATETIME(6) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_compliance__risk_assessment_tenant_id` (`tenant_id`),
  KEY `ix_compliance__risk_assessment_created_at` (`created_at`),
  KEY `ix_compliance__risk_assessment_owner_id` (`owner_id`),
  KEY `ix_compliance__risk_assessment_report_document_id` (`report_document_id`),
  KEY `ix_compliance__risk_assessment_source_system_id` (`source_system_id`),
  KEY `ix_compliance__risk_assessment_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Évaluation';

CREATE TABLE IF NOT EXISTS `compliance__control_evidence` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `control_code` VARCHAR(100) NULL,
  `assessment_id` BINARY(16) NULL,
  `evidence_type` VARCHAR(100) NULL,
  `document_id` BINARY(16) NULL,
  `collected_at` DATETIME(6) NULL,
  `valid_until` DATETIME(6) NULL,
  `result` VARCHAR(255) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_compliance__control_evidence_tenant_id` (`tenant_id`),
  KEY `ix_compliance__control_evidence_created_at` (`created_at`),
  KEY `ix_compliance__control_evidence_assessment_id` (`assessment_id`),
  KEY `ix_compliance__control_evidence_document_id` (`document_id`),
  KEY `ix_compliance__control_evidence_source_system_id` (`source_system_id`),
  KEY `ix_compliance__control_evidence_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Preuve';

CREATE TABLE IF NOT EXISTS `interop__source_system` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `organization_id` BINARY(16) NULL,
  `code` VARCHAR(100) NULL,
  `name` VARCHAR(255) NULL,
  `system_type` VARCHAR(100) NULL,
  `environment` VARCHAR(255) NULL,
  `status` VARCHAR(100) NULL,
  `trust_level` VARCHAR(100) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_interop__source_system_tenant_id_code` (`tenant_id`, `code`),
  KEY `ix_interop__source_system_tenant_id` (`tenant_id`),
  KEY `ix_interop__source_system_status` (`status`),
  KEY `ix_interop__source_system_code` (`code`),
  KEY `ix_interop__source_system_created_at` (`created_at`),
  KEY `ix_interop__source_system_organization_id` (`organization_id`),
  KEY `ix_interop__source_system_source_system_id` (`source_system_id`),
  KEY `ix_interop__source_system_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Système source';

CREATE TABLE IF NOT EXISTS `interop__endpoint` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `source_system_id` BINARY(16) NULL,
  `protocol` VARCHAR(255) NULL,
  `base_uri` VARCHAR(512) NULL,
  `auth_type` VARCHAR(100) NULL,
  `credential_ref` VARCHAR(255) NULL,
  `status` VARCHAR(100) NULL,
  `capabilities` JSON NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_interop__endpoint_tenant_id` (`tenant_id`),
  KEY `ix_interop__endpoint_status` (`status`),
  KEY `ix_interop__endpoint_created_at` (`created_at`),
  KEY `ix_interop__endpoint_source_system_id` (`source_system_id`),
  KEY `ix_interop__endpoint_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Endpoint';

CREATE TABLE IF NOT EXISTS `interop__interface` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `code` VARCHAR(100) NULL,
  `source_endpoint_id` BINARY(16) NULL,
  `target_endpoint_id` BINARY(16) NULL,
  `message_type` VARCHAR(100) NULL,
  `direction` VARCHAR(255) NULL,
  `version` VARCHAR(255) NULL,
  `status` VARCHAR(100) NULL,
  `sla_seconds` INT NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_interop__interface_tenant_id` (`tenant_id`),
  KEY `ix_interop__interface_status` (`status`),
  KEY `ix_interop__interface_code` (`code`),
  KEY `ix_interop__interface_created_at` (`created_at`),
  KEY `ix_interop__interface_source_endpoint_id` (`source_endpoint_id`),
  KEY `ix_interop__interface_target_endpoint_id` (`target_endpoint_id`),
  KEY `ix_interop__interface_source_system_id` (`source_system_id`),
  KEY `ix_interop__interface_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Interface';

CREATE TABLE IF NOT EXISTS `interop__message` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `interface_id` BINARY(16) NULL,
  `external_message_id` BINARY(16) NULL,
  `correlation_id` BINARY(16) NULL,
  `received_at` DATETIME(6) NULL,
  `status` VARCHAR(100) NULL,
  `payload_uri` VARCHAR(512) NULL,
  `payload_hash` VARBINARY(1024) NULL,
  `patient_id` BINARY(16) NULL,
  `error_code` VARCHAR(100) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_interop__message_tenant_id` (`tenant_id`),
  KEY `ix_interop__message_patient_id` (`patient_id`),
  KEY `ix_interop__message_status` (`status`),
  KEY `ix_interop__message_created_at` (`created_at`),
  KEY `ix_interop__message_interface_id` (`interface_id`),
  KEY `ix_interop__message_external_message_id` (`external_message_id`),
  KEY `ix_interop__message_correlation_id` (`correlation_id`),
  KEY `ix_interop__message_source_system_id` (`source_system_id`),
  KEY `ix_interop__message_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Message';

CREATE TABLE IF NOT EXISTS `interop__message_attempt` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `message_id` BINARY(16) NULL,
  `attempt_no` INT NULL,
  `started_at` DATETIME(6) NULL,
  `ended_at` DATETIME(6) NULL,
  `outcome` VARCHAR(100) NULL,
  `response_code` VARCHAR(100) NULL,
  `error_detail_redacted` VARCHAR(255) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_interop__message_attempt_tenant_id` (`tenant_id`),
  KEY `ix_interop__message_attempt_created_at` (`created_at`),
  KEY `ix_interop__message_attempt_message_id` (`message_id`),
  KEY `ix_interop__message_attempt_source_system_id` (`source_system_id`),
  KEY `ix_interop__message_attempt_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Tentative';

CREATE TABLE IF NOT EXISTS `interop__mapping` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `mapping_type` VARCHAR(100) NULL,
  `source_system` VARCHAR(100) NULL,
  `source_code` VARCHAR(100) NULL,
  `target_system` VARCHAR(100) NULL,
  `target_code` VARCHAR(100) NULL,
  `relationship` VARCHAR(255) NULL,
  `confidence` DECIMAL(19,6) NULL,
  `valid_from` DATETIME(6) NULL,
  `valid_to` DATETIME(6) NULL,
  `status` VARCHAR(100) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_interop__mapping_tenant_id` (`tenant_id`),
  KEY `ix_interop__mapping_status` (`status`),
  KEY `ix_interop__mapping_created_at` (`created_at`),
  KEY `ix_interop__mapping_source_system_id` (`source_system_id`),
  KEY `ix_interop__mapping_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Mapping';

CREATE TABLE IF NOT EXISTS `interop__subscription` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `subscriber_endpoint_id` BINARY(16) NULL,
  `resource_type` VARCHAR(100) NULL,
  `criteria` VARCHAR(255) NULL,
  `channel` VARCHAR(100) NULL,
  `status` VARCHAR(100) NULL,
  `expires_at` DATETIME(6) NULL,
  `secret_ref` VARCHAR(255) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_interop__subscription_tenant_id` (`tenant_id`),
  KEY `ix_interop__subscription_status` (`status`),
  KEY `ix_interop__subscription_created_at` (`created_at`),
  KEY `ix_interop__subscription_subscriber_endpoint_id` (`subscriber_endpoint_id`),
  KEY `ix_interop__subscription_source_system_id` (`source_system_id`),
  KEY `ix_interop__subscription_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Abonnement';

CREATE TABLE IF NOT EXISTS `interop__webhook_delivery` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `subscription_id` BINARY(16) NULL,
  `event_id` BINARY(16) NULL,
  `attempt_no` INT NULL,
  `status` VARCHAR(100) NULL,
  `sent_at` DATETIME(6) NULL,
  `response_code` VARCHAR(100) NULL,
  `next_attempt_at` DATETIME(6) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_interop__webhook_delivery_tenant_id` (`tenant_id`),
  KEY `ix_interop__webhook_delivery_status` (`status`),
  KEY `ix_interop__webhook_delivery_created_at` (`created_at`),
  KEY `ix_interop__webhook_delivery_subscription_id` (`subscription_id`),
  KEY `ix_interop__webhook_delivery_event_id` (`event_id`),
  KEY `ix_interop__webhook_delivery_source_system_id` (`source_system_id`),
  KEY `ix_interop__webhook_delivery_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Livraison';

CREATE TABLE IF NOT EXISTS `interop__fhir_resource_snapshot` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `resource_type` VARCHAR(100) NULL,
  `logical_id` BINARY(16) NULL,
  `version_id` BINARY(16) NULL,
  `patient_id` BINARY(16) NULL,
  `last_updated` VARCHAR(255) NULL,
  `json_content` JSON NULL,
  `content_hash` VARBINARY(1024) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_interop__fhir_resource_snapshot_tenant_id` (`tenant_id`),
  KEY `ix_interop__fhir_resource_snapshot_patient_id` (`patient_id`),
  KEY `ix_interop__fhir_resource_snapshot_created_at` (`created_at`),
  KEY `ix_interop__fhir_resource_snapshot_logical_id` (`logical_id`),
  KEY `ix_interop__fhir_resource_snapshot_version_id` (`version_id`),
  KEY `ix_interop__fhir_resource_snapshot_source_system_id` (`source_system_id`),
  KEY `ix_interop__fhir_resource_snapshot_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Snapshot canonique';

CREATE TABLE IF NOT EXISTS `interop__provenance` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `target_type` VARCHAR(100) NULL,
  `recorded_at` DATETIME(6) NULL,
  `agent_type` VARCHAR(100) NULL,
  `agent_id` BINARY(16) NULL,
  `activity_code` VARCHAR(100) NULL,
  `source_system_id` BINARY(16) NULL,
  `signature_id` BINARY(16) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_interop__provenance_tenant_id` (`tenant_id`),
  KEY `ix_interop__provenance_created_at` (`created_at`),
  KEY `ix_interop__provenance_agent_id` (`agent_id`),
  KEY `ix_interop__provenance_source_system_id` (`source_system_id`),
  KEY `ix_interop__provenance_signature_id` (`signature_id`),
  KEY `ix_interop__provenance_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Provenance';

CREATE TABLE IF NOT EXISTS `ref__code_system` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `uri` VARCHAR(512) NULL,
  `name` VARCHAR(255) NULL,
  `version` VARCHAR(255) NULL,
  `publisher` VARCHAR(255) NULL,
  `status` VARCHAR(100) NULL,
  `content_mode` TEXT NULL,
  `release_date` DATE NULL,
  `license_ref` VARCHAR(255) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_ref__code_system_uri_version` (`uri`, `version`),
  KEY `ix_ref__code_system_tenant_id` (`tenant_id`),
  KEY `ix_ref__code_system_status` (`status`),
  KEY `ix_ref__code_system_created_at` (`created_at`),
  KEY `ix_ref__code_system_source_system_id` (`source_system_id`),
  KEY `ix_ref__code_system_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Système';

CREATE TABLE IF NOT EXISTS `ref__concept` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `code_system_id` BINARY(16) NULL,
  `code` VARCHAR(100) NULL,
  `display` VARCHAR(255) NULL,
  `definition` TEXT NULL,
  `status` VARCHAR(100) NULL,
  `parent_codes` JSON NULL,
  `properties` JSON NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_ref__concept_code_system_id_code` (`code_system_id`, `code`),
  KEY `ix_ref__concept_tenant_id` (`tenant_id`),
  KEY `ix_ref__concept_status` (`status`),
  KEY `ix_ref__concept_code` (`code`),
  KEY `ix_ref__concept_created_at` (`created_at`),
  KEY `ix_ref__concept_code_system_id` (`code_system_id`),
  KEY `ix_ref__concept_source_system_id` (`source_system_id`),
  KEY `ix_ref__concept_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Concept';

CREATE TABLE IF NOT EXISTS `ref__value_set` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `url` VARCHAR(255) NULL,
  `version` VARCHAR(255) NULL,
  `name` VARCHAR(255) NULL,
  `status` VARCHAR(100) NULL,
  `compose` JSON NULL,
  `effective_date` DATE NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_ref__value_set_url_version` (`url`, `version`),
  KEY `ix_ref__value_set_tenant_id` (`tenant_id`),
  KEY `ix_ref__value_set_status` (`status`),
  KEY `ix_ref__value_set_created_at` (`created_at`),
  KEY `ix_ref__value_set_source_system_id` (`source_system_id`),
  KEY `ix_ref__value_set_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Jeu';

CREATE TABLE IF NOT EXISTS `ref__value_set_member` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `value_set_id` BINARY(16) NULL,
  `concept_id` BINARY(16) NULL,
  `active` BOOLEAN NULL,
  `valid_from` DATETIME(6) NULL,
  `valid_to` DATETIME(6) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_ref__value_set_member_tenant_id` (`tenant_id`),
  KEY `ix_ref__value_set_member_created_at` (`created_at`),
  KEY `ix_ref__value_set_member_value_set_id` (`value_set_id`),
  KEY `ix_ref__value_set_member_concept_id` (`concept_id`),
  KEY `ix_ref__value_set_member_source_system_id` (`source_system_id`),
  KEY `ix_ref__value_set_member_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Membre matérialisé';

CREATE TABLE IF NOT EXISTS `ref__unit` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `code` VARCHAR(100) NULL,
  `display` VARCHAR(255) NULL,
  `dimension` VARCHAR(255) NULL,
  `canonical_unit` VARCHAR(255) NULL,
  `factor` DECIMAL(19,6) NULL,
  `offset` DECIMAL(19,6) NULL,
  `active` BOOLEAN NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_ref__unit_code` (`code`),
  KEY `ix_ref__unit_tenant_id` (`tenant_id`),
  KEY `ix_ref__unit_code` (`code`),
  KEY `ix_ref__unit_created_at` (`created_at`),
  KEY `ix_ref__unit_source_system_id` (`source_system_id`),
  KEY `ix_ref__unit_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='UCUM';

CREATE TABLE IF NOT EXISTS `ref__drug_interaction` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `substance_a` VARCHAR(255) NULL,
  `substance_b` VARCHAR(255) NULL,
  `severity` VARCHAR(255) NULL,
  `evidence_level` VARCHAR(100) NULL,
  `description` TEXT NULL,
  `management` VARCHAR(255) NULL,
  `source_version` VARCHAR(255) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_ref__drug_interaction_tenant_id` (`tenant_id`),
  KEY `ix_ref__drug_interaction_created_at` (`created_at`),
  KEY `ix_ref__drug_interaction_source_system_id` (`source_system_id`),
  KEY `ix_ref__drug_interaction_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Interaction';

CREATE TABLE IF NOT EXISTS `ref__clinical_rule` (
  `id` BINARY(16) NOT NULL,
  `tenant_id` BINARY(16) NOT NULL,
  `code` VARCHAR(100) NULL,
  `rule_type` VARCHAR(100) NULL,
  `version` VARCHAR(255) NULL,
  `expression` VARCHAR(255) NULL,
  `severity` VARCHAR(255) NULL,
  `status` VARCHAR(100) NULL,
  `effective_from` DATETIME(6) NULL,
  `effective_to` DATETIME(6) NULL,
  `evidence_uri` VARCHAR(512) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` BINARY(16) NULL,
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` BINARY(16) NULL,
  `row_version` BIGINT NOT NULL DEFAULT 1,
  `source_system_id` BINARY(16) NULL,
  `external_id` VARCHAR(150) NULL,
  `classification` SMALLINT NOT NULL DEFAULT 2,
  `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
  `details` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `ix_ref__clinical_rule_tenant_id` (`tenant_id`),
  KEY `ix_ref__clinical_rule_status` (`status`),
  KEY `ix_ref__clinical_rule_code` (`code`),
  KEY `ix_ref__clinical_rule_created_at` (`created_at`),
  KEY `ix_ref__clinical_rule_source_system_id` (`source_system_id`),
  KEY `ix_ref__clinical_rule_external_id` (`external_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Règle';

DROP PROCEDURE IF EXISTS `_add_fk_if_absent`;
DELIMITER $$
CREATE PROCEDURE `_add_fk_if_absent`(
  IN p_table VARCHAR(64),
  IN p_constraint VARCHAR(64),
  IN p_column VARCHAR(64),
  IN p_ref_table VARCHAR(64),
  IN p_ref_column VARCHAR(64)
)
BEGIN
  IF NOT EXISTS (
    SELECT 1
      FROM information_schema.REFERENTIAL_CONSTRAINTS
     WHERE CONSTRAINT_SCHEMA = DATABASE()
       AND CONSTRAINT_NAME = p_constraint
  ) THEN
    SET @ddl = CONCAT(
      'ALTER TABLE `', REPLACE(p_table, '`', '``'),
      '` ADD CONSTRAINT `', REPLACE(p_constraint, '`', '``'),
      '` FOREIGN KEY (`', REPLACE(p_column, '`', '``'),
      '`) REFERENCES `', REPLACE(p_ref_table, '`', '``'),
      '` (`', REPLACE(p_ref_column, '`', '``'),
      '`) ON UPDATE RESTRICT ON DELETE RESTRICT'
    );
    PREPARE stmt FROM @ddl;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
  END IF;
END$$
DELIMITER ;
CALL `_add_fk_if_absent`('core__tenant', 'fk_core__tenant_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('core__tenant_domain', 'fk_core__tenant_domain_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('core__tenant_domain', 'fk_core__tenant_domain_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('core__jurisdiction', 'fk_core__jurisdiction_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('core__jurisdiction', 'fk_core__jurisdiction_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('core__feature_flag', 'fk_core__feature_flag_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('core__feature_flag', 'fk_core__feature_flag_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('core__configuration', 'fk_core__configuration_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('core__configuration', 'fk_core__configuration_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('core__legal_text', 'fk_core__legal_text_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('core__legal_text', 'fk_core__legal_text_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('core__acceptance_record', 'fk_core__acceptance_record_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('core__acceptance_record', 'fk_core__acceptance_record_actor_user_id', 'actor_user_id', 'iam__user_account', 'id');
CALL `_add_fk_if_absent`('core__acceptance_record', 'fk_core__acceptance_record_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('core__acceptance_record', 'fk_core__acceptance_record_legal_text_id', 'legal_text_id', 'core__legal_text', 'id');
CALL `_add_fk_if_absent`('core__sequence_registry', 'fk_core__sequence_registry_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('core__sequence_registry', 'fk_core__sequence_registry_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('iam__user_account', 'fk_iam__user_account_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('iam__user_account', 'fk_iam__user_account_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('iam__user_identity', 'fk_iam__user_identity_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('iam__user_identity', 'fk_iam__user_identity_user_id', 'user_id', 'iam__user_account', 'id');
CALL `_add_fk_if_absent`('iam__user_identity', 'fk_iam__user_identity_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('iam__credential_factor', 'fk_iam__credential_factor_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('iam__credential_factor', 'fk_iam__credential_factor_user_id', 'user_id', 'iam__user_account', 'id');
CALL `_add_fk_if_absent`('iam__credential_factor', 'fk_iam__credential_factor_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('iam__recovery_method', 'fk_iam__recovery_method_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('iam__recovery_method', 'fk_iam__recovery_method_user_id', 'user_id', 'iam__user_account', 'id');
CALL `_add_fk_if_absent`('iam__recovery_method', 'fk_iam__recovery_method_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('iam__device', 'fk_iam__device_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('iam__device', 'fk_iam__device_user_id', 'user_id', 'iam__user_account', 'id');
CALL `_add_fk_if_absent`('iam__device', 'fk_iam__device_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('iam__session', 'fk_iam__session_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('iam__session', 'fk_iam__session_user_id', 'user_id', 'iam__user_account', 'id');
CALL `_add_fk_if_absent`('iam__session', 'fk_iam__session_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('iam__role', 'fk_iam__role_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('iam__role', 'fk_iam__role_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('iam__permission', 'fk_iam__permission_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('iam__permission', 'fk_iam__permission_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('iam__role_permission', 'fk_iam__role_permission_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('iam__role_permission', 'fk_iam__role_permission_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('iam__role_permission', 'fk_iam__role_permission_role_id', 'role_id', 'iam__role', 'id');
CALL `_add_fk_if_absent`('iam__role_permission', 'fk_iam__role_permission_permission_id', 'permission_id', 'iam__permission', 'id');
CALL `_add_fk_if_absent`('iam__user_role_assignment', 'fk_iam__user_role_assignment_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('iam__user_role_assignment', 'fk_iam__user_role_assignment_user_id', 'user_id', 'iam__user_account', 'id');
CALL `_add_fk_if_absent`('iam__user_role_assignment', 'fk_iam__user_role_assignment_organization_id', 'organization_id', 'org__organization', 'id');
CALL `_add_fk_if_absent`('iam__user_role_assignment', 'fk_iam__user_role_assignment_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('iam__user_role_assignment', 'fk_iam__user_role_assignment_role_id', 'role_id', 'iam__role', 'id');
CALL `_add_fk_if_absent`('iam__service_principal', 'fk_iam__service_principal_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('iam__service_principal', 'fk_iam__service_principal_owner_org_id', 'owner_org_id', 'org__organization', 'id');
CALL `_add_fk_if_absent`('iam__service_principal', 'fk_iam__service_principal_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('iam__service_scope', 'fk_iam__service_scope_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('iam__service_scope', 'fk_iam__service_scope_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('iam__login_event', 'fk_iam__login_event_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('iam__login_event', 'fk_iam__login_event_user_id', 'user_id', 'iam__user_account', 'id');
CALL `_add_fk_if_absent`('iam__login_event', 'fk_iam__login_event_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('patient__patient', 'fk_patient__patient_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('patient__patient', 'fk_patient__patient_user_id', 'user_id', 'iam__user_account', 'id');
CALL `_add_fk_if_absent`('patient__patient', 'fk_patient__patient_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('patient__patient_name', 'fk_patient__patient_name_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('patient__patient_name', 'fk_patient__patient_name_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('patient__patient_name', 'fk_patient__patient_name_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('patient__patient_identifier', 'fk_patient__patient_identifier_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('patient__patient_identifier', 'fk_patient__patient_identifier_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('patient__patient_identifier', 'fk_patient__patient_identifier_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('patient__patient_address', 'fk_patient__patient_address_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('patient__patient_address', 'fk_patient__patient_address_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('patient__patient_address', 'fk_patient__patient_address_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('patient__patient_contact_point', 'fk_patient__patient_contact_point_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('patient__patient_contact_point', 'fk_patient__patient_contact_point_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('patient__patient_contact_point', 'fk_patient__patient_contact_point_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('patient__emergency_contact', 'fk_patient__emergency_contact_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('patient__emergency_contact', 'fk_patient__emergency_contact_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('patient__emergency_contact', 'fk_patient__emergency_contact_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('patient__related_person', 'fk_patient__related_person_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('patient__related_person', 'fk_patient__related_person_user_id', 'user_id', 'iam__user_account', 'id');
CALL `_add_fk_if_absent`('patient__related_person', 'fk_patient__related_person_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('patient__patient_relationship', 'fk_patient__patient_relationship_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('patient__patient_relationship', 'fk_patient__patient_relationship_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('patient__patient_relationship', 'fk_patient__patient_relationship_evidence_document_id', 'evidence_document_id', 'document__document', 'id');
CALL `_add_fk_if_absent`('patient__patient_relationship', 'fk_patient__patient_relationship_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('patient__communication_preference', 'fk_patient__communication_preference_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('patient__communication_preference', 'fk_patient__communication_preference_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('patient__communication_preference', 'fk_patient__communication_preference_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('patient__accessibility_need', 'fk_patient__accessibility_need_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('patient__accessibility_need', 'fk_patient__accessibility_need_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('patient__accessibility_need', 'fk_patient__accessibility_need_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('patient__advance_directive', 'fk_patient__advance_directive_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('patient__advance_directive', 'fk_patient__advance_directive_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('patient__advance_directive', 'fk_patient__advance_directive_custodian_org_id', 'custodian_org_id', 'org__organization', 'id');
CALL `_add_fk_if_absent`('patient__advance_directive', 'fk_patient__advance_directive_document_id', 'document_id', 'document__document', 'id');
CALL `_add_fk_if_absent`('patient__advance_directive', 'fk_patient__advance_directive_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('patient__patient_declaration', 'fk_patient__patient_declaration_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('patient__patient_declaration', 'fk_patient__patient_declaration_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('patient__patient_declaration', 'fk_patient__patient_declaration_evidence_document_id', 'evidence_document_id', 'document__document', 'id');
CALL `_add_fk_if_absent`('patient__patient_declaration', 'fk_patient__patient_declaration_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('patient__patient_link', 'fk_patient__patient_link_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('patient__patient_link', 'fk_patient__patient_link_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('patient__patient_link', 'fk_patient__patient_link_other_patient_id', 'other_patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('patient__patient_link', 'fk_patient__patient_link_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('patient__merge_history', 'fk_patient__merge_history_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('patient__merge_history', 'fk_patient__merge_history_surviving_patient_id', 'surviving_patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('patient__merge_history', 'fk_patient__merge_history_merged_patient_id', 'merged_patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('patient__merge_history', 'fk_patient__merge_history_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('patient__identity_match_case', 'fk_patient__identity_match_case_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('patient__identity_match_case', 'fk_patient__identity_match_case_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('org__organization', 'fk_org__organization_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('org__organization', 'fk_org__organization_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('org__organization_identifier', 'fk_org__organization_identifier_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('org__organization_identifier', 'fk_org__organization_identifier_organization_id', 'organization_id', 'org__organization', 'id');
CALL `_add_fk_if_absent`('org__organization_identifier', 'fk_org__organization_identifier_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('org__location', 'fk_org__location_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('org__location', 'fk_org__location_organization_id', 'organization_id', 'org__organization', 'id');
CALL `_add_fk_if_absent`('org__location', 'fk_org__location_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('org__location_address', 'fk_org__location_address_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('org__location_address', 'fk_org__location_address_location_id', 'location_id', 'org__location', 'id');
CALL `_add_fk_if_absent`('org__location_address', 'fk_org__location_address_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('org__department', 'fk_org__department_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('org__department', 'fk_org__department_organization_id', 'organization_id', 'org__organization', 'id');
CALL `_add_fk_if_absent`('org__department', 'fk_org__department_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('org__healthcare_service', 'fk_org__healthcare_service_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('org__healthcare_service', 'fk_org__healthcare_service_organization_id', 'organization_id', 'org__organization', 'id');
CALL `_add_fk_if_absent`('org__healthcare_service', 'fk_org__healthcare_service_location_id', 'location_id', 'org__location', 'id');
CALL `_add_fk_if_absent`('org__healthcare_service', 'fk_org__healthcare_service_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('org__service_schedule', 'fk_org__service_schedule_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('org__service_schedule', 'fk_org__service_schedule_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('org__organization_endpoint', 'fk_org__organization_endpoint_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('org__organization_endpoint', 'fk_org__organization_endpoint_organization_id', 'organization_id', 'org__organization', 'id');
CALL `_add_fk_if_absent`('org__organization_endpoint', 'fk_org__organization_endpoint_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('org__organization_endpoint', 'fk_org__organization_endpoint_endpoint_id', 'endpoint_id', 'interop__endpoint', 'id');
CALL `_add_fk_if_absent`('pro__practitioner', 'fk_pro__practitioner_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('pro__practitioner', 'fk_pro__practitioner_user_id', 'user_id', 'iam__user_account', 'id');
CALL `_add_fk_if_absent`('pro__practitioner', 'fk_pro__practitioner_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('pro__practitioner_identifier', 'fk_pro__practitioner_identifier_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('pro__practitioner_identifier', 'fk_pro__practitioner_identifier_practitioner_id', 'practitioner_id', 'pro__practitioner', 'id');
CALL `_add_fk_if_absent`('pro__practitioner_identifier', 'fk_pro__practitioner_identifier_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('pro__license', 'fk_pro__license_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('pro__license', 'fk_pro__license_practitioner_id', 'practitioner_id', 'pro__practitioner', 'id');
CALL `_add_fk_if_absent`('pro__license', 'fk_pro__license_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('pro__qualification', 'fk_pro__qualification_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('pro__qualification', 'fk_pro__qualification_practitioner_id', 'practitioner_id', 'pro__practitioner', 'id');
CALL `_add_fk_if_absent`('pro__qualification', 'fk_pro__qualification_document_id', 'document_id', 'document__document', 'id');
CALL `_add_fk_if_absent`('pro__qualification', 'fk_pro__qualification_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('pro__specialty', 'fk_pro__specialty_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('pro__specialty', 'fk_pro__specialty_practitioner_id', 'practitioner_id', 'pro__practitioner', 'id');
CALL `_add_fk_if_absent`('pro__specialty', 'fk_pro__specialty_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('pro__affiliation', 'fk_pro__affiliation_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('pro__affiliation', 'fk_pro__affiliation_practitioner_id', 'practitioner_id', 'pro__practitioner', 'id');
CALL `_add_fk_if_absent`('pro__affiliation', 'fk_pro__affiliation_organization_id', 'organization_id', 'org__organization', 'id');
CALL `_add_fk_if_absent`('pro__affiliation', 'fk_pro__affiliation_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('pro__privilege', 'fk_pro__privilege_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('pro__privilege', 'fk_pro__privilege_location_id', 'location_id', 'org__location', 'id');
CALL `_add_fk_if_absent`('pro__privilege', 'fk_pro__privilege_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('pro__professional_address', 'fk_pro__professional_address_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('pro__professional_address', 'fk_pro__professional_address_practitioner_id', 'practitioner_id', 'pro__practitioner', 'id');
CALL `_add_fk_if_absent`('pro__professional_address', 'fk_pro__professional_address_organization_id', 'organization_id', 'org__organization', 'id');
CALL `_add_fk_if_absent`('pro__professional_address', 'fk_pro__professional_address_location_id', 'location_id', 'org__location', 'id');
CALL `_add_fk_if_absent`('pro__professional_address', 'fk_pro__professional_address_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('pro__availability', 'fk_pro__availability_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('pro__availability', 'fk_pro__availability_practitioner_id', 'practitioner_id', 'pro__practitioner', 'id');
CALL `_add_fk_if_absent`('pro__availability', 'fk_pro__availability_location_id', 'location_id', 'org__location', 'id');
CALL `_add_fk_if_absent`('pro__availability', 'fk_pro__availability_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('pro__signature_credential', 'fk_pro__signature_credential_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('pro__signature_credential', 'fk_pro__signature_credential_practitioner_id', 'practitioner_id', 'pro__practitioner', 'id');
CALL `_add_fk_if_absent`('pro__signature_credential', 'fk_pro__signature_credential_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('pro__verification_check', 'fk_pro__verification_check_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('pro__verification_check', 'fk_pro__verification_check_practitioner_id', 'practitioner_id', 'pro__practitioner', 'id');
CALL `_add_fk_if_absent`('pro__verification_check', 'fk_pro__verification_check_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('consent__consent_directive', 'fk_consent__consent_directive_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('consent__consent_directive', 'fk_consent__consent_directive_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('consent__consent_directive', 'fk_consent__consent_directive_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('consent__consent_version', 'fk_consent__consent_version_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('consent__consent_version', 'fk_consent__consent_version_consent_id', 'consent_id', 'consent__consent_directive', 'id');
CALL `_add_fk_if_absent`('consent__consent_version', 'fk_consent__consent_version_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('consent__consent_grantee', 'fk_consent__consent_grantee_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('consent__consent_grantee', 'fk_consent__consent_grantee_practitioner_id', 'practitioner_id', 'pro__practitioner', 'id');
CALL `_add_fk_if_absent`('consent__consent_grantee', 'fk_consent__consent_grantee_organization_id', 'organization_id', 'org__organization', 'id');
CALL `_add_fk_if_absent`('consent__consent_grantee', 'fk_consent__consent_grantee_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('consent__consent_scope', 'fk_consent__consent_scope_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('consent__consent_scope', 'fk_consent__consent_scope_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('consent__consent_exclusion', 'fk_consent__consent_exclusion_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('consent__consent_exclusion', 'fk_consent__consent_exclusion_organization_id', 'organization_id', 'org__organization', 'id');
CALL `_add_fk_if_absent`('consent__consent_exclusion', 'fk_consent__consent_exclusion_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('consent__consent_obligation', 'fk_consent__consent_obligation_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('consent__consent_obligation', 'fk_consent__consent_obligation_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('consent__consent_evidence', 'fk_consent__consent_evidence_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('consent__consent_evidence', 'fk_consent__consent_evidence_document_id', 'document_id', 'document__document', 'id');
CALL `_add_fk_if_absent`('consent__consent_evidence', 'fk_consent__consent_evidence_signature_id', 'signature_id', 'document__signature', 'id');
CALL `_add_fk_if_absent`('consent__consent_evidence', 'fk_consent__consent_evidence_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('consent__access_request', 'fk_consent__access_request_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('consent__access_request', 'fk_consent__access_request_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('consent__access_request', 'fk_consent__access_request_requester_org_id', 'requester_org_id', 'org__organization', 'id');
CALL `_add_fk_if_absent`('consent__access_request', 'fk_consent__access_request_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('consent__access_request_scope', 'fk_consent__access_request_scope_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('consent__access_request_scope', 'fk_consent__access_request_scope_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('consent__access_decision', 'fk_consent__access_decision_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('consent__access_decision', 'fk_consent__access_decision_decider_user_id', 'decider_user_id', 'iam__user_account', 'id');
CALL `_add_fk_if_absent`('consent__access_decision', 'fk_consent__access_decision_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('consent__access_grant', 'fk_consent__access_grant_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('consent__access_grant', 'fk_consent__access_grant_subject_user_id', 'subject_user_id', 'iam__user_account', 'id');
CALL `_add_fk_if_absent`('consent__access_grant', 'fk_consent__access_grant_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('consent__access_grant', 'fk_consent__access_grant_organization_id', 'organization_id', 'org__organization', 'id');
CALL `_add_fk_if_absent`('consent__access_grant', 'fk_consent__access_grant_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('consent__access_grant_scope', 'fk_consent__access_grant_scope_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('consent__access_grant_scope', 'fk_consent__access_grant_scope_grant_id', 'grant_id', 'consent__access_grant', 'id');
CALL `_add_fk_if_absent`('consent__access_grant_scope', 'fk_consent__access_grant_scope_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('consent__qr_challenge', 'fk_consent__qr_challenge_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('consent__qr_challenge', 'fk_consent__qr_challenge_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('consent__qr_challenge', 'fk_consent__qr_challenge_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('consent__break_glass_event', 'fk_consent__break_glass_event_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('consent__break_glass_event', 'fk_consent__break_glass_event_practitioner_id', 'practitioner_id', 'pro__practitioner', 'id');
CALL `_add_fk_if_absent`('consent__break_glass_event', 'fk_consent__break_glass_event_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('consent__break_glass_event', 'fk_consent__break_glass_event_organization_id', 'organization_id', 'org__organization', 'id');
CALL `_add_fk_if_absent`('consent__break_glass_event', 'fk_consent__break_glass_event_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('consent__policy', 'fk_consent__policy_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('consent__policy', 'fk_consent__policy_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('consent__policy_rule', 'fk_consent__policy_rule_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('consent__policy_rule', 'fk_consent__policy_rule_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('consent__policy_decision_log', 'fk_consent__policy_decision_log_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('consent__policy_decision_log', 'fk_consent__policy_decision_log_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('consent__policy_decision_log', 'fk_consent__policy_decision_log_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('consent__revocation_event', 'fk_consent__revocation_event_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('consent__revocation_event', 'fk_consent__revocation_event_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('clinical__episode_of_care', 'fk_clinical__episode_of_care_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('clinical__episode_of_care', 'fk_clinical__episode_of_care_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('clinical__episode_of_care', 'fk_clinical__episode_of_care_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('clinical__encounter', 'fk_clinical__encounter_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('clinical__encounter', 'fk_clinical__encounter_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('clinical__encounter', 'fk_clinical__encounter_service_org_id', 'service_org_id', 'org__organization', 'id');
CALL `_add_fk_if_absent`('clinical__encounter', 'fk_clinical__encounter_location_id', 'location_id', 'org__location', 'id');
CALL `_add_fk_if_absent`('clinical__encounter', 'fk_clinical__encounter_episode_id', 'episode_id', 'clinical__episode_of_care', 'id');
CALL `_add_fk_if_absent`('clinical__encounter', 'fk_clinical__encounter_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('clinical__encounter_participant', 'fk_clinical__encounter_participant_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('clinical__encounter_participant', 'fk_clinical__encounter_participant_practitioner_id', 'practitioner_id', 'pro__practitioner', 'id');
CALL `_add_fk_if_absent`('clinical__encounter_participant', 'fk_clinical__encounter_participant_encounter_id', 'encounter_id', 'clinical__encounter', 'id');
CALL `_add_fk_if_absent`('clinical__encounter_participant', 'fk_clinical__encounter_participant_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('clinical__problem', 'fk_clinical__problem_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('clinical__problem', 'fk_clinical__problem_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('clinical__problem', 'fk_clinical__problem_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('clinical__diagnosis', 'fk_clinical__diagnosis_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('clinical__diagnosis', 'fk_clinical__diagnosis_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('clinical__diagnosis', 'fk_clinical__diagnosis_encounter_id', 'encounter_id', 'clinical__encounter', 'id');
CALL `_add_fk_if_absent`('clinical__diagnosis', 'fk_clinical__diagnosis_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('clinical__allergy_intolerance', 'fk_clinical__allergy_intolerance_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('clinical__allergy_intolerance', 'fk_clinical__allergy_intolerance_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('clinical__allergy_intolerance', 'fk_clinical__allergy_intolerance_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('clinical__allergy_reaction', 'fk_clinical__allergy_reaction_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('clinical__allergy_reaction', 'fk_clinical__allergy_reaction_allergy_id', 'allergy_id', 'clinical__allergy_intolerance', 'id');
CALL `_add_fk_if_absent`('clinical__allergy_reaction', 'fk_clinical__allergy_reaction_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('clinical__family_history', 'fk_clinical__family_history_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('clinical__family_history', 'fk_clinical__family_history_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('clinical__family_history', 'fk_clinical__family_history_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('clinical__family_history_condition', 'fk_clinical__family_history_condition_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('clinical__family_history_condition', 'fk_clinical__family_history_condition_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('clinical__procedure', 'fk_clinical__procedure_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('clinical__procedure', 'fk_clinical__procedure_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('clinical__procedure', 'fk_clinical__procedure_performer_org_id', 'performer_org_id', 'org__organization', 'id');
CALL `_add_fk_if_absent`('clinical__procedure', 'fk_clinical__procedure_encounter_id', 'encounter_id', 'clinical__encounter', 'id');
CALL `_add_fk_if_absent`('clinical__procedure', 'fk_clinical__procedure_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('clinical__procedure_participant', 'fk_clinical__procedure_participant_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('clinical__procedure_participant', 'fk_clinical__procedure_participant_practitioner_id', 'practitioner_id', 'pro__practitioner', 'id');
CALL `_add_fk_if_absent`('clinical__procedure_participant', 'fk_clinical__procedure_participant_organization_id', 'organization_id', 'org__organization', 'id');
CALL `_add_fk_if_absent`('clinical__procedure_participant', 'fk_clinical__procedure_participant_procedure_id', 'procedure_id', 'clinical__procedure', 'id');
CALL `_add_fk_if_absent`('clinical__procedure_participant', 'fk_clinical__procedure_participant_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('clinical__hospitalization', 'fk_clinical__hospitalization_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('clinical__hospitalization', 'fk_clinical__hospitalization_encounter_id', 'encounter_id', 'clinical__encounter', 'id');
CALL `_add_fk_if_absent`('clinical__hospitalization', 'fk_clinical__hospitalization_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('clinical__care_plan', 'fk_clinical__care_plan_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('clinical__care_plan', 'fk_clinical__care_plan_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('clinical__care_plan', 'fk_clinical__care_plan_encounter_id', 'encounter_id', 'clinical__encounter', 'id');
CALL `_add_fk_if_absent`('clinical__care_plan', 'fk_clinical__care_plan_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('clinical__care_goal', 'fk_clinical__care_goal_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('clinical__care_goal', 'fk_clinical__care_goal_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('clinical__care_goal', 'fk_clinical__care_goal_care_plan_id', 'care_plan_id', 'clinical__care_plan', 'id');
CALL `_add_fk_if_absent`('clinical__care_goal', 'fk_clinical__care_goal_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('clinical__care_activity', 'fk_clinical__care_activity_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('clinical__care_activity', 'fk_clinical__care_activity_care_plan_id', 'care_plan_id', 'clinical__care_plan', 'id');
CALL `_add_fk_if_absent`('clinical__care_activity', 'fk_clinical__care_activity_goal_id', 'goal_id', 'clinical__care_goal', 'id');
CALL `_add_fk_if_absent`('clinical__care_activity', 'fk_clinical__care_activity_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('clinical__clinical_note', 'fk_clinical__clinical_note_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('clinical__clinical_note', 'fk_clinical__clinical_note_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('clinical__clinical_note', 'fk_clinical__clinical_note_encounter_id', 'encounter_id', 'clinical__encounter', 'id');
CALL `_add_fk_if_absent`('clinical__clinical_note', 'fk_clinical__clinical_note_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('clinical__social_history', 'fk_clinical__social_history_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('clinical__social_history', 'fk_clinical__social_history_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('clinical__social_history', 'fk_clinical__social_history_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('clinical__functional_status', 'fk_clinical__functional_status_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('clinical__functional_status', 'fk_clinical__functional_status_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('clinical__functional_status', 'fk_clinical__functional_status_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('clinical__device_use', 'fk_clinical__device_use_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('clinical__device_use', 'fk_clinical__device_use_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('clinical__device_use', 'fk_clinical__device_use_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('clinical__adverse_event', 'fk_clinical__adverse_event_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('clinical__adverse_event', 'fk_clinical__adverse_event_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('clinical__adverse_event', 'fk_clinical__adverse_event_encounter_id', 'encounter_id', 'clinical__encounter', 'id');
CALL `_add_fk_if_absent`('clinical__adverse_event', 'fk_clinical__adverse_event_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('clinical__pregnancy', 'fk_clinical__pregnancy_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('clinical__pregnancy', 'fk_clinical__pregnancy_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('clinical__pregnancy', 'fk_clinical__pregnancy_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('clinical__pregnancy_event', 'fk_clinical__pregnancy_event_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('clinical__pregnancy_event', 'fk_clinical__pregnancy_event_encounter_id', 'encounter_id', 'clinical__encounter', 'id');
CALL `_add_fk_if_absent`('clinical__pregnancy_event', 'fk_clinical__pregnancy_event_pregnancy_id', 'pregnancy_id', 'clinical__pregnancy', 'id');
CALL `_add_fk_if_absent`('clinical__pregnancy_event', 'fk_clinical__pregnancy_event_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('clinical__mental_health_assessment', 'fk_clinical__mental_health_assessment_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('clinical__mental_health_assessment', 'fk_clinical__mental_health_assessment_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('clinical__mental_health_assessment', 'fk_clinical__mental_health_assessment_encounter_id', 'encounter_id', 'clinical__encounter', 'id');
CALL `_add_fk_if_absent`('clinical__mental_health_assessment', 'fk_clinical__mental_health_assessment_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('clinical__rehabilitation_plan', 'fk_clinical__rehabilitation_plan_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('clinical__rehabilitation_plan', 'fk_clinical__rehabilitation_plan_therapist_id', 'therapist_id', 'pro__practitioner', 'id');
CALL `_add_fk_if_absent`('clinical__rehabilitation_plan', 'fk_clinical__rehabilitation_plan_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('clinical__rehabilitation_plan', 'fk_clinical__rehabilitation_plan_care_plan_id', 'care_plan_id', 'clinical__care_plan', 'id');
CALL `_add_fk_if_absent`('clinical__rehabilitation_plan', 'fk_clinical__rehabilitation_plan_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('clinical__nutrition_assessment', 'fk_clinical__nutrition_assessment_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('clinical__nutrition_assessment', 'fk_clinical__nutrition_assessment_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('clinical__nutrition_assessment', 'fk_clinical__nutrition_assessment_encounter_id', 'encounter_id', 'clinical__encounter', 'id');
CALL `_add_fk_if_absent`('clinical__nutrition_assessment', 'fk_clinical__nutrition_assessment_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('clinical__immunization', 'fk_clinical__immunization_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('clinical__immunization', 'fk_clinical__immunization_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('clinical__immunization', 'fk_clinical__immunization_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('clinical__immunization_recommendation', 'fk_clinical__immunization_recommendation_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('clinical__immunization_recommendation', 'fk_clinical__immunization_recommendation_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('clinical__immunization_recommendation', 'fk_clinical__immunization_recommendation_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('med__medication_catalog', 'fk_med__medication_catalog_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('med__medication_catalog', 'fk_med__medication_catalog_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('med__medication_ingredient', 'fk_med__medication_ingredient_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('med__medication_ingredient', 'fk_med__medication_ingredient_medication_id', 'medication_id', 'med__medication_catalog', 'id');
CALL `_add_fk_if_absent`('med__medication_ingredient', 'fk_med__medication_ingredient_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('med__prescription', 'fk_med__prescription_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('med__prescription', 'fk_med__prescription_prescriber_id', 'prescriber_id', 'pro__practitioner', 'id');
CALL `_add_fk_if_absent`('med__prescription', 'fk_med__prescription_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('med__prescription', 'fk_med__prescription_signature_id', 'signature_id', 'document__signature', 'id');
CALL `_add_fk_if_absent`('med__prescription', 'fk_med__prescription_encounter_id', 'encounter_id', 'clinical__encounter', 'id');
CALL `_add_fk_if_absent`('med__prescription', 'fk_med__prescription_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('med__prescription_item', 'fk_med__prescription_item_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('med__prescription_item', 'fk_med__prescription_item_prescription_id', 'prescription_id', 'med__prescription', 'id');
CALL `_add_fk_if_absent`('med__prescription_item', 'fk_med__prescription_item_medication_id', 'medication_id', 'med__medication_catalog', 'id');
CALL `_add_fk_if_absent`('med__prescription_item', 'fk_med__prescription_item_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('med__dosage_instruction', 'fk_med__dosage_instruction_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('med__dosage_instruction', 'fk_med__dosage_instruction_prescription_item_id', 'prescription_item_id', 'med__prescription_item', 'id');
CALL `_add_fk_if_absent`('med__dosage_instruction', 'fk_med__dosage_instruction_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('med__prescription_validation', 'fk_med__prescription_validation_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('med__prescription_validation', 'fk_med__prescription_validation_prescription_id', 'prescription_id', 'med__prescription', 'id');
CALL `_add_fk_if_absent`('med__prescription_validation', 'fk_med__prescription_validation_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('med__renewal_request', 'fk_med__renewal_request_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('med__renewal_request', 'fk_med__renewal_request_prescription_id', 'prescription_id', 'med__prescription', 'id');
CALL `_add_fk_if_absent`('med__renewal_request', 'fk_med__renewal_request_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('med__dispense', 'fk_med__dispense_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('med__dispense', 'fk_med__dispense_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('med__dispense', 'fk_med__dispense_prescription_item_id', 'prescription_item_id', 'med__prescription_item', 'id');
CALL `_add_fk_if_absent`('med__dispense', 'fk_med__dispense_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('med__medication_administration', 'fk_med__medication_administration_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('med__medication_administration', 'fk_med__medication_administration_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('med__medication_administration', 'fk_med__medication_administration_encounter_id', 'encounter_id', 'clinical__encounter', 'id');
CALL `_add_fk_if_absent`('med__medication_administration', 'fk_med__medication_administration_prescription_item_id', 'prescription_item_id', 'med__prescription_item', 'id');
CALL `_add_fk_if_absent`('med__medication_administration', 'fk_med__medication_administration_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('med__medication_statement', 'fk_med__medication_statement_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('med__medication_statement', 'fk_med__medication_statement_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('med__medication_statement', 'fk_med__medication_statement_medication_id', 'medication_id', 'med__medication_catalog', 'id');
CALL `_add_fk_if_absent`('med__medication_statement', 'fk_med__medication_statement_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('med__reconciliation', 'fk_med__reconciliation_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('med__reconciliation', 'fk_med__reconciliation_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('med__reconciliation', 'fk_med__reconciliation_signature_id', 'signature_id', 'document__signature', 'id');
CALL `_add_fk_if_absent`('med__reconciliation', 'fk_med__reconciliation_encounter_id', 'encounter_id', 'clinical__encounter', 'id');
CALL `_add_fk_if_absent`('med__reconciliation', 'fk_med__reconciliation_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('med__reconciliation_item', 'fk_med__reconciliation_item_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('med__reconciliation_item', 'fk_med__reconciliation_item_prescription_item_id', 'prescription_item_id', 'med__prescription_item', 'id');
CALL `_add_fk_if_absent`('med__reconciliation_item', 'fk_med__reconciliation_item_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('lab__service_request', 'fk_lab__service_request_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('lab__service_request', 'fk_lab__service_request_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('lab__service_request', 'fk_lab__service_request_performer_org_id', 'performer_org_id', 'org__organization', 'id');
CALL `_add_fk_if_absent`('lab__service_request', 'fk_lab__service_request_encounter_id', 'encounter_id', 'clinical__encounter', 'id');
CALL `_add_fk_if_absent`('lab__service_request', 'fk_lab__service_request_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('lab__service_request_item', 'fk_lab__service_request_item_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('lab__service_request_item', 'fk_lab__service_request_item_service_request_id', 'service_request_id', 'lab__service_request', 'id');
CALL `_add_fk_if_absent`('lab__service_request_item', 'fk_lab__service_request_item_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('lab__specimen', 'fk_lab__specimen_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('lab__specimen', 'fk_lab__specimen_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('lab__specimen', 'fk_lab__specimen_service_request_id', 'service_request_id', 'lab__service_request', 'id');
CALL `_add_fk_if_absent`('lab__specimen', 'fk_lab__specimen_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('lab__specimen_event', 'fk_lab__specimen_event_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('lab__specimen_event', 'fk_lab__specimen_event_organization_id', 'organization_id', 'org__organization', 'id');
CALL `_add_fk_if_absent`('lab__specimen_event', 'fk_lab__specimen_event_location_id', 'location_id', 'org__location', 'id');
CALL `_add_fk_if_absent`('lab__specimen_event', 'fk_lab__specimen_event_specimen_id', 'specimen_id', 'lab__specimen', 'id');
CALL `_add_fk_if_absent`('lab__specimen_event', 'fk_lab__specimen_event_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('lab__diagnostic_report', 'fk_lab__diagnostic_report_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('lab__diagnostic_report', 'fk_lab__diagnostic_report_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('lab__diagnostic_report', 'fk_lab__diagnostic_report_performer_org_id', 'performer_org_id', 'org__organization', 'id');
CALL `_add_fk_if_absent`('lab__diagnostic_report', 'fk_lab__diagnostic_report_document_id', 'document_id', 'document__document', 'id');
CALL `_add_fk_if_absent`('lab__diagnostic_report', 'fk_lab__diagnostic_report_signature_id', 'signature_id', 'document__signature', 'id');
CALL `_add_fk_if_absent`('lab__diagnostic_report', 'fk_lab__diagnostic_report_service_request_id', 'service_request_id', 'lab__service_request', 'id');
CALL `_add_fk_if_absent`('lab__diagnostic_report', 'fk_lab__diagnostic_report_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('lab__observation', 'fk_lab__observation_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('lab__observation', 'fk_lab__observation_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('lab__observation', 'fk_lab__observation_encounter_id', 'encounter_id', 'clinical__encounter', 'id');
CALL `_add_fk_if_absent`('lab__observation', 'fk_lab__observation_specimen_id', 'specimen_id', 'lab__specimen', 'id');
CALL `_add_fk_if_absent`('lab__observation', 'fk_lab__observation_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('lab__observation_component', 'fk_lab__observation_component_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('lab__observation_component', 'fk_lab__observation_component_observation_id', 'observation_id', 'lab__observation', 'id');
CALL `_add_fk_if_absent`('lab__observation_component', 'fk_lab__observation_component_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('lab__reference_range', 'fk_lab__reference_range_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('lab__reference_range', 'fk_lab__reference_range_observation_id', 'observation_id', 'lab__observation', 'id');
CALL `_add_fk_if_absent`('lab__reference_range', 'fk_lab__reference_range_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('lab__result_correction', 'fk_lab__result_correction_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('lab__result_correction', 'fk_lab__result_correction_observation_id', 'observation_id', 'lab__observation', 'id');
CALL `_add_fk_if_absent`('lab__result_correction', 'fk_lab__result_correction_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('lab__critical_result', 'fk_lab__critical_result_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('lab__critical_result', 'fk_lab__critical_result_observation_id', 'observation_id', 'lab__observation', 'id');
CALL `_add_fk_if_absent`('lab__critical_result', 'fk_lab__critical_result_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('lab__ocr_extraction', 'fk_lab__ocr_extraction_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('lab__ocr_extraction', 'fk_lab__ocr_extraction_document_id', 'document_id', 'document__document', 'id');
CALL `_add_fk_if_absent`('lab__ocr_extraction', 'fk_lab__ocr_extraction_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('imaging__imaging_order', 'fk_imaging__imaging_order_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('imaging__imaging_order', 'fk_imaging__imaging_order_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('imaging__imaging_order', 'fk_imaging__imaging_order_performer_org_id', 'performer_org_id', 'org__organization', 'id');
CALL `_add_fk_if_absent`('imaging__imaging_order', 'fk_imaging__imaging_order_encounter_id', 'encounter_id', 'clinical__encounter', 'id');
CALL `_add_fk_if_absent`('imaging__imaging_order', 'fk_imaging__imaging_order_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('imaging__study', 'fk_imaging__study_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('imaging__study', 'fk_imaging__study_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('imaging__study', 'fk_imaging__study_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('imaging__series', 'fk_imaging__series_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('imaging__series', 'fk_imaging__series_study_id', 'study_id', 'imaging__study', 'id');
CALL `_add_fk_if_absent`('imaging__series', 'fk_imaging__series_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('imaging__instance', 'fk_imaging__instance_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('imaging__instance', 'fk_imaging__instance_series_id', 'series_id', 'imaging__series', 'id');
CALL `_add_fk_if_absent`('imaging__instance', 'fk_imaging__instance_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('imaging__report', 'fk_imaging__report_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('imaging__report', 'fk_imaging__report_radiologist_id', 'radiologist_id', 'pro__practitioner', 'id');
CALL `_add_fk_if_absent`('imaging__report', 'fk_imaging__report_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('imaging__report', 'fk_imaging__report_document_id', 'document_id', 'document__document', 'id');
CALL `_add_fk_if_absent`('imaging__report', 'fk_imaging__report_signature_id', 'signature_id', 'document__signature', 'id');
CALL `_add_fk_if_absent`('imaging__report', 'fk_imaging__report_study_id', 'study_id', 'imaging__study', 'id');
CALL `_add_fk_if_absent`('imaging__report', 'fk_imaging__report_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('imaging__report_addendum', 'fk_imaging__report_addendum_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('imaging__report_addendum', 'fk_imaging__report_addendum_signature_id', 'signature_id', 'document__signature', 'id');
CALL `_add_fk_if_absent`('imaging__report_addendum', 'fk_imaging__report_addendum_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('imaging__dose_record', 'fk_imaging__dose_record_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('imaging__dose_record', 'fk_imaging__dose_record_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('imaging__dose_record', 'fk_imaging__dose_record_study_id', 'study_id', 'imaging__study', 'id');
CALL `_add_fk_if_absent`('imaging__dose_record', 'fk_imaging__dose_record_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('imaging__contrast_administration', 'fk_imaging__contrast_administration_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('imaging__contrast_administration', 'fk_imaging__contrast_administration_study_id', 'study_id', 'imaging__study', 'id');
CALL `_add_fk_if_absent`('imaging__contrast_administration', 'fk_imaging__contrast_administration_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('imaging__viewer_session', 'fk_imaging__viewer_session_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('imaging__viewer_session', 'fk_imaging__viewer_session_user_id', 'user_id', 'iam__user_account', 'id');
CALL `_add_fk_if_absent`('imaging__viewer_session', 'fk_imaging__viewer_session_grant_id', 'grant_id', 'consent__access_grant', 'id');
CALL `_add_fk_if_absent`('imaging__viewer_session', 'fk_imaging__viewer_session_study_id', 'study_id', 'imaging__study', 'id');
CALL `_add_fk_if_absent`('imaging__viewer_session', 'fk_imaging__viewer_session_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('document__document', 'fk_document__document_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('document__document', 'fk_document__document_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('document__document', 'fk_document__document_custodian_org_id', 'custodian_org_id', 'org__organization', 'id');
CALL `_add_fk_if_absent`('document__document', 'fk_document__document_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('document__document_version', 'fk_document__document_version_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('document__document_version', 'fk_document__document_version_document_id', 'document_id', 'document__document', 'id');
CALL `_add_fk_if_absent`('document__document_version', 'fk_document__document_version_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('document__document_relation', 'fk_document__document_relation_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('document__document_relation', 'fk_document__document_relation_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('document__document_tag', 'fk_document__document_tag_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('document__document_tag', 'fk_document__document_tag_document_id', 'document_id', 'document__document', 'id');
CALL `_add_fk_if_absent`('document__document_tag', 'fk_document__document_tag_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('document__signature', 'fk_document__signature_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('document__signature', 'fk_document__signature_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('document__signature_target', 'fk_document__signature_target_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('document__signature_target', 'fk_document__signature_target_signature_id', 'signature_id', 'document__signature', 'id');
CALL `_add_fk_if_absent`('document__signature_target', 'fk_document__signature_target_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('document__upload_session', 'fk_document__upload_session_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('document__upload_session', 'fk_document__upload_session_user_id', 'user_id', 'iam__user_account', 'id');
CALL `_add_fk_if_absent`('document__upload_session', 'fk_document__upload_session_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('document__retention_assignment', 'fk_document__retention_assignment_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('document__retention_assignment', 'fk_document__retention_assignment_document_id', 'document_id', 'document__document', 'id');
CALL `_add_fk_if_absent`('document__retention_assignment', 'fk_document__retention_assignment_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('document__form_template', 'fk_document__form_template_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('document__form_template', 'fk_document__form_template_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('document__form_response', 'fk_document__form_response_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('document__form_response', 'fk_document__form_response_respondent_user_id', 'respondent_user_id', 'iam__user_account', 'id');
CALL `_add_fk_if_absent`('document__form_response', 'fk_document__form_response_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('document__form_response', 'fk_document__form_response_signature_id', 'signature_id', 'document__signature', 'id');
CALL `_add_fk_if_absent`('document__form_response', 'fk_document__form_response_encounter_id', 'encounter_id', 'clinical__encounter', 'id');
CALL `_add_fk_if_absent`('document__form_response', 'fk_document__form_response_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('schedule__appointment_type', 'fk_schedule__appointment_type_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('schedule__appointment_type', 'fk_schedule__appointment_type_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('schedule__slot', 'fk_schedule__slot_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('schedule__slot', 'fk_schedule__slot_practitioner_id', 'practitioner_id', 'pro__practitioner', 'id');
CALL `_add_fk_if_absent`('schedule__slot', 'fk_schedule__slot_location_id', 'location_id', 'org__location', 'id');
CALL `_add_fk_if_absent`('schedule__slot', 'fk_schedule__slot_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('schedule__appointment', 'fk_schedule__appointment_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('schedule__appointment', 'fk_schedule__appointment_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('schedule__appointment', 'fk_schedule__appointment_location_id', 'location_id', 'org__location', 'id');
CALL `_add_fk_if_absent`('schedule__appointment', 'fk_schedule__appointment_encounter_id', 'encounter_id', 'clinical__encounter', 'id');
CALL `_add_fk_if_absent`('schedule__appointment', 'fk_schedule__appointment_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('schedule__appointment_participant', 'fk_schedule__appointment_participant_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('schedule__appointment_participant', 'fk_schedule__appointment_participant_appointment_id', 'appointment_id', 'schedule__appointment', 'id');
CALL `_add_fk_if_absent`('schedule__appointment_participant', 'fk_schedule__appointment_participant_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('schedule__waitlist_entry', 'fk_schedule__waitlist_entry_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('schedule__waitlist_entry', 'fk_schedule__waitlist_entry_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('schedule__waitlist_entry', 'fk_schedule__waitlist_entry_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('schedule__reminder', 'fk_schedule__reminder_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('schedule__reminder', 'fk_schedule__reminder_appointment_id', 'appointment_id', 'schedule__appointment', 'id');
CALL `_add_fk_if_absent`('schedule__reminder', 'fk_schedule__reminder_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('schedule__availability_exception', 'fk_schedule__availability_exception_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('schedule__availability_exception', 'fk_schedule__availability_exception_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('telecare__session', 'fk_telecare__session_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('telecare__session', 'fk_telecare__session_host_practitioner_id', 'host_practitioner_id', 'pro__practitioner', 'id');
CALL `_add_fk_if_absent`('telecare__session', 'fk_telecare__session_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('telecare__session', 'fk_telecare__session_appointment_id', 'appointment_id', 'schedule__appointment', 'id');
CALL `_add_fk_if_absent`('telecare__session', 'fk_telecare__session_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('telecare__participant', 'fk_telecare__participant_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('telecare__participant', 'fk_telecare__participant_user_id', 'user_id', 'iam__user_account', 'id');
CALL `_add_fk_if_absent`('telecare__participant', 'fk_telecare__participant_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('telecare__session_event', 'fk_telecare__session_event_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('telecare__session_event', 'fk_telecare__session_event_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('telecare__recording', 'fk_telecare__recording_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('telecare__recording', 'fk_telecare__recording_document_id', 'document_id', 'document__document', 'id');
CALL `_add_fk_if_absent`('telecare__recording', 'fk_telecare__recording_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('collab__conversation', 'fk_collab__conversation_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('collab__conversation', 'fk_collab__conversation_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('collab__conversation', 'fk_collab__conversation_encounter_id', 'encounter_id', 'clinical__encounter', 'id');
CALL `_add_fk_if_absent`('collab__conversation', 'fk_collab__conversation_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('collab__conversation_member', 'fk_collab__conversation_member_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('collab__conversation_member', 'fk_collab__conversation_member_user_id', 'user_id', 'iam__user_account', 'id');
CALL `_add_fk_if_absent`('collab__conversation_member', 'fk_collab__conversation_member_conversation_id', 'conversation_id', 'collab__conversation', 'id');
CALL `_add_fk_if_absent`('collab__conversation_member', 'fk_collab__conversation_member_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('collab__message', 'fk_collab__message_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('collab__message', 'fk_collab__message_sender_user_id', 'sender_user_id', 'iam__user_account', 'id');
CALL `_add_fk_if_absent`('collab__message', 'fk_collab__message_conversation_id', 'conversation_id', 'collab__conversation', 'id');
CALL `_add_fk_if_absent`('collab__message', 'fk_collab__message_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('collab__message_attachment', 'fk_collab__message_attachment_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('collab__message_attachment', 'fk_collab__message_attachment_document_id', 'document_id', 'document__document', 'id');
CALL `_add_fk_if_absent`('collab__message_attachment', 'fk_collab__message_attachment_message_id', 'message_id', 'collab__message', 'id');
CALL `_add_fk_if_absent`('collab__message_attachment', 'fk_collab__message_attachment_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('collab__message_receipt', 'fk_collab__message_receipt_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('collab__message_receipt', 'fk_collab__message_receipt_user_id', 'user_id', 'iam__user_account', 'id');
CALL `_add_fk_if_absent`('collab__message_receipt', 'fk_collab__message_receipt_message_id', 'message_id', 'collab__message', 'id');
CALL `_add_fk_if_absent`('collab__message_receipt', 'fk_collab__message_receipt_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('collab__task', 'fk_collab__task_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('collab__task', 'fk_collab__task_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('collab__task', 'fk_collab__task_encounter_id', 'encounter_id', 'clinical__encounter', 'id');
CALL `_add_fk_if_absent`('collab__task', 'fk_collab__task_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('collab__task_event', 'fk_collab__task_event_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('collab__task_event', 'fk_collab__task_event_task_id', 'task_id', 'collab__task', 'id');
CALL `_add_fk_if_absent`('collab__task_event', 'fk_collab__task_event_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('notify__notification', 'fk_notify__notification_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('notify__notification', 'fk_notify__notification_recipient_user_id', 'recipient_user_id', 'iam__user_account', 'id');
CALL `_add_fk_if_absent`('notify__notification', 'fk_notify__notification_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('notify__delivery', 'fk_notify__delivery_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('notify__delivery', 'fk_notify__delivery_notification_id', 'notification_id', 'notify__notification', 'id');
CALL `_add_fk_if_absent`('notify__delivery', 'fk_notify__delivery_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('notify__preference', 'fk_notify__preference_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('notify__preference', 'fk_notify__preference_user_id', 'user_id', 'iam__user_account', 'id');
CALL `_add_fk_if_absent`('notify__preference', 'fk_notify__preference_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('notify__template', 'fk_notify__template_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('notify__template', 'fk_notify__template_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('billing__payer', 'fk_billing__payer_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('billing__payer', 'fk_billing__payer_organization_id', 'organization_id', 'org__organization', 'id');
CALL `_add_fk_if_absent`('billing__payer', 'fk_billing__payer_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('billing__coverage', 'fk_billing__coverage_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('billing__coverage', 'fk_billing__coverage_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('billing__coverage', 'fk_billing__coverage_payer_id', 'payer_id', 'billing__payer', 'id');
CALL `_add_fk_if_absent`('billing__coverage', 'fk_billing__coverage_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('billing__coverage_benefit', 'fk_billing__coverage_benefit_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('billing__coverage_benefit', 'fk_billing__coverage_benefit_coverage_id', 'coverage_id', 'billing__coverage', 'id');
CALL `_add_fk_if_absent`('billing__coverage_benefit', 'fk_billing__coverage_benefit_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('billing__eligibility_check', 'fk_billing__eligibility_check_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('billing__eligibility_check', 'fk_billing__eligibility_check_raw_response_document_id', 'raw_response_document_id', 'document__document', 'id');
CALL `_add_fk_if_absent`('billing__eligibility_check', 'fk_billing__eligibility_check_coverage_id', 'coverage_id', 'billing__coverage', 'id');
CALL `_add_fk_if_absent`('billing__eligibility_check', 'fk_billing__eligibility_check_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('billing__price_schedule', 'fk_billing__price_schedule_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('billing__price_schedule', 'fk_billing__price_schedule_organization_id', 'organization_id', 'org__organization', 'id');
CALL `_add_fk_if_absent`('billing__price_schedule', 'fk_billing__price_schedule_payer_id', 'payer_id', 'billing__payer', 'id');
CALL `_add_fk_if_absent`('billing__price_schedule', 'fk_billing__price_schedule_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('billing__estimate', 'fk_billing__estimate_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('billing__estimate', 'fk_billing__estimate_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('billing__estimate', 'fk_billing__estimate_appointment_id', 'appointment_id', 'schedule__appointment', 'id');
CALL `_add_fk_if_absent`('billing__estimate', 'fk_billing__estimate_coverage_id', 'coverage_id', 'billing__coverage', 'id');
CALL `_add_fk_if_absent`('billing__estimate', 'fk_billing__estimate_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('billing__invoice', 'fk_billing__invoice_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('billing__invoice', 'fk_billing__invoice_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('billing__invoice', 'fk_billing__invoice_organization_id', 'organization_id', 'org__organization', 'id');
CALL `_add_fk_if_absent`('billing__invoice', 'fk_billing__invoice_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('billing__invoice_line', 'fk_billing__invoice_line_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('billing__invoice_line', 'fk_billing__invoice_line_practitioner_id', 'practitioner_id', 'pro__practitioner', 'id');
CALL `_add_fk_if_absent`('billing__invoice_line', 'fk_billing__invoice_line_encounter_id', 'encounter_id', 'clinical__encounter', 'id');
CALL `_add_fk_if_absent`('billing__invoice_line', 'fk_billing__invoice_line_invoice_id', 'invoice_id', 'billing__invoice', 'id');
CALL `_add_fk_if_absent`('billing__invoice_line', 'fk_billing__invoice_line_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('billing__payment', 'fk_billing__payment_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('billing__payment', 'fk_billing__payment_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('billing__payment', 'fk_billing__payment_invoice_id', 'invoice_id', 'billing__invoice', 'id');
CALL `_add_fk_if_absent`('billing__payment', 'fk_billing__payment_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('billing__refund', 'fk_billing__refund_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('billing__refund', 'fk_billing__refund_payment_id', 'payment_id', 'billing__payment', 'id');
CALL `_add_fk_if_absent`('billing__refund', 'fk_billing__refund_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('billing__claim', 'fk_billing__claim_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('billing__claim', 'fk_billing__claim_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('billing__claim', 'fk_billing__claim_provider_org_id', 'provider_org_id', 'org__organization', 'id');
CALL `_add_fk_if_absent`('billing__claim', 'fk_billing__claim_coverage_id', 'coverage_id', 'billing__coverage', 'id');
CALL `_add_fk_if_absent`('billing__claim', 'fk_billing__claim_payer_id', 'payer_id', 'billing__payer', 'id');
CALL `_add_fk_if_absent`('billing__claim', 'fk_billing__claim_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('billing__claim_item', 'fk_billing__claim_item_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('billing__claim_item', 'fk_billing__claim_item_practitioner_id', 'practitioner_id', 'pro__practitioner', 'id');
CALL `_add_fk_if_absent`('billing__claim_item', 'fk_billing__claim_item_claim_id', 'claim_id', 'billing__claim', 'id');
CALL `_add_fk_if_absent`('billing__claim_item', 'fk_billing__claim_item_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('billing__claim_response', 'fk_billing__claim_response_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('billing__claim_response', 'fk_billing__claim_response_document_id', 'document_id', 'document__document', 'id');
CALL `_add_fk_if_absent`('billing__claim_response', 'fk_billing__claim_response_claim_id', 'claim_id', 'billing__claim', 'id');
CALL `_add_fk_if_absent`('billing__claim_response', 'fk_billing__claim_response_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('billing__claim_adjudication', 'fk_billing__claim_adjudication_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('billing__claim_adjudication', 'fk_billing__claim_adjudication_claim_response_id', 'claim_response_id', 'billing__claim_response', 'id');
CALL `_add_fk_if_absent`('billing__claim_adjudication', 'fk_billing__claim_adjudication_claim_item_id', 'claim_item_id', 'billing__claim_item', 'id');
CALL `_add_fk_if_absent`('billing__claim_adjudication', 'fk_billing__claim_adjudication_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('iot__device', 'fk_iot__device_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('iot__device', 'fk_iot__device_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('iot__device', 'fk_iot__device_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('iot__device_authorization', 'fk_iot__device_authorization_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('iot__device_authorization', 'fk_iot__device_authorization_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('iot__device_authorization', 'fk_iot__device_authorization_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('iot__measurement_batch', 'fk_iot__measurement_batch_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('iot__measurement_batch', 'fk_iot__measurement_batch_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('iot__measurement_batch', 'fk_iot__measurement_batch_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('iot__measurement', 'fk_iot__measurement_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('iot__measurement', 'fk_iot__measurement_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('iot__measurement', 'fk_iot__measurement_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('wellness__patient_reported_outcome', 'fk_wellness__patient_reported_outcome_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('wellness__patient_reported_outcome', 'fk_wellness__patient_reported_outcome_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('wellness__patient_reported_outcome', 'fk_wellness__patient_reported_outcome_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('wellness__activity_summary', 'fk_wellness__activity_summary_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('wellness__activity_summary', 'fk_wellness__activity_summary_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('wellness__activity_summary', 'fk_wellness__activity_summary_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('wellness__sleep_summary', 'fk_wellness__sleep_summary_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('wellness__sleep_summary', 'fk_wellness__sleep_summary_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('wellness__sleep_summary', 'fk_wellness__sleep_summary_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('wellness__nutrition_log', 'fk_wellness__nutrition_log_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('wellness__nutrition_log', 'fk_wellness__nutrition_log_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('wellness__nutrition_log', 'fk_wellness__nutrition_log_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('genomics__genetic_test', 'fk_genomics__genetic_test_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('genomics__genetic_test', 'fk_genomics__genetic_test_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('genomics__genetic_test', 'fk_genomics__genetic_test_report_document_id', 'report_document_id', 'document__document', 'id');
CALL `_add_fk_if_absent`('genomics__genetic_test', 'fk_genomics__genetic_test_service_request_id', 'service_request_id', 'lab__service_request', 'id');
CALL `_add_fk_if_absent`('genomics__genetic_test', 'fk_genomics__genetic_test_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('genomics__variant', 'fk_genomics__variant_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('genomics__variant', 'fk_genomics__variant_genetic_test_id', 'genetic_test_id', 'genomics__genetic_test', 'id');
CALL `_add_fk_if_absent`('genomics__variant', 'fk_genomics__variant_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('genomics__disclosure_preference', 'fk_genomics__disclosure_preference_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('genomics__disclosure_preference', 'fk_genomics__disclosure_preference_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('genomics__disclosure_preference', 'fk_genomics__disclosure_preference_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('audit__audit_event', 'fk_audit__audit_event_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('audit__audit_event', 'fk_audit__audit_event_actor_user_id', 'actor_user_id', 'iam__user_account', 'id');
CALL `_add_fk_if_absent`('audit__audit_event', 'fk_audit__audit_event_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('audit__audit_event', 'fk_audit__audit_event_grant_id', 'grant_id', 'consent__access_grant', 'id');
CALL `_add_fk_if_absent`('audit__audit_event', 'fk_audit__audit_event_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('audit__audit_entity', 'fk_audit__audit_entity_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('audit__audit_entity', 'fk_audit__audit_entity_audit_event_id', 'audit_event_id', 'audit__audit_event', 'id');
CALL `_add_fk_if_absent`('audit__audit_entity', 'fk_audit__audit_entity_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('audit__audit_chain', 'fk_audit__audit_chain_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('audit__audit_chain', 'fk_audit__audit_chain_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('audit__audit_anchor', 'fk_audit__audit_anchor_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('audit__audit_anchor', 'fk_audit__audit_anchor_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('audit__data_export', 'fk_audit__data_export_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('audit__data_export', 'fk_audit__data_export_requester_user_id', 'requester_user_id', 'iam__user_account', 'id');
CALL `_add_fk_if_absent`('audit__data_export', 'fk_audit__data_export_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('audit__data_export', 'fk_audit__data_export_document_id', 'document_id', 'document__document', 'id');
CALL `_add_fk_if_absent`('audit__data_export', 'fk_audit__data_export_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('audit__data_access_review', 'fk_audit__data_access_review_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('audit__data_access_review', 'fk_audit__data_access_review_audit_event_id', 'audit_event_id', 'audit__audit_event', 'id');
CALL `_add_fk_if_absent`('audit__data_access_review', 'fk_audit__data_access_review_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('compliance__privacy_request', 'fk_compliance__privacy_request_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('compliance__privacy_request', 'fk_compliance__privacy_request_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('compliance__privacy_request', 'fk_compliance__privacy_request_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('compliance__incident', 'fk_compliance__incident_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('compliance__incident', 'fk_compliance__incident_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('compliance__incident_subject', 'fk_compliance__incident_subject_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('compliance__incident_subject', 'fk_compliance__incident_subject_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('compliance__incident_subject', 'fk_compliance__incident_subject_incident_id', 'incident_id', 'compliance__incident', 'id');
CALL `_add_fk_if_absent`('compliance__incident_subject', 'fk_compliance__incident_subject_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('compliance__legal_hold', 'fk_compliance__legal_hold_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('compliance__legal_hold', 'fk_compliance__legal_hold_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('compliance__retention_policy', 'fk_compliance__retention_policy_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('compliance__retention_policy', 'fk_compliance__retention_policy_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('compliance__disposition_event', 'fk_compliance__disposition_event_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('compliance__disposition_event', 'fk_compliance__disposition_event_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('compliance__risk_assessment', 'fk_compliance__risk_assessment_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('compliance__risk_assessment', 'fk_compliance__risk_assessment_report_document_id', 'report_document_id', 'document__document', 'id');
CALL `_add_fk_if_absent`('compliance__risk_assessment', 'fk_compliance__risk_assessment_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('compliance__control_evidence', 'fk_compliance__control_evidence_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('compliance__control_evidence', 'fk_compliance__control_evidence_document_id', 'document_id', 'document__document', 'id');
CALL `_add_fk_if_absent`('compliance__control_evidence', 'fk_compliance__control_evidence_assessment_id', 'assessment_id', 'compliance__risk_assessment', 'id');
CALL `_add_fk_if_absent`('compliance__control_evidence', 'fk_compliance__control_evidence_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('interop__source_system', 'fk_interop__source_system_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('interop__source_system', 'fk_interop__source_system_organization_id', 'organization_id', 'org__organization', 'id');
CALL `_add_fk_if_absent`('interop__source_system', 'fk_interop__source_system_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('interop__endpoint', 'fk_interop__endpoint_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('interop__endpoint', 'fk_interop__endpoint_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('interop__interface', 'fk_interop__interface_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('interop__interface', 'fk_interop__interface_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('interop__message', 'fk_interop__message_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('interop__message', 'fk_interop__message_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('interop__message', 'fk_interop__message_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('interop__message', 'fk_interop__message_interface_id', 'interface_id', 'interop__interface', 'id');
CALL `_add_fk_if_absent`('interop__message_attempt', 'fk_interop__message_attempt_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('interop__message_attempt', 'fk_interop__message_attempt_message_id', 'message_id', 'collab__message', 'id');
CALL `_add_fk_if_absent`('interop__message_attempt', 'fk_interop__message_attempt_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('interop__mapping', 'fk_interop__mapping_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('interop__mapping', 'fk_interop__mapping_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('interop__subscription', 'fk_interop__subscription_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('interop__subscription', 'fk_interop__subscription_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('interop__webhook_delivery', 'fk_interop__webhook_delivery_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('interop__webhook_delivery', 'fk_interop__webhook_delivery_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('interop__webhook_delivery', 'fk_interop__webhook_delivery_subscription_id', 'subscription_id', 'interop__subscription', 'id');
CALL `_add_fk_if_absent`('interop__fhir_resource_snapshot', 'fk_interop__fhir_resource_snapshot_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('interop__fhir_resource_snapshot', 'fk_interop__fhir_resource_snapshot_patient_id', 'patient_id', 'patient__patient', 'id');
CALL `_add_fk_if_absent`('interop__fhir_resource_snapshot', 'fk_interop__fhir_resource_snapshot_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('interop__provenance', 'fk_interop__provenance_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('interop__provenance', 'fk_interop__provenance_signature_id', 'signature_id', 'document__signature', 'id');
CALL `_add_fk_if_absent`('interop__provenance', 'fk_interop__provenance_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('ref__code_system', 'fk_ref__code_system_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('ref__code_system', 'fk_ref__code_system_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('ref__concept', 'fk_ref__concept_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('ref__concept', 'fk_ref__concept_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('ref__concept', 'fk_ref__concept_code_system_id', 'code_system_id', 'ref__code_system', 'id');
CALL `_add_fk_if_absent`('ref__value_set', 'fk_ref__value_set_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('ref__value_set', 'fk_ref__value_set_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('ref__value_set_member', 'fk_ref__value_set_member_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('ref__value_set_member', 'fk_ref__value_set_member_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('ref__value_set_member', 'fk_ref__value_set_member_value_set_id', 'value_set_id', 'ref__value_set', 'id');
CALL `_add_fk_if_absent`('ref__value_set_member', 'fk_ref__value_set_member_concept_id', 'concept_id', 'ref__concept', 'id');
CALL `_add_fk_if_absent`('ref__unit', 'fk_ref__unit_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('ref__unit', 'fk_ref__unit_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('ref__drug_interaction', 'fk_ref__drug_interaction_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('ref__drug_interaction', 'fk_ref__drug_interaction_source_system_id', 'source_system_id', 'interop__source_system', 'id');
CALL `_add_fk_if_absent`('ref__clinical_rule', 'fk_ref__clinical_rule_tenant_id', 'tenant_id', 'core__tenant', 'id');
CALL `_add_fk_if_absent`('ref__clinical_rule', 'fk_ref__clinical_rule_source_system_id', 'source_system_id', 'interop__source_system', 'id');

DROP PROCEDURE IF EXISTS `_add_fk_if_absent`;
SET FOREIGN_KEY_CHECKS = 1;

INSERT IGNORE INTO `meta__schema_migration`
  (`version`, `description`, `checksum_sha256`)
VALUES
  ('1.0.0', 'Initial patient-oriented digital health platform schema', 'af0b4f8e754bbe854c87782441a474304320ed1dd291cbafbedced2c5706eae2');

SET SQL_MODE = @OLD_SQL_MODE;

SELECT DATABASE() AS database_name,
       COUNT(*) AS table_count
  FROM information_schema.TABLES
 WHERE TABLE_SCHEMA = DATABASE();

SELECT COUNT(*) AS foreign_key_count
  FROM information_schema.REFERENTIAL_CONSTRAINTS
 WHERE CONSTRAINT_SCHEMA = DATABASE();
