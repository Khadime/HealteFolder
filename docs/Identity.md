# Identité et création des comptes

## Parcours livré

Le portail crée les comptes au moyen du client de service confidentiel `health-registration`. L’utilisateur choisit explicitement le profil **Patient** ou **Professionnel de santé**. Le rôle et le `tenant_id` sont appliqués côté serveur; ils ne peuvent pas être fournis ou modifiés par le navigateur.

1. L’utilisateur ouvre `/register`, choisit son type de compte et fournit ses informations.
2. Le mot de passe est envoyé directement à Keycloak par le serveur Blazor et n’est jamais stocké dans MySQL.
3. Aucun courriel de validation et aucun code SMS ne sont envoyés. `verifyEmail` et l’action `VERIFY_EMAIL` sont désactivés. L’adresse courriel reste l’identifiant de connexion.
4. Après la première connexion, `/onboarding` crée le profil métier dans MySQL.
5. Un patient peut ensuite utiliser son dossier. Un professionnel reste `Verified=false` jusqu’à la vérification administrative de son permis et de son organisation; il ne peut pas demander un accès patient avant cette validation.

Le mot de passe exige au moins 12 caractères, une majuscule, une minuscule et un chiffre. Le parcours de connexion impose toujours TOTP afin de conserver l’assurance MFA `acr=2`. Ce TOTP utilise une application d’authentification et ne constitue pas une validation du courriel ou du téléphone.

## Configuration locale

`setup.cmd` démarre Keycloak, attend son endpoint OpenID Connect, puis exécute `configure-keycloak.ps1`. Ce script est idempotent : il configure le client d’inscription, ses droits limités de gestion des utilisateurs, les secrets, le profil utilisateur et les rôles explicites.

```powershell
Set-Location 'D:\Apps\HealteFolder'
.\stop.cmd
.\setup.cmd -LocalMySqlWithoutTls
```

Ne pas utiliser `-SkipDocker` pour les parcours de connexion locaux. Si Keycloak est arrêté, `/login` redirige vers une page d’indisponibilité claire au lieu d’afficher une exception OIDC.

## Contraintes de sécurité

- L’inscription publique native de Keycloak est désactivée; seul le formulaire du portail peut choisir un rôle.
- Un compte ne reçoit jamais les rôles Patient et Professionnel simultanément par défaut.
- Le client `health-registration` possède uniquement `manage-users`, `query-users` et `view-users`.
- Le secret d’inscription reste dans `.env` et est injecté au processus Blazor; il n’est jamais livré au navigateur.
- Les cookies sont `HttpOnly`, `Secure` et `SameSite=Lax`; le flux Web utilise Authorization Code + PKCE.
- Le client mobile reste public et utilise PKCE, sans secret embarqué.
- Les administrateurs ne reçoivent aucun accès clinique implicite.
