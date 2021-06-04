# git_forward

* script pulls code from source branch into source directory
* takes all commit messages since last pull and merge them to one commit messages
* rsync all files to target branch directory with defined user and merged commit message

## Prerequisites

### Tools

* rsync
* jq

## Usage

1. rename reposync.json.template to reposync.json

    ```bash
    cp reposync.json.template reposync.json
    ```

2. change the content to your needs

    ```bash
    vi reposync.json
    ```

    ```bash
    {
        "source_repo": {
            "directory": "<source_repo_dir>",
            "url": "https://<source_repo.git>",
            "branch": "feature/app_new_feature"
        },
        "target_repo": {
            "directory": "<target_repo_dir>",
            "url": "https://<target_repo.git>",
            "branch": "feature/new_app",
            "name": "Your Name in Targe",
            "email": "YourEmail@target.sytem"
        }
    }
    ```

3. run the sync

    ```bash
    ./reposync.sh reposync.json
    ```
