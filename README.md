<p align="center"><img src="img/lightyear-logo.png"></img></p>

# Lightyear SRE Challenge

> "Site reliability engineering is a discipline that incorporates aspects of software engineering and applies them to infrastructure and operations problems."

## Introduction
Hello and welcome! If you are reading this, then you have chosen to give our SRE Code Challenge a try. Splendid! You've got this.

Software Engineering interviewing is something our industry has never done very well. We've tried to find the right blend of respecting your time and ensuring you will be  successful in our organization as an SRE.

This challenge will give you a taste of the kind of real work an SRE on our team performs. A mix between coding, networking, infrastructure, and observability.

## Background
The team built a web application in ruby on rails that is designed to provide inspirational quotes from team members. It's been a wild success! So much so that the traffic started to exceed our compute capabilities in Heroku. The rails application was pushed directly to Git and Heroku was configured to automatically do all deployment.

The old architecture:
<p align="center"><img src="img/old_arch.png"></img></p>

After a major outage, the team identified that the API returning quotes was being consumed by an internal mobile application. That unexpected traffic was taking the website down.

To handle this increase we are going to move the APIs to micro-services, in order to do this and still support the mobile app we will use the reverse proxy Traefik to ensure that /api/chadiamond, /api/eric, and /api/brooke are still valid. The move to this new architecture has also rendered our CI/CD process (just push to heroku!) obsolete. The team is manually deploying with Terraform but could use your help making these things better.

The new architecture:
<p align="center"><img src="img/new_arch.png"></img></p>

## Pre-requisites
- Terraform 0.13 or greater installed.
- Docker Desktop Installed
- Minikube for testing the kubernetes deployment
- If you want to make code changes to the micro-services you will need ruby 3.0.1, python 3.9.5, node 16, and Go 1.16 installed
- If you want to build the rails app you'll need the Ruby on Rails Master.key file from your contact
  

## Level-Set Expectations
- Most people invest 3-4 hours into this
- You don't have to solve everything, in fact we expect you not to! Work in priority order and come prepared to chat in our debrief about any struggles you encounter. The real interview is communicating about how you're solving these problems!
- If you don't know something or it doesn't make sense. Reach out, on the job you will be able to tap colleagues for help and expect the same here!
- We expect your work to be done in a branch and submitted as a pull request to main. We'll do the code review of your PR together!


## Current-State
The team has already put a ton of work in to refactor the application to the new architecture, but there are a few things that you can do to make it even better! Here is what they have done so far.

Refactored the Cha'Diamond, Brooke, and Eric Micro-services and dockerized them.
They dockerized the Ruby on Rails Web application.
They added Postgres, Redis, and Traefik to docker compose. (You can see it all by running docker-compose up!)

They started the work to move this to Kubernetes using Terraform found in /infrastructure. If you install minikube -> run "minikube start" to create your cluster -> and "minikube tunnel" to handle the creation of local load balancers.. You can terraform init -> terraform apply to get the app running on your local cluster! YAY!

The team has been excited to bring in an SRE, a hero designed to reduce the team's toil through automation and living at the intersection between code and infrastructure. They've prepared a list of things they could use your help on.

Tackle these InsPIRA tickets in priority order. (Again, don't worry if you don't finish them all! Get through what you can and be prepared to chat about it.)
- Deploy v0.3 of inspire-web
- Update the configuration to automatically deploy this image whenever there is an update
- Deploy the Redis Helm chart (it's commented out)
    - Hm, the web pods don't seem to like Redis. Diagnose and resolve the issue so the web pods AND Redis can run in the cluster.
- What CI/CD strategy would you recommend for this cluster? This could involve many git repos beyond this! Can you help us with that?

Bonus points!
- Traefik is deployed to the cluster via helm chart, but isn't used yet. Can you configure Traefik?
- How might we build observability and monitoring into the cluster? Feel free to start implementing this or prepare talking points as time allows.
- We'd also love to hear recommendations from you on how we could build confidence and reduce toil on our team with automation. What else would you suggest we do?
