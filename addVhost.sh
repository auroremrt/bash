#!/bin/bash

##
# Creation des vhosts Apache spécifique Symfony 3
# Usage :
# ./addVhost vhost_name [use_ssl]
##

#Définit le dossier racine des applications Apache
ROOT_DIR="/home/aurore/www/"

if [ $# == 0 ]
then
	echo "To few arguments to process. Operation failed"
	exit -1
else
	#Copier le fichier template-Symfony vers /etc/apache2/sites-available
	#avec le nom vhost_name.conf
	cp ./template-symfony /etc/apache2/sites-available/$1.conf

	#Créer le dossier dans le dossier ~/www
	mkdir -p $ROOT_DIR$1 $ROOT_DIR$1/web

	#Remplacer "template" par "vhost_name" dans le fichier de conf
	sed -i 's/template/'$1'/g' /etc/apache2/sites-available/$1.conf

	#Ajouter le fichier de conf à la liste des sites actifs
	a2ensite $1.conf

	#Mettre à jour le fichier hosts
	echo "10.31.99.71 $1.wrk www.$1.wrk" >> /etc/hosts

	#Vérifier l'exécution globale
	touch $ROOT_DIR$1/web/app.php
	echo "<?php phpinfo();" >> $ROOT_DIR$1/web/app.php

	#Relancer Apache
	systemctl reload apache2.service
fi
