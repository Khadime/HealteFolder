# Installation et déploiement

1. Terminal Windows PowerShell administrateur : exécuter install-prerequisites.ps1. L'installation globale ne peut pas être réalisée depuis une session sans droits administrateur. Le script exige ces droits et s'arrête sur échec.
2. Redémarrer si Windows ou Docker l'exige. Ouvrir un nouveau PowerShell 7 non administrateur.
3. Vérifier dotnet --version (10.x), dotnet workload list et docker info. Visual Studio 2026 doit afficher ASP.NET et MAUI dans son installateur. .vsconfig décrit les workloads.
4. Garder MySQL local sur 3306. setup.ps1 crée les secrets de développement sans les afficher, restaure, construit, migre et lance les applications. -Test active les tests; -Mobile compile Android.
5. Configurer Keycloak (docs/Identity.md), SMTP, tenant et rôles; créer les profils depuis le portail. Le script seed est synthétique et n'accorde aucun droit clinique.

Services locaux : API 5100, Blazor HTTPS 7101, Keycloak 8080, Redis 6379, RabbitMQ 5672/15672. Les ports Docker sont liés au loopback. Le profil Docker container-db ajoute MySQL sur 3307 pour éviter de remplacer MySQL existant. Le .env ne doit jamais être commité.

Les PID et journaux de lancement sont dans work. Les applications ne sont pas installées comme services Windows. Ne pas relancer setup avec lancement si les mêmes processus utilisent encore leurs ports. L'API et le web peuvent être lancés séparément avec dotnet run après configuration des variables.

Chaque exécutable serveur possède son Dockerfile. Le Compose fourni lance les dépendances; il ne déploie pas à lui seul les applications. Le chart Helm déploie l'API avec probes et références de secrets. Il nécessite une image publiée, une base, un IAM, des secrets et un routage TLS existants. Terraform fournit le réseau et MySQL Azure privés; AKS, WAF, Key Vault, SIEM et reprise ne sont pas encore provisionnés par ce module.

Le workflow GitHub effectue restore/build/test/publish du serveur. Aucun déploiement Azure n'est lancé automatiquement. Les assets IaC doivent être validés et complétés avant production. Aucun coût cloud n'a été engagé.
