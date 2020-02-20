#!/bin/sh

if [ "$(ls -A /shared/zammad)" ]; then
	if [ -d "/shared/zammad/elasticsearch" -a -d "/shared/zammad/main" -a -d "/shared/zammad/zammad" ]; then
		echo "Cleaning environment: remove folders or links."
		rm -rf /var/lib/elasticsearch;
		rm -rf /var/lib/postgresql/9.6/main;
		rm -rf /opt/zammad;
	else
		echo "ERROR: Partial data folder.";
		echo "NOTE: For a new instance the folder /shared/zammad must be empty.";
		exit 1;
	fi
else
	echo "Moving managed data folders to the mounted folder.";
	mv /var/lib/elasticsearch /shared/zammad/;
	mv /var/lib/postgresql/9.6/main /shared/zammad/;
	mv /opt/zammad /shared/zammad/;
fi

echo "Creating config backup file if necessary";
[ -f /opt/zammad/contrib/backup/config ] || cp /opt/zammad/contrib/backup/config.dist /opt/zammad/contrib/backup/config

echo "Creating new links.";
ln -s /shared/zammad/elasticsearch /var/lib/elasticsearch;
ln -s /shared/zammad/main/ /var/lib/postgresql/9.6/main;
ln -s /shared/zammad/zammad/ /opt/zammad;

echo "Fixing Postgres corrupted sessions if necessary.";
su - postgres -c "/usr/lib/postgresql/9.6/bin/pg_resetxlog -f /var/lib/postgresql/9.6/main/";
/docker-entrypoint.sh zammad;
