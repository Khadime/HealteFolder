# Bibliothèque de composants

| Composant | Responsabilité | États principaux |
|---|---|---|
| `MedicalCard` | Surface générique avec titre, icône et action | normal, accentué, désactivé |
| `PatientCard` | Identité patient et contexte administratif | complet, données manquantes |
| `PractitionerCard` | Professionnel, organisation et vérification | vérifié, non vérifié |
| `HealthMetricCard` | Mesure, unité, tendance et date | normal, attention, indisponible |
| `AuditCard` | Événement d’accès lisible | autorisé, refusé, technique |
| `PrescriptionCard` | Médicament et statut | active, terminée, absente |
| `AppointmentCard` | Date, professionnel et canal | confirmé, à confirmer, terminé |
| `NotificationCard` | Message actionnable | non lu, lu, critique |
| `ResultCard` | Résultat clinique avec provenance | nouveau, consulté, indisponible |
| `MedicalDataGrid` | Tableau responsive accessible | chargement, vide, erreur |
| `SecureDialog` | Confirmation d’une action sensible | information, confirmation |
| `ConsentDialog` | Portée et durée d’un consentement | accepter, refuser, expiré |
| `QRCodePanel` | QR signé, échéance et régénération | actif, expiré, utilisé |
| `StatusBadge` | Statut textuel et pictogramme | succès, information, attention, erreur, neutre |
| `ClinicalTimeline` | Événements médicaux chronologiques | renseigné, vide |
| `HealthChart` | Série temporelle accessible | renseigné, vide, données tabulaires |

Les composants ne décident pas des autorisations métier. Ils rendent un état déjà autorisé par l’API et n’exposent pas de données sensibles dans leurs attributs HTML ou journaux.
