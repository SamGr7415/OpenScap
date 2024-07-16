#!/bin/bash

# Fonction pour vérifier si un service est installé
check_service_installed() {
    local service=$1
    dpkg -l | grep -q $service
}

# Fonction pour vérifier si un service est actif
check_service_active() {
    local service=$1
    systemctl is-active --quiet $service
}

# Fonction pour vérifier la propriété des fichiers
check_file_ownership() {
    local file=$1
    local owner_group=$2
    [ "$(stat -c "%U:%G" $file)" == "$owner_group" ]
}

# Fonction pour vérifier les permissions des fichiers
check_file_permissions() {
    local file=$1
    local permissions=$2
    [ "$(stat -c "%a" $file)" == "$permissions" ]
}

# Fonction pour vérifier si un paquet est installé
check_package_installed() {
    local package=$1
    dpkg -l | grep -q $package
}

# Vérifications des règles de sécurité
check_rules() {
    echo "Checking security rules..."

    # Exemples de vérifications
    if check_package_installed "rsyslog"; then
        echo "Rule: Ensure rsyslog is Installed - Applicable"
    else
        echo "Rule: Ensure rsyslog is Installed - Not Applicable"
    fi

    if check_service_active "rsyslog"; then
        echo "Rule: Enable rsyslog Service - Applicable"
    else
        echo "Rule: Enable rsyslog Service - Not Applicable"
    fi

    if check_package_installed "syslog-ng"; then
        echo "Rule: Ensure syslog-ng is Installed - Applicable"
    else
        echo "Rule: Ensure syslog-ng is Installed - Not Applicable"
    fi

    if check_service_active "syslog-ng"; then
        echo "Rule: Enable syslog-ng Service - Applicable"
    else
        echo "Rule: Enable syslog-ng Service - Not Applicable"
    fi

    if check_file_ownership "/etc/group" "root:root"; then
        echo "Rule: Verify Group Who Owns group File - Applicable"
    else
        echo "Rule: Verify Group Who Owns group File - Not Applicable"
    fi

    if check_file_permissions "/etc/group" "644"; then
        echo "Rule: Verify Permissions on group File - Applicable"
    else
        echo "Rule: Verify Permissions on group File - Not Applicable"
    fi

    # Ajoutez d'autres vérifications de règles ici...
}

# Exécute les vérifications
check_rules

echo "Security rules check completed."
