# README

## FE repository

https://github.com/doanhungb1/clip_sharing_fe

## Introduction

App helps sharing youtube video.

1) Login/Signup

2) Share a youtube video by parsing an URL.

3) Feed including shared videos of all users.

4) Notification when a new video is shared.

## Prerequisites:

- Ruby 3.3 / Rails 7.1.3.2
- Postgres
- ReactJS / Node 20.10
- ENVIRONMENT: google api key from https://developers.google.com/maps/documentation/javascript/get-api-key.

## Installation & Configuration

- Clone repo: `git clone https://github.com/doanhungb1/clip_sharing.git`
- Access repo: `cd clip_sharing`
- Install bundle: `gem install bundler -v '~> 2.5.7'`
- Run: `bundle install`
- Add env:

```
export DATABASE_USER={{your_db_user}}
export DATABASE_PASSWORD={{your_db_pass}}
export YOUTUBE_API_KEY={{your_api_key}}
export DEVISE_JWT_SECRET={{your_jwt_secret}}
```
- Setup db:
```
rails db:create
rails db:migrate
```
- Run rails s:
```
rails s -p 3001
```

## Docker installation
- You will need an env file `.env`:
```
DATABASE_HOST=clip_sharing_postgres
DATABASE_USER=postgres
DATABASE_PASSWORD=postgres
YOUTUBE_API_KEY=
DEVISE_JWT_SECRET=devise_secret
RAILS_ENV=development
```

- Build:
```
docker-compose build
```

- Run docker containers:
```
docker-compose up
```
or
```
docker-compose up -d
```

## Usage:
- Login
![image](https://github.com/doanhungb1/clip_sharing/assets/23555365/0e945bab-e4ea-4bb2-a13b-6e8f8a9abb09)
- Share clip
![image](https://github.com/doanhungb1/clip_sharing/assets/23555365/c991f31e-e067-44de-ac59-cc8932cf824a)
- Feed
![image](https://github.com/doanhungb1/clip_sharing/assets/23555365/6498b71d-8b09-4138-9b85-70fb73ef1013)
- Receive notification
![image](https://github.com/doanhungb1/clip_sharing/assets/23555365/9b9a4723-531c-4de6-98dd-a7026bfbeb8c)
## Troubleshooting
