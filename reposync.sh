#!/bin/bash

set -e

CONFIGFILE=$1
if [[ ! -f $CONFIGFILE ]]; then
    echo "Config file '$CONFIGFILE' not found. Exiting ..."
    exit 1
fi
# testing if rsync is available
RSYNC=$(which rsync|| true)
if [[ $RSYNC = "" ]]; then
    echo "Rsync not available"
    exit 1
fi

# Read config into vars
URL_SOURCE=$(jq -r '.source_repo.url' $CONFIGFILE)
URL_TARGET=$(jq -r '.target_repo.url' $CONFIGFILE)
DIRECTORY_SOURCE=$(jq -r '.source_repo.directory' $CONFIGFILE)
DIRECTORY_TARGET=$(jq -r '.target_repo.directory' $CONFIGFILE)
BRANCH_SOURCE=$(jq -r '.source_repo.branch' $CONFIGFILE)
BRANCH_TARGET=$(jq -r '.target_repo.branch' $CONFIGFILE)
NAME_TARGET=$(jq -r '.target_repo.name' $CONFIGFILE)
EMAIL_TARGET=$(jq -r '.target_repo.email' $CONFIGFILE)

# getting source branch updates
cd "$DIRECTORY_SOURCE"
# switch to configured branch
git checkout $BRANCH_SOURCE
# get current commit ID
CURRENT_COMMIT_ID=$(git rev-parse HEAD)
# check if we need to do something
git remote update
LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse @{u})

if [ $LOCAL = $REMOTE ]; then
    echo "Branch is Up-to-date. Nothing to do."
    exit 0
fi

# get latest state
git pull origin $BRANCH_SOURCE
# analyse log to get newest commit message(s) and print out in revers order (first oldest commit msg)
SOURCE_COMMIT_MESSAGES=$(git log --pretty=format:"%s" -$(git rev-list ${CURRENT_COMMIT_ID}..HEAD | wc -l) | sed '1!G;h;$!d')

echo -e " Merged commit message:\n$SOURCE_COMMIT_MESSAGES"

# committing target branch files
cd "$DIRECTORY_TARGET"
# setting user data
git config user.name "$NAME_TARGET"
git config user.email "$EMAIL_TARGET"
# switch to target branch
git checkout $BRANCH_TARGET
# copying all source file flat to target with rsync
$RSYNC -av ${DIRECTORY_SOURCE}/ ${DIRECTORY_TARGET}/ --delete --exclude '.git'
git add .
git commit -m "$SOURCE_COMMIT_MESSAGES"
git push origin $BRANCH_TARGET


### Later development


# mail an user aus config bei jedem push
# commit message in mail (in DE)
# und hook an eine URL

# mail when synch problem (bash script error hook)

# merge conflict solving strategy


