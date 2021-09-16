# Lab Agora - Survey WebApp

Temporary Survey Web Application using LimeSurvey for [Lab Agora][lab-agora-link], an [Institut National Du Cancer][inca-link] public startup helping French actors in the fight against cancer to establish beneficial relationships with
patients and other actors.

## Contributing

### Getting started

```sh
git clone https://github.com/betagouv/inca-survey.git
make start
```

### Automated Git Deployment Setup

```sh
git remote add live ssh://<username>@<ip>/home/<username>/repositories/inca-survey.git
```

### Deployment

```sh
git push live main
```

### Commands

```sh
make backup # Dump MariaDB databases
make restore # Restore MariaDB databases
```

---

[inca-link]: https://www.e-cancer.fr
[lab-agora-link]: https://lab-agora.softr.app
[limesurvey-link]: https://github.com/LimeSurvey/LimeSurvey
[git-submodules-link]: https://git-scm.com/book/en/v2/Git-Tools-Submodules
