# git_forward

* script pulls code from source branch into source directory
* takes all commit messages since last pull and merge them to one commit messages
* rsync all files to target branch directory with defined user and merged commit message

## Prerequisites

### Tools

* rsync
* jq

## Usage

./reposync.sh reposync.json
