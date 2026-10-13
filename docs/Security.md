# Sécurité du MVP

Contrôles présents : validation JWT issuer/audience/signature/expiration, tenant UUID obligatoire, rôle patient/professionnel, assurance acr=2, auth_time de moins de cinq minutes pour QR/décision/révocation, contrôle de propriété, licence et organisation actives, refus par défaut. Les administrateurs n'ont pas de passe-droit clinique.

Le QR contient une version, un kid, un challenge aléatoire, une expiration, un nonce 256 bits et une signature ECDSA. Aucun nom ou identifiant patient n'est encodé. Seule l'empreinte du nonce est stockée. La clé privée se trouve dans .secrets en développement et doit être montée depuis un coffre en production. Le service actuel charge une seule clé; la rotation multi-clés reste à implémenter.

Le realm de développement force password + OTP. Son mapper acr=2 n'est acceptable que tant que ce parcours est obligatoire. Les comptes de service et la fédération ne doivent pas recevoir ce mapper sans preuve MFA correspondante. Appliquer le profil utilisateur qui réserve tenant_id à l'administrateur. Le realm et les parcours doivent être testés sur Keycloak avant publication.

Le web utilise un cookie HttpOnly/Secure, PKCE et un ticket OIDC. SaveTokens conserve le jeton dans le ticket d'authentification chiffré par Data Protection; sans ITicketStore, ce ticket est transporté dans le cookie. Aucun localStorage. Un ticket store distribué et une gestion complète des sessions sont à ajouter avant montée en charge.

Le mobile utilise le navigateur système, PKCE S256, la validation state et SecureStorage. Les origines example.invalid doivent être remplacées par des origines HTTPS contrôlées. Le projet Android n'a pas encore reçu de recette sur appareil.

Limites : contrôle d'authentification Keycloak non exécuté ici, absence de WebAuthn/passkeys, chiffrement applicatif des données cliniques non livré, audit sans WORM/chaînage externe, audit des rejets HTTP amont incomplet, rate limiting par instance, absence de DPoP. Ne pas charger de véritables données de santé avant la levée de ces limites et les validations prévues au dossier.

Les tests de sécurité fournis ne constituent ni un pentest ni une certification. Les politiques cliniques et juridictionnelles sont des exigences à implémenter et valider, pas des conclusions juridiques de ce livrable.
