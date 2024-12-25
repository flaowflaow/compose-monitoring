#!/bin/bash

# Fonction pour générer une chaîne aléatoire pour GRAYLOG_PASSWORD_SECRET
generate_secret() {
  tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 32
}

# Fonction pour obtenir et hacher le mot de passe
get_hashed_password() {
  read -sp "Entrez le mot de passe : " password
  echo
  read -sp "Confirmez le mot de passe : " password_confirm
  echo
  if [ "$password" != "$password_confirm" ]; then
    echo "Les mots de passe ne correspondent pas. Veuillez réessayer."
    exit 1
  fi
  echo -n "$password" | sha256sum | awk '{print $1}' | tr -d '\n'
}

env_file=".env"
temp_file=$(mktemp)

if [ ! -f "$env_file" ]; then
  echo "Le fichier .env n'existe pas. Création du fichier."
  touch "$env_file"
fi

# Vérifier et ajouter GRAYLOG_PASSWORD_SECRET
if ! grep -q "GRAYLOG_PASSWORD_SECRET" "$env_file"; then
  echo "Ajout de la variable GRAYLOG_PASSWORD_SECRET dans le fichier .env"
  graylog_secret=$(generate_secret)
  echo "GRAYLOG_PASSWORD_SECRET=$graylog_secret" >> "$temp_file"
fi

# Vérifier et ajouter GRAYLOG_ROOT_PASSWORD_SHA2
if ! grep -q "GRAYLOG_ROOT_PASSWORD_SHA2" "$env_file"; then
  echo "Ajout de la variable GRAYLOG_ROOT_PASSWORD_SHA2 dans le fichier .env"
  root_password_sha256=$(get_hashed_password)
  echo "GRAYLOG_ROOT_PASSWORD_SHA2=$root_password_sha256" >> "$temp_file"
fi

# Vérifier et ajouter OPENSEARCH_INITIAL_ADMIN_PASSWORD
if ! grep -q "OPENSEARCH_INITIAL_ADMIN_PASSWORD" "$env_file"; then
  echo "Ajout de la variable OPENSEARCH_INITIAL_ADMIN_PASSWORD dans le fichier .env"
  read -sp "Entrez le mot de passe initial OpenSearch : " opensearch_password
  echo
  read -sp "Confirmez le mot de passe initial OpenSearch : " opensearch_password_confirm
  echo
  if [ "$opensearch_password" != "$opensearch_password_confirm" ]; then
    echo "Les mots de passe ne correspondent pas. Veuillez réessayer."
    exit 1
  fi
  echo "OPENSEARCH_INITIAL_ADMIN_PASSWORD=$opensearch_password" >> "$temp_file"
fi

# Vérifier et ajouter GRAFANA_ADMIN_PASSWORD
if ! grep -q "GRAFANA_ADMIN_PASSWORD" "$env_file"; then
  echo "Ajout de la variable GRAFANA_ADMIN_PASSWORD dans le fichier .env"
  read -sp "Entrez le mot de passe administrateur Grafana : " grafana_password
  echo
  read -sp "Confirmez le mot de passe administrateur Grafana : " grafana_password_confirm
  echo
  if [ "$grafana_password" != "$grafana_password_confirm" ]; then
    echo "Les mots de passe ne correspondent pas. Veuillez réessayer."
    exit 1
  fi
  echo "GRAFANA_ADMIN_PASSWORD=$grafana_password" >> "$temp_file"
fi

# Nettoyer le fichier temporaire : supprimer les retours à la ligne après '=' et les lignes vides
# Supprimer les lignes vides et les retours à la ligne après le symbole '='
sed -i '/^$/d' "$temp_file"  # Supprimer les lignes vides
# Supprimer les retours à la ligne après le symbole '='
sed -z -i 's/=\n/\=/g' "$temp_file"

# Ajouter les nouvelles variables au fichier .env
if [ -s "$temp_file" ]; then
  cat "$temp_file" >> "$env_file"
  echo "Le fichier .env a été mis à jour avec succès !"
else
  echo "Le fichier .env est déjà à jour."
fi

# Nettoyer le fichier temporaire
rm "$temp_file"

# Afficher le contenu du fichier après modification pour vérification
echo "Contenu du fichier $env_file après modification :"
cat "$env_file"