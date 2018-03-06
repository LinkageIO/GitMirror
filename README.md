# GitMirror
A microservice to mirror github repositories. The microservice is implemented as a docker container and is activated by a Github webhook that is fired whenever you push to your repository. This is useful for use cases such as mirroring your public github repositories with an Enterprise version of github (perhaps offered by your work or university).

For clarity, assume you work on a main repository (REPO_A). A mirror repository (REPO_B) will be created and automagically updated when you push to REPO_A.

- **Note**: This service requires you to be able to access a server that can run docker containers that can accept web traffic.
- **Note**: This service currently works one way. REPO_B mirrors REPO_A. Changes to REPO_B are not handled and will likely result in werid behavior.

## Installation
The installation process has a few parts. First, there are some authentication errands that need to be done. Second, the microservice needsto be build and started on a server running docker that can accept internet traffic. Third, the webhook for REPO_A needs to be setup.

### Step 1: Acquire Authentication Codes
We need to get two pieces of information that will be passed as ENV variables to the docker container.

1. The mirror repositories (REPO_B) will be housed under a github organization of your choosing. Create or choose and organization of your choosing under the github that will house REPO_B. Note that the display name may be different than the actual organization name. You can double check this by looking at the URL for your organization page. For example, I am at the University of Minnesota and our organization URL is `https://github.umn.edu/organizations/UMN-Equine-Lab/settings/profile`. The organization would then be `UMN-Equine-Lab`.

You can also find organization names from the profile drop down menu:
![](https://i.imgur.com/Zl8qexw.png)

Save this name for later, it will take the form of `MIRROR_ORG=XXXXXXXXX`.

2. In order to do things like create new mirrors and to have push permissions, the docker container needs to have access to an a Personal Access Token. This is a special token that allows the service to change the mirror repos through the github API. Tokens are generated and given to you once, so put them in a safe place. Do not share them. Create a token that has permissions to create repositories within an organization and that can also push to repositories within the organization.

Once done, you should have a paget that looks like:
![](https://i.imgur.com/3GMgz3p.png)

- **Note**: You have one chance to copy down a token. If you lose it, you can generate a new one.
- **Note**: DO NOT SHARE OR DISTRIBUTE THIS TOKEN. Treat this like a password.

Save the token for later, it will take the form of `GITHUBTOKEN=YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY`

### Step 2: Build and deploy GitMirror as a microservice
This step assumes you have docker installed and that you have access to a server that can handle long-running services (i.e. not one thats rebooted often). This simplifies deployment of the listening server substantially as it runs from a container.
```{bash}
$ git clone https://github.com/LinkageIO/GitMirror.git
$ cd GitMirror
$ docker build -t gitmirror:latest . --no-cache
```
Deploy the service. Pass in the authentication info we acquired in step 1. 
```{bash}
docker run \
    -e "GITHUBTOKEN=YYYYYYYYYYYYYYYYYYYYYYYY" \
    -e "MIRROR_ORG=XXXXXXXXXX" \
    -p 57283:57283  \
    -d gitmirror:latest
```
Once finished the container will be listening for webhooks (see Step 3) on port `57283`.

### Step 3: Set up a webhook to keep the mirror in sync
The final step is to set up a webhook in REPO_A to fire whenever a there changes. Find out the IP address of the computer running the GitMirror docker container. Navigate to the github page for the repository you want to mirror. Navigate to Settings > Webhooks > Add Webhook. You should be rewarded with a form that looks like:
![](https://i.imgur.com/5L02Q01.png)

Fill in two fields.
1. Put in the IP or URL of the server running the docker container **including the port** (e.g. 123.456.789:57283)
2. Change the Content type to `application/json`.

Click Add Webhook.

Doing this should fire your first webhook which should trigger the mirror to be built. Refresh your REPO_B github page to double check the mirroring occured.

This project is open source. Open bugs and issues [here](https://github.com/LinkageIO/GitMirror/issues).
