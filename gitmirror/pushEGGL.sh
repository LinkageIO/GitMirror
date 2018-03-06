#!/bin/bash

NAME=$1
REPO=$2
MIRROR_ORG="UMN-Equine-Lab"

cd $HOME
mkdir -p Codes && cd Codes
if [ ! -d $NAME.git ]; then
	# Clone it
    git clone --mirror $REPO
	# Create the mirror repo   	
    curl -d "{\"name\": \"${NAME}\", \"description\": \"Mirror for ${NAME}\", \"homepage\": \"\", \"private\": false, \"has_issues\": true, \"has_projects\": true, \"has_wiki\": true}"  -H "Content-Type: application/json" -H "Authorization: token $GITHUBTOKEN" https://github.umn.edu/api/v3/orgs/${MIRROR_ORG}/repos
fi
cd $NAME.git
git remote update
git remote add mirror https://${GITHUBTOKEN}:x-oauth-basic@github.umn.edu/${MIRROR_ORG}/${NAME}.git
git push mirror
