# Roadmap et statut

Le backlog détaillé, ses stories et dépendances se trouvent dans DevelopmentPlan.md. Les numéros de phases suivent la demande utilisateur.

| Phase | Statut et prochain incrément |
|---|---|
| 1 Fondations | Couches et JWT présents; onboarding des professionnels, administration IAM et recette Keycloak à compléter |
| 2 Dossier | Profil administratif disponible; dossier clinique, documents sécurisés et historique de versions à implémenter |
| 3 Consentement | QR/demande/décision/révocation pour Profile; consentements granulaires, preuve versionnée, audit WORM, pagination et rotation de clés à compléter |
| 4 Rendez-vous | À développer : slots, concurrence, agenda, annulations, rappels |
| 5 Prescriptions | À développer : catalogue, posologie, validations cliniques, signatures et transmission |
| 6 Laboratoire | À développer : FHIR, LOINC/UCUM, provenance, correction, OCR supervisé et résultats critiques |
| 7 Imagerie | À développer : PACS/DICOMweb, rapports, sessions bornées |
| 8 Facturation | À développer : montants/monnaies, assurances, PSP idempotent sans PAN |

MAUI : premiers parcours Android codés, build et recette appareil à terminer. Biométrie, push et iOS restent au backlog. Workers OCR/FHIR/import/audit/cleanup restent à implémenter; seul l'outbox dispatcher est actif. Hangfire utilise actuellement un stockage mémoire et n'est pas une file durable de production.

Avant pilote : finaliser le MVP clinique, recettes d'identité, vérification professionnelle, antivirus documentaire, audit indépendant, chiffrement, sauvegarde/restauration et tests BOLA. Avant échelle nationale : backplane, partitions, tests de charge, SLO, régions et gouvernance. Aucun de ces jalons n'est déduit du seul succès de compilation.
