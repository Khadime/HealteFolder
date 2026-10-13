# Validation UI/UX

## Vérifications automatisées

- Blazor `Release` : compilation sans avertissement ni erreur.
- Solution serveur `Release` : compilation exécutée après les changements UI.
- MAUI Android : compilation de conception exécutée avec le SDK Android local.
- Les composants utilisent les thèmes et les jetons centralisés; aucune couleur clinique ne décide seule d’un état.

## Accessibilité vérifiée dans le code

- lien d’évitement vers le contenu principal;
- régions de navigation nommées;
- focus clavier visible de 3 px;
- cibles tactiles principales d’au moins 44 px;
- badges composés d’un libellé, d’une icône et d’une couleur;
- états vides explicites et skeleton de chargement;
- réduction des mouvements avec `prefers-reduced-motion`;
- étiquettes accessibles pour le QR, les graphiques et les actions d’icône;
- structure responsive à 599 px, 959 px et 1199 px.

## Vérification manuelle avant production

La revue finale doit exécuter axe ou Accessibility Insights sur chaque route avec les thèmes clair et sombre, à 200 % de zoom et au clavier seul. Les parcours Keycloak doivent aussi être testés séparément, car leur HTML et leur thème sont servis par le fournisseur d’identité.

Les essais sur appareils physiques Android et iOS doivent couvrir TalkBack/VoiceOver, les tailles de police système, l’encoche, la rotation, la caméra et les permissions refusées. La compilation iOS nécessite un hôte macOS associé.
