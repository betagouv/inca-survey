# Lab Agora - Survey Web Application

Survey Web Application using [Tell Me][lnk-tell-me] for [Lab Agora][lnk-lab-agora], an
[Institut National Du Cancer][lnk-inca] public startup helping French actors in the fight against cancer to establish
beneficial relationships between patients and other actors.

## Deployment

Following [our global deployment strategy](https://github.com/betagouv/inca-proxy#how-it-works):

```sh
ssh <USERNAME>@<SERVER_IP>
mkdir ~/deployments/inca-survey
```

Add the current proxy Git repository workflow:

```sh
git init --bare ~/repositories/inca-survey.git
vim ~/repositories/inca-survey.git/hooks/post-receive
```

which could look like this:

```sh
#!/bin/bash

# Exit when any command fails:
set -e

TARGET="/home/<USERNAME>/deployments/inca-survey"
GIT_DIR="/home/<USERNAME>/repositories/inca-survey.git"
BRANCH="main"

while read oldrev newrev ref
do
  # Only checking out the specified branch:
  if [[ $ref = "refs/heads/${BRANCH}" ]]; then
    echo "Git reference $ref received. Deploying ${BRANCH} branch to production..."
    git --work-tree="$TARGET" --git-dir="$GIT_DIR" checkout -f "$BRANCH"
    cd $TARGET
    sudo make start
  else
    echo "Git reference $ref received. Doing nothing: only the ${BRANCH} branch may be deployed on this server."
  fi
done
```

Give the execution rights:

```sh
chmod +x ~/repositories/inca-survey.git/hooks/post-receive
```

You can now exit and go into you your local proxy directory to add your server repository reference:

```
git remote add live ssh://<USERNAME>@<SERVER_IP>/home/<USERNAME>/repositories/inca-survey.git
```

Everything is now ready for the proxy part and you will now be able to push any new commit to production via:

```sh
git push live main
```

### Commands

```sh
make backup # Dump MongoDB database
make restore # Restore MongoDB database
```

---

[lnk-inca]: https://www.e-cancer.fr
[lnk-lab-agora]: https://lab-agora.softr.app
[lnk-tell-me]: https://github.com/betagouv/tell-me
