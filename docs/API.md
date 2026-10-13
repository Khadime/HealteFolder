# API MVP

Préfixe /api/v1. JWT Bearer audience health-api, claim tenant_id et acr=2. Les commandes sensibles demandent un MFA récent; les handlers vérifient les droits objet. OpenAPI : /openapi/v1.json en Development. Les réponses contiennent un en-tête X-Correlation-Id et Cache-Control: no-store.

| Méthode | Route | Usage |
|---|---|---|
| GET | /me | Identité et référence de profil personnel |
| POST | /patients | Créer son profil (GivenName, FamilyName, BirthDate) |
| POST | /practitioners | Soumettre son profil professionnel et son organisation; statut non vérifié |
| GET | /patients/{id} | Lire son profil ou un profil autorisé |
| POST | /patients/{id}/access-codes | Émettre QR/barcode; TtlSeconds 30–600, Scope=1 |
| POST | /access-codes/scan | Pro vérifié; QrPayload, Scope=1, DurationMinutes 1–120 |
| GET | /patients/{id}/access-requests | Patient propriétaire; demandes récentes |
| POST | /access-requests/{id}/decisions | Patient; Accept, Scope=1, DurationMinutes |
| GET | /patients/{id}/access-grants | Patient propriétaire; autorisations |
| POST | /consents/{id}/revoke | Révoquer le grant indiqué; id est un identifiant AccessGrant dans ce MVP |
| GET | /patients/{id}/audit-events | Journal du patient |

SignalR : /hubs/access, événement AccessChanged sans contenu clinique. /health/live vérifie le processus; /health/ready vérifie MySQL. Liveness publique; readiness sans détails de connexion.

Erreurs : 400 validation, 401 absence de JWT, 403 autorisation refusée, 409 conflit/rejeu/expiration, 429 quota. La réponse ne divulgue pas de détail clinique. Les listes sont bornées à 200 et n'ont pas encore de curseur. Le catalogue intégral du document de conception reste la cible; seuls les endpoints ci-dessus sont implémentés. FHIR n'est pas exposé dans cet incrément.
