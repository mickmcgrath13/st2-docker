# Bitovi StackStorm in Docker containers

## Prerequisites

- Docker Engine 1.13.0+ (On a Mac?  Use [Docker for Mac](https://www.docker.com/docker-mac))
- git

## TL;DR

```
git clone https://github.com/mickmcgrath13/st2-docker.git name-your-folder
cd name-your-folder
make init
```

> Note: If desired, change username/password in `name-your-folder/conf/stackstorm.env`

```
docker-compose up -d
```

> Note: the container name may be different. Run `docker ps` to get the containers list

```
docker-compose exec stackstorm_container_name bash 
```

Open `https://localhost` in your browser.

> StackStorm Username/Password can be found in: `cat conf/stackstorm.env`

> **Note:** If you log into the stackstorm container and run `st2ctl status` to find that the mistral services are not running, try
> `docker-compose down -v && docker-compose up`
> [Source](https://github.com/StackStorm/st2-docker/issues/133#issuecomment-391549445)


Configure the `github` and `bitovi_packs`
Go to the [Packs page](https://localhost/#/packs), and select the `github` pack
Fill in the details
```
base_url: https://api.github.com
deployment_environment: dev
github_type: online
token: your_github_personal_access_token
user: your_github_user
```
Do the same for `bitovi_packs`
```
github_token: your_github_personal_access_token
github_user: your_github_user
github_exhange_org: bitovi-stackstorm-exchange
pack: bitovi_packs
skip_dependencies_on_install: true
stackstorm_environment: dev
```

You'll also need to run `github.store_oath_token` with your token from the `Actions` page.


> Note: Alternatively, you can add `github.yaml` and `bitovi_packs.yaml` with the above contents, respectively, to `stackstorm-config/`, and then run the `packs.load` action for both packs.


## Local Chatops Bot
To test aliases, it's useful to have a local Slack bot that can talk to your local machine.

Head over to the [Slack Apps Page](https://api.slack.com/apps), and create a new app.

Give it a meaningful name (e.g. `stackstorm-local-mick`), select a workspace, and save it.

Select 'Bot Users' from the side menu, click 'Add a Bot User', git the bot a display and username (e.g. `mickbot`), and click 'Add Bot User'.

Select 'OAuth & Permissions', and click 'Install App to Workspace' (you'll need to authorize the app).

Copy the **Bot User OAuth Access Token** (e.g. `xoxb-your-token`)

> You can close the Slack browser tab, now;  you're done with it :)

Make a copy of the `st2chatops.env.sample`
```
cd name-your-folder && cp stackstorm-chatops/st2chatops.env.sample stackstorm-chatops/st2chatops.env
```
Open `stackstorm-chatops/st2chatops.env`, and configure the following:
```
# Bot name (match your slack bot name)
export HUBOT_NAME=mickbot
export HUBOT_ALIAS='@mickbot'

export HUBOT_ADAPTER=slack
export HUBOT_SLACK_TOKEN=xoxb-your-token
```

Restart chatops (from within container)
```
service st2chatops restart
```

## Pack Development
After you spin up the environment, you can play around with st2 *in container-ized environment* by following [this tutorial guide](./docs/bitovi-tutorial.md).

## Want More?
- Running on Kubernetes? See [runtime/kubernetes-1ppc](./runtime/kubernetes-1ppc)
- See [Step by step instructions](./step-by-step.md) for more information.