# VPC Digital Ocean avec Terraform
🚧 **Ce projet est en cours de développement.**

## Description
Ce projet utilise **Terraform** pour déployer une infrastructure sur **DigitalOcean**, comprenant :
- Un **VPC** (Virtual Private Cloud).
- Un **pare-feu** (firewall) avec des règles d'accès personnalisées.
- Un **équilibreur de charge** (load balancer) avec une vérification de santé.
- Deux **droplets** (machines virtuelles).

Un script bash est inclus pour automatiser la conversion d'un fichier `.env` en variables Terraform, simplifiant la gestion des secrets et des configurations.

## Prérequis

- **Terraform** installé (>= 1.0.0).
- Un compte **DigitalOcean** avec un token API.
- Un fichier `.env` contenant vos variables nécessaires.
- Accès à un terminal bash.

## Structure du projet

```
.
├── conf/
│   └── .env                # Fichier de configuration des variables
├── env_file_to_tf_var.sh   # Script Bash pour convertir .env en variables Terraform
├── main.tf                 # Fichier Terraform principal
├── README.md               # Documentation du projet
```

## Configuration

Créez un répertoire `conf/` et un fichier `.env` a l'interieur avec les informations suivantes :

```
do_token=<VOTRE_TOKEN_DIGITALOCEAN>
```

## Utilisation

### 1. Initialisation

Lancez le script bash pour gérer automatiquement les variables :
```bash
./env_file_to_tf_var.sh
```

### 2. Actions Terraform

Le script gère automatiquement l'action à effectuer selon les besoins. Les actions disponibles sont :
- **init** : Initialiser le répertoire de travail Terraform.
- **plan** : Afficher le plan de déploiement.
- **apply** : Appliquer les changements et déployer l'infrastructure.

Envoyez l'`action` au script `env_file_to_tf_var.sh` pour choisir l'action souhaitée.
Par défaut, elle est configurée sur `plan`.

Exemple pour appliquer les changements :
```bash
./env_file_to_tf_var.sh action
```

### 3. Détruire l'infrastructure

Pour détruire l'infrastructure :
```bash
terraform destroy
```

## Détails de l'infrastructure

### VPC
- **Nom** : `terraform-vpc`
- **Région** : `nyc1`
- **Plage IP** : `10.10.0.0/16`

### Firewall
- **Règles entrantes** :
  - Port 80 et 443 (HTTP/HTTPS) ouverts pour tout le monde.
  - Port 3306 (MySQL) ouvert uniquement pour les adresses internes du VPC.
- **Règles sortantes** :
  - Tout le trafic sortant est autorisé.

### Load Balancer
- **Port d'entrée** : 443 (HTTPS)
- **Port cible** : 80 (HTTP)
- **Vérification de santé** : Vérifie le chemin `/health` toutes les 10 secondes.

### Droplets
- **Images** : `ubuntu-20-04-x64`
- **Taille** : `s-1vcpu-2gb`
- **Région** : `nyc1`

## Problèmes possibles

### Variables manquantes
Vérifiez que votre fichier `.env` est correctement configuré et que toutes les variables nécessaires sont présentes.

### Token DigitalOcean invalide
Assurez-vous que le token API utilisé a les permissions nécessaires pour créer des ressources.

## Futures implémentations
- Application microservices installée sur les droplets

## Contributions
Les contributions sont les bienvenues ! Veuillez suivre ces étapes :

- Fork le projet.
- Créez une branche : git checkout -b feature/amélioration.
- Proposez une pull request.
