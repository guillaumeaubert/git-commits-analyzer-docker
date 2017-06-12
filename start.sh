#!/bin/bash

# Adjust timezone.
GCA_TIMEZONE=${GCA_TIMEZONE:="America/Los_Angeles"}
export TZ="/usr/share/zoneinfo/${GCA_TIMEZONE}"
echo "Date: `date`."

# Set up crontab.
touch $CRONTAB
echo "TZ=${GCA_TIMEZONE}" >> $CRONTAB
echo "${GCA_SCHEDULE} /app/analyze.sh" >> $CRONTAB

# Update permissions on the ssh directory if one has been mounted for the user.
if [ -d "/home/gca/.ssh" ]; then
	echo "Updating permissions on /home/gca/.ssh."
	chown -R gca /home/gca/.ssh
	chmod -R 600 /home/gca/.ssh
	chmod 700 /home/gca/.ssh
fi

# Make sure the repositories to scan are readable.
# Directories get 755, files get 644.
chmod -R u+rwX,go+rX,go-w /data

# Clone output repo.
GCA_OUTPUT_REPO=${GCA_OUTPUT_REPO:=""}
if [ "$GCA_OUTPUT_REPO" == "" ]; then
	echo "\$GCA_OUTPUT_REPO must be defined"
	exit
else
	su-exec gca git clone $GCA_OUTPUT_REPO $OUTPUT_REPO
fi

# Set up git user for the output repo.
cd $OUTPUT_REPO
git config user.email "$GCA_COMMIT_EMAIL"
git config user.name "$GCA_COMMIT_NAME"

# Start app.
if [ "$GCA_ANALYZE_ON_STARTUP" == "yes" ]; then
	su-exec gca /app/analyze.sh
else
	echo "No sync on startup, see GCA_ANALYZE_ON_STARTUP if you would like to change this."
fi

crond -f
