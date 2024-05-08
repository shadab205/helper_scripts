#!/bin/bash -x

# Define the URL of the Git repository, this is where the website source is stored
REPO_URL="https://github.com/shadab205/shadab205.github.io.git"

# Define the website source branch
WEBSITE_BRANCH="gh-pages"

# Directory where you want to clone the repository
CLONE_DIR="/tmp/website"

# Website source directory of your apache webserver
WEBSITE_DIR="/var/www/website"

# Destination directory for old site backup
BACKUP_DIR="$HOME/old-site-backup/$(date +'%Y-%m-%d_%H-%M-%S')"

# Website configuration file of your apache webserver, used to enable or disable the site during update
WEBSITE_CONF="website.conf"

# Disable website configuration
a2dissite $WEBSITE_CONF

# Backup current contents of website directory
mkdir -p $BACKUP_DIR
mv $WEBSITE_DIR/* $BACKUP_DIR

# Empty the temporary directory
rm -rf $CLONE_DIR

# Clone the repository
git clone $REPO_URL $CLONE_DIR

# Change directory to where the repository was cloned
cd $CLONE_DIR

# Checkout to the required branch if needed
git checkout $WEBSITE_BRANCH

# Copy contents to website directory
cp -r * $WEBSITE_DIR

# Update file ownership
chown -R www-data:www-data $WEBSITE_DIR

# Check if file ownership is already 'www-data'
if [ "$(stat -c '%U' $WEBSITE_DIR)" = "www-data" ]; then
    # If ownership is 'www-data', enable website configuration
    a2ensite $WEBSITE_CONF
else
    echo "Warning: Ownership of $WEBSITE_DIR is not 'www-data'. Website configuration will not be enabled."
fi

# List files in website directory to check the ownership
ls -la $WEBSITE_DIR
