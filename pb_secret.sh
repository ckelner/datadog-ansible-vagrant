# !/bin/bash
set -e

echo "Sourcing credentials and creating playbook w/ API key..."
source ./conf.sh
sed -e "s/YOURKEYHERE/${DD_API_KEY}/" playbook.yml > playbook_secret.yml
