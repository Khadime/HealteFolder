# Architecture

Monolithe modulaire avec dépendances orientées vers le domaine. SharedKernel contient les contrats de base; Domain porte les invariants et ne dépend pas d'EF/ASP.NET. Application contient CQRS, validators et ports. Persistence implémente les repositories et Infrastructure la cryptographie. API compose les adaptateurs. Blazor et MAUI partagent seulement les contrats de transport. Gateway et Workers sont des processus séparés.

Le locataire est obtenu du JWT validé, jamais d'un en-tête libre. Les filtres EF et clés composites `(TenantId, Id)` constituent deux contrôles complémentaires. Le consentement ne se résume pas à la présence d'un rôle JWT.

Un scan valide consomme le QR et crée la demande, l'audit et l'outbox dans la transaction SaveChanges. La concurrence optimiste et l'index unique du challenge empêchent deux demandes réussies pour un code. Une décision crée un grant borné; toute nouvelle lecture vérifie la licence, l'organisation et le grant en base. Aucun cache de consentement ne retarde la révocation.

Les notifications sont au moins une fois. Le client relit l'état en base après un avis SignalR; un avis n'est jamais une autorisation. Le worker est configuré pour un tenant, avec plusieurs instances à planifier explicitement. La topologie SignalR/RabbitMQ actuelle doit être adaptée et testée avant une API multi-instance (backplane et distribution à toutes les instances).

La granularité du MVP est le profil administratif complet; filtrage clinique par champ, politiques juridictionnelles, délégations et accès d'urgence ne sont pas implémentés. Les autres domaines du dossier restent au backlog plutôt que de générer des agrégats vides et 220 tables inutilisées.

## Versions

.NET 10 pour les applications; EF Core 9.0.20 + Pomelo 9.0.0 pour MySQL. Les deux versions EF/Pomelo doivent rester compatibles. Visual Studio 2026 18+ est nécessaire au ciblage officiel .NET 10. SDK global et SDK local sont deux installations indépendantes, y compris leurs workloads.
