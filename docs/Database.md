# Base de données

MySQL local, base `HealthPlatform`. Connexion de développement dans l'API : `server=localhost;port=3306;database=HealthPlatform;user=root;password=`. Configurer la connexion par variable `ConnectionStrings__DefaultConnection` pour chaque environnement. Azure doit utiliser TLS et une identité MySQL dédiée à privilèges minimaux.

La migration `InitialTrustMvp` est dans Persistence/Migrations; la version SQL idempotente est dans database/migrations. Elle crée identity_account, patient_profile, organization, practitioner, consent_qr_challenge, consent_access_request, consent_access_grant, audit_event et outbox_message, plus l'historique EF. Le catalogue SQL historique de 220 tables n'est pas exécuté.

UUID : char(36); dates : datetime(6) en UTC; attributs décisionnels relationnels. Les futures extensions JSON utiliseront le type MySQL JSON; les montants utiliseront DECIMAL(19,4), les textes TEXT/LONGTEXT. Aucun JSONB ou array PostgreSQL.

Les clés incluent le tenant, les FK utilisent RESTRICT. Version assure la concurrence optimiste. Les changements de consentement et leur audit/outbox sont atomiques via SaveChanges. Les lectures sont limitées à 200 éléments; une vraie pagination par curseur reste à implémenter.

```powershell
dotnet ef database update --project src/HealthPlatform.Persistence
dotnet ef migrations script --idempotent --project src/HealthPlatform.Persistence --output database/migrations/latest.sql
```

`database/seed/synthetic.sql` est volontairement opt-in, ne crée aucun patient ni mot de passe et laisse le professionnel non vérifié. L'opérateur doit rattacher un sujet OIDC vérifié. `database/scripts/production-grants.sql` illustre les privilèges de l'API; le compte de migration et le compte worker doivent être séparés.

L'audit est append-only dans SaveChangesAsync et dans les privilèges proposés. Un root MySQL conserve techniquement la capacité de le modifier : ce mécanisme n'est pas un journal WORM ni un ancrage externe. Ces contrôles sont requis avant production.
