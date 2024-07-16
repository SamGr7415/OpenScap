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

# Fonction pour installer un paquet
install_package() {
    local package=$1
    sudo apt-get install -y $package
}

# Fonction pour activer un service
enable_service() {
    local service=$1
    sudo systemctl enable $service
    sudo systemctl start $service
}

# Fonction pour changer la propriété des fichiers
change_file_ownership() {
    local file=$1
    local owner_group=$2
    sudo chown $owner_group $file
}

# Fonction pour changer les permissions des fichiers
change_file_permissions() {
    local file=$1
    local permissions=$2
    sudo chmod $permissions $file
}

# Vérifications des règles de sécurité et corrections
check_and_fix_rules() {
    echo "Checking and fixing security rules..."

    # Exemples de vérifications et corrections
    if check_package_installed "rsyslog"; then
        echo "Rule: Ensure rsyslog is Installed - Applicable"
    else
        echo "Rule: Ensure rsyslog is Installed - Not Applicable"
        install_package "rsyslog"
    fi

    if check_service_active "rsyslog"; then
        echo "Rule: Enable rsyslog Service - Applicable"
    else
        echo "Rule: Enable rsyslog Service - Not Applicable"
        enable_service "rsyslog"
    fi

    if check_package_installed "syslog-ng"; then
        echo "Rule: Ensure syslog-ng is Installed - Applicable"
    else
        echo "Rule: Ensure syslog-ng is Installed - Not Applicable"
        install_package "syslog-ng"
    fi

    if check_service_active "syslog-ng"; then
        echo "Rule: Enable syslog-ng Service - Applicable"
    else
        echo "Rule: Enable syslog-ng Service - Not Applicable"
        enable_service "syslog-ng"
    fi

    if check_file_ownership "/etc/group" "root:root"; then
        echo "Rule: Verify Group Who Owns group File - Applicable"
    else
        echo "Rule: Verify Group Who Owns group File - Not Applicable"
        change_file_ownership "/etc/group" "root:root"
    fi

    if check_file_permissions "/etc/group" "644"; then
        echo "Rule: Verify Permissions on group File - Applicable"
    else
        echo "Rule: Verify Permissions on group File - Not Applicable"
        change_file_permissions "/etc/group" "644"
    fi

    # Ajoutez d'autres vérifications et corrections de règles ici...
}

# Exécute les vérifications et les corrections
check_and_fix_rules

echo "Security rules check and fix completed."
