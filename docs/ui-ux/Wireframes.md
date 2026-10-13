# Wireframes

## Portail public

```text
┌──────────────────────────────────────────────────────────────┐
│ Marque                         Sécurité   Aide   Connexion    │
├──────────────────────────────────────────────────────────────┤
│ Votre santé. Vos données. Vos décisions.      [Connexion]   │
│ Explication du contrôle patient                [Créer compte]│
│                                                              │
│ [Dossier centralisé] [Accès contrôlés] [Traçabilité]         │
└──────────────────────────────────────────────────────────────┘
```

## Dashboard patient

```text
┌──────── Navigation ────────┬─────────────────────────────────┐
│ Vue d’ensemble             │ Bonjour, Patient       [QR]    │
│ Mon dossier                │ [Prochain RDV] [Résultat]      │
│ Résultats                  │ [Prescription] [Consentements] │
│ Prescriptions              │                                 │
│ Rendez-vous                │ Activité récente               │
│ Documents                  │ ○ Profil créé                  │
│ Consentements              │ ○ Accès autorisé/refusé        │
│ Historique                 │                                 │
└────────────────────────────┴─────────────────────────────────┘
```

## Consentement et QR

```text
┌──────────────────────────────────────────────────────────────┐
│ Partager mon dossier                          [Créer un QR]   │
├──────────────────────┬───────────────────────────────────────┤
│ QR signé             │ Demandes en attente                  │
│ expire dans 04:32    │ Dr X · Clinique Y · 30 min           │
│ usage unique         │ [Refuser] [Autoriser]                 │
├──────────────────────┴───────────────────────────────────────┤
│ Autorisations actives │ Historique d’accès                   │
└──────────────────────────────────────────────────────────────┘
```

## Professionnel

```text
┌──────────────────────────────────────────────────────────────┐
│ Accès patient sécurisé                                      │
│ ① Scanner/coller  →  ② Demande  →  ③ Accord patient        │
├──────────────────────────────┬───────────────────────────────┤
│ Scanner / jeton              │ Consulter avec autorisation  │
│ [zone de lecture]            │ [identifiant patient]        │
│ Durée [30 min] [Demander]    │ [Ouvrir le profil]           │
└──────────────────────────────┴───────────────────────────────┘
```

## MAUI patient

```text
┌───────────────────────────┐
│ Bonjour                   │
│ Votre espace santé        │
│ [Connexion sécurisée]     │
│                           │
│ [ QR temporaire ]         │
│ [Créer / régénérer]       │
│                           │
│ Accueil  Dossier  QR  +   │
└───────────────────────────┘
```
