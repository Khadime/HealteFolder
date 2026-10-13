# Plan de développement — HealthPlatform

## Analyse de la source
Source officielle : Dossier_conception_plateforme_sante_orientee_patient.md, version 1.0. Les dix chapitres et annexes ont été examinés. Les choix explicites de la demande remplacent les options du dossier : MySQL (pas PostgreSQL), Blazor, MAUI, Keycloak, RabbitMQ et Azure. Le SQL existant de 220 tables n'est pas exécuté.

Le dossier définit une cible pluriannuelle. Le premier incrément est un MVP des phases 1–3 : identité fédérée, profil, répertoire, consentement temporaire, QR et journal. Les phases 4–8 restent des incréments distincts, avec critères de sortie. Aucun écran vide ne sera décrit comme une fonction clinique livrée.

## Décisions techniques
- Monolithe modulaire, API et workers séparés, dépendances vers le Domain et SharedKernel.
- .NET 10; EF Core 9 et Pomelo 9 compatibles entre eux tant que Pomelo 10 stable officiel est indisponible.
- Visual Studio 2026 (18+) pour net10.0; SDK en ligne de commande utilisable indépendamment.
- MySQL : UUID char(36), dates UTC datetime(6), JSON uniquement hors attributs décisionnels; index tenant-first et FK composites.
- Tenant et sujet issus du JWT validé, jamais d'un en-tête fourni librement par le client.
- QR signé asymétriquement, nonce aléatoire, expiration et consommation atomique; décision du patient obligatoire; licence et affiliation revérifiées à chaque accès.
- Audit de sécurité transactionnel avant réponse sensible; refus par défaut si identité/politique inconnue.
- Données synthétiques uniquement pour le développement; absence de bris de glace implicite.

## Backlog ordonné
| Epic | Feature | User story / acceptation | Tâches techniques | Dépendances |
|---|---|---|---|---|
| E01 Fondations | Solution et architecture | Développeur : compiler et tester les couches séparément | 11 projets src, 3 tests, props partagés, CI, tests de dépendances | SDK 10 |
| E02 Identité | OIDC/MFA | Patient/pro : connexion forte; admin sans accès clinique automatique | Keycloak, claims tenant/role/acr/auth_time, JWT, cookies BFF, PKCE, logout | E01 |
| E03 Répertoire | Patient/pro/organisation | Patient : profil personnel; pro : licence et affiliation actives | Agrégats, configurations EF, repository, DTO, validation, migrations, seed synthétique | E02 |
| E04 Dossier | Profil et historique | Patient : consulter son profil et la provenance; accès tiers refusé sans grant | Queries CQRS, audit, lecture bornée; documents binaires en quarantaine dans incrément suivant | E03 |
| E05 QR | Émission et scan | US-01 : code sans PHI, expirant et usage unique; scan concurrent unique | ECDSA, kid, nonce hash, QR + barcode, repository, transaction, tests falsification/rejeu | E03 |
| E06 Consentement | Demande, décision, révocation | Patient : accepter/refuser/réduire; US-03 : journal; révocation immédiate | Machine d'état, limites scope/durée, preuves, contrôle patient, concurrence optimiste, outbox | E05 |
| E07 Rendez-vous | Agenda et réservation | Réserver sans double occupation; annuler avec historique | Slots, verrouillage, fuseaux, rappels, calendrier, tests de concurrence | E03,E06 |
| E08 Prescription | Brouillon et signature | US-05 : licence active, validation et version signée immuable | Catalogue, lignes, posologie, CDS validé, signature externe, transmission idempotente | E04,E06 |
| E09 Laboratoire | Résultats et correction | US-06/07/09 : quarantaine OCR, validation humaine, accusé critique | Observation/DiagnosticReport, UCUM/LOINC, antivirus, provenance, escalade | E04,E08 |
| E10 Imagerie | Études et visualiseur | Accès DICOMweb borné et audit des téléchargements | PACS, UIDs, jetons courts, rapports signés, gestion des doses | E06,E09 |
| E11 Facturation | Facture et paiement | Finalité paiement distincte; aucun stockage PAN | Decimal(19,4), monnaie, idempotence PSP, rapprochement, remboursement | E07,E08 |
| E12 Mobile | Parcours MAUI | Patient : QR/décisions; pro : scan et dossier autorisé | MVVM, PKCE navigateur système, SecureStorage, biométrie locale, caméra, deep links, push génériques | E02,E06 |
| E13 Interop | FHIR R4 | Import validé, provenance préservée, aucune recherche patient ouverte | DTO/SDK FHIR, adaptateurs, CapabilityStatement, validation profils, quarantaine, tests contrats | E04,E09 |
| E14 Exploitation | Azure et résilience | Opérateur : restore/test/publish reproductibles | Docker, Helm, Terraform, Key Vault, MySQL privé, OpenTelemetry, sauvegardes et restauration | E01–E13 |
| E15 Extensions | Télésoin, messages, IoT, conformité | Parcours spécialisés contrôlés par mêmes politiques | WebRTC, messagerie chiffrée, appareils, conservation, incidents et délégation | E06,E14 |

## Ordre de génération
1. Solution Visual Studio et références. 2. Domain et invariants. 3. Persistence MySQL et migration MVP. 4. Infrastructure cryptographie/identité/événements. 5. API CQRS. 6. Blazor. 7. MAUI. 8. Workers. 9. Docker. 10. DevOps. 11. Tests et rapport d'exécution.
Chaque couche reçoit ses tests pertinents pendant l'implémentation; la dernière étape exécute l'ensemble.

## Critères de validation
Tests de portée, expiration, rejet, révocation, tenant, ownership, falsification et concurrence; intégration MySQL réelle isolée; HTTP non authentifié 401 et accès indu 403/404; tests architecture; couverture cible 80 % mesurée, jamais présumée. Compilation serveur et compilation MAUI distinguées selon workloads disponibles.

## Gates avant production
Les critères du §10.13 du dossier restent des exigences produit : profils FHIR et politiques juridictionnelles validés, pentest, restauration RPO/RTO, charge 20k req/s, accessibilité et pilote clinique. Ils ne sont pas démontrés par la simple compilation. Secrets externes, région Azure et intégrations partenaires sont fournis au déploiement.
