# Design System

## Jetons

- Espacement : 4, 8, 12, 16, 24, 32, 48, 64 px.
- Rayon : 8 px pour contrôles, 14 px pour cartes, 20 px pour panneaux de premier plan.
- Ombre : faible et diffuse; les bordures restent visibles sans ombre.
- Largeur de lecture : 72 caractères pour les textes longs.
- Focus : contour primaire de 3 px avec décalage de 2 px.

## Grille et responsive

- Mobile : `< 600 px`, navigation inférieure, une colonne, actions pleine largeur.
- Tablette : `600–959 px`, deux colonnes lorsque la lecture reste claire.
- Bureau : `>= 960 px`, rail latéral de 264 px et contenu limité à 1440 px.
- Les tableaux basculent en cartes ou deviennent horizontalement défilables sous 720 px.

## Élévation de l’information

1. Identité du patient et alertes actives.
2. Prochaine action utile.
3. Résultats et événements récents.
4. Historique et détails techniques.

## États obligatoires

Chaque vue de données possède : chargement, vide, erreur, succès et absence d’autorisation. Les skeletons conservent les dimensions finales. Les erreurs proposent une action corrective lorsque celle-ci existe.

## Thèmes MudBlazor

Le thème est centralisé dans `HealthTheme.cs`. Light et Dark partagent les mêmes rôles sémantiques. Le mode suit initialement le système puis peut être modifié par l’utilisateur. Le choix est mémorisé localement.

## Accessibilité

- Contraste WCAG 2.1 AA pour texte et composants.
- Cible tactile minimale de 44 × 44 px.
- Ordre de tabulation identique à l’ordre visuel.
- Lien d’évitement vers le contenu principal.
- Titres hiérarchiques uniques et régions nommées.
- États transmis par texte et icône, jamais par couleur seule.
- Dates présentées localement avec une forme explicite.
