# Maquettes fonctionnelles

## Écrans livrés dans le MVP

### Accueil

Une vue publique présente la promesse de contrôle patient et les garanties de sécurité. Après authentification, elle devient un tableau de bord utile sans inventer de données : les modules non alimentés indiquent clairement leur indisponibilité.

### Mon dossier

L’en-tête patient affiche l’identité déclarée et sa provenance. Un rail de sections prépare le dossier électronique. Seul le résumé administratif est actif dans le MVP; les sections cliniques affichent un état vide explicite.

### Accès et consentements

Le QR est traité comme un secret temporaire : échéance visible, mention « usage unique », détails techniques repliés. Les demandes mettent le professionnel, l’organisation, la portée et la durée avant les actions Accepter/Refuser. L’historique est lisible sur mobile.

### Espace professionnel

Le parcours en trois étapes réduit les erreurs : acquisition du code, attente du consentement, lecture autorisée. Une alerte rappelle que chaque tentative est auditée.

### Mobile

La page principale adopte une hiérarchie Material : salutation, état de connexion, carte QR, actions larges et navigation inférieure. Le mode Debug utilise exclusivement les redirections ADB locales; la version Release reste HTTPS.

## Écrans planifiés

Rendez-vous, prescriptions, laboratoire, imagerie, documents, téléconsultation, messagerie et facturation utilisent les mêmes gabarits mais restent en état vide tant que leurs domaines et API ne sont pas implémentés.

## Catalogue des écrans

| Profil | Écran | Gabarit visuel | État du MVP |
|---|---|---|---|
| Public | Connexion, inscription, récupération | Carte d’identité numérique centrée, explication MFA et lien d’aide | Délégué à Keycloak |
| Patient | Tableau de bord | KPI, activité, contrôle des accès et action QR prioritaire | Livré |
| Patient | Mon dossier | En-tête patient, rail EHR et résumé administratif | Livré |
| Patient | Résultats | Filtres, cartes de résultats et graphique de tendance | État vide prêt |
| Patient | Prescriptions | Traitements actifs, posologie, prescripteur et statut | État vide prêt |
| Patient | Rendez-vous | Prochain rendez-vous, calendrier et historique | État vide prêt |
| Patient | Documents | Catégories, provenance, date et téléchargement protégé | État vide prêt |
| Patient | Consentements et QR | QR temporaire, demandes, autorisations et historique | Livré |
| Professionnel | Tableau de bord | Patients du jour, demandes, alertes et agenda | Gabarit planifié |
| Professionnel | Accès patient | Parcours scanner, demande et consultation autorisée | Livré |
| Professionnel | Prescription et résultat | Formulaire clinique avec confirmation sensible | Gabarit planifié |
| Professionnel | Agenda et téléconsultation | Calendrier, file d’attente et contexte patient | Gabarit planifié |
| Administration | Utilisateurs et rôles | Grille filtrable, statuts et actions auditables | Gabarit planifié |
| Administration | Audit et configuration | Recherche temporelle, détails immuables et paramètres | Gabarit planifié |

Les écrans marqués « état vide prêt » possèdent leur route, leur navigation et leurs états accessibles, sans simuler de données médicales. Les écrans planifiés seront activés au rythme des phases métier afin de ne pas présenter une fonction non sécurisée comme disponible.
