# ✨ Solid Rails App <!-- omit in toc -->

Web and REST API application made with [Ruby on Rails](https://guides.rubyonrails.org/).

## 🙌 Repository branches <!-- omit in toc -->

This repository has three branches:
1. [vanilla-rails](https://github.com/solid-process/solid-rails-app/blob/vanilla-rails/README.md): `100%` Rails way + `0%` solid-process. (**📍 you are here**)
2. [main](https://github.com/solid-process/solid-rails-app/blob/main/README.md): `95%` Rails way + `5%` solid-process.
3. [solid-process](https://github.com/solid-process/solid-rails-app/blob/solid-process/README.md): `20%` Rails way + `80%` solid-process.

### 📊 Rails stats and code quality <!-- omit in toc -->

| Branch  | LOC   | Rubycritic   | Tests coverage   |
| ------- | :---: | :----------: | :--------------: |
| [vanilla-rails](https://github.com/solid-process/solid-rails-app/blob/vanilla-rails) | 1435 | 94.39 | 98.53% |
| [main](https://github.com/solid-process/solid-rails-app/blob/main) | 1517 | 94.30 | 98.57% |
| [solid-process](https://github.com/solid-process/solid-rails-app/blob/solid-process) | 1883 | 93.93 | 97.13% |

Use:
- `bin/rails test` to generate the tests coverage report.
- `bin/rails stats` to generate the LOC report.
- `bin/rails rubycritic` to generate the rubycritic (code quality) report.

## 📚 Table of contents <!-- omit in toc -->

- [System dependencies](#system-dependencies)
- [Setup](#setup)
- [How to run the test suite](#how-to-run-the-test-suite)
- [How to run the application locally](#how-to-run-the-application-locally)
- [API Documentation (cURL examples)](#api-documentation-curl-examples)
  - [User](#user)
    - [Registration](#registration)
    - [Authentication](#authentication)
    - [Account deletion](#account-deletion)
    - [Access token updating](#access-token-updating)
    - [Password updating](#password-updating)
    - [Password resetting - Link to change the password](#password-resetting---link-to-change-the-password)
    - [Password resetting - Change the password](#password-resetting---change-the-password)
  - [Task List](#task-list)
    - [Listing](#listing)
    - [Creation](#creation)
    - [Updating](#updating)
    - [Deletion](#deletion)
  - [Task](#task)
    - [Listing](#listing-1)
    - [Creation](#creation-1)
    - [Updating](#updating-1)
    - [Deletion](#deletion-1)
    - [Marking as completed](#marking-as-completed)
    - [Marking as incomplete](#marking-as-incomplete)
- [Web app screenshots](#web-app-screenshots)

## System dependencies
* SQLite3
* Ruby `3.2.3`
  * bundler `>= 2.5.6`

## Setup

1. Install system dependencies
2. Create a `config/master.key` file with the following content:
  ```sh
  echo 'a061933f96843c82342fb8ab9e9db503' > config/master.key

  chmod 600 config/master.key
  ```
3. Run `bin/setup`

## How to run the test suite

* `bin/rails test`

## How to run the application locally
1. `bin/rails s`
2. Open in your browser: `http://localhost:3000`

## API Documentation (cURL examples)

Set the following environment variables to use the examples below:

```bash
export API_HOST="http://localhost:3000"
export API_TOKEN="MY_ACCESS_TOKEN"
```

You can get the `API_TOKEN` by:
1. Using the below `User / Registration` request.
2. or performing the below `User / Authentication` request.
3. or copying the `access_token` from `Sign In >> Settings >> API` page.

### User

#### Registration

```bash
curl -X POST "$API_HOST/api/v1/users/registrations" \
  -H "Content-Type: application/json" \
  -d '{
    "user": {
      "email": "email@example.com",
      "password": "123123123",
      "password_confirmation": "123123123"
    }
  }'
```

#### Authentication

```bash
curl -X POST "$API_HOST/api/v1/users/sessions" \
  -H "Content-Type: application/json" \
  -d '{
    "user": {
      "email": "email@example.com",
      "password": "123123123"
    }
  }'
```

#### Account deletion

```bash
curl -X DELETE "$API_HOST/api/v1/users/registrations" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_TOKEN"
```

#### Access token updating

```bash
curl -X PUT "$API_HOST/api/v1/users/tokens" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_TOKEN"
```

#### Password updating

```bash
curl -X PUT "$API_HOST/api/v1/users/passwords" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_TOKEN" \
  -d '{
    "user": {
      "current_password": "123123123",
      "password": "321321321",
      "password_confirmation": "321321321"
    }
  }'
```

#### Password resetting - Link to change the password

```bash
curl -X POST "$API_HOST/api/v1/users/passwords/reset" \
  -H "Content-Type: application/json" \
  -d '{"user": {"email": "email@example.com"}}'
```

#### Password resetting - Change the password

```bash
curl -X PUT "$API_HOST/api/v1/users/passwords/reset" \
  -H "Content-Type: application/json" \
  -d '{
    "user": {
      "token": "TOKEN_RETRIEVED_BY_EMAIL",
      "password": "123123123",
      "password_confirmation": "123123123"
    }
  }'
```

### Task List

#### Listing

```bash
curl -X GET "$API_HOST/api/v1/task_lists" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_TOKEN"
```

#### Creation

```bash
curl -X POST "$API_HOST/api/v1/task_lists" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_TOKEN" \
  -d '{"task_list": {"name": "My Task List"}}'
```

#### Updating

```bash
curl -X PUT "$API_HOST/api/v1/task_lists/2" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_TOKEN" \
  -d '{"task_list": {"name": "My List"}}'
```

#### Deletion

```bash
curl -X DELETE "$API_HOST/api/v1/task_lists/2" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_TOKEN"
```

### Task

#### Listing

```bash
# ?filter=completed | incomplete

curl -X GET "$API_HOST/api/v1/task_lists/1/tasks" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_TOKEN"
```

#### Creation

```bash
curl -X POST "$API_HOST/api/v1/task_lists/1/tasks" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_TOKEN" \
  -d '{"task": {"name": "My Task"}}'
```

#### Updating

```bash
# "completed": true | 1 | false | 0

curl -X PUT "$API_HOST/api/v1/task_lists/1/tasks/1" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_TOKEN" \
  -d '{"task": {"name": "My Task", "completed": true}}'
```

#### Deletion

```bash
curl -X DELETE "$API_HOST/api/v1/task_lists/1/tasks/1" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_TOKEN"
```

#### Marking as completed

```bash
curl -X PUT "$API_HOST/api/v1/task_lists/1/tasks/1/complete" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_TOKEN"
```

#### Marking as incomplete

```bash
curl -X PUT "$API_HOST/api/v1/task_lists/1/tasks/1/incomplete" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_TOKEN"
```

## Web app screenshots

### Sign in <!-- omit in toc -->

<img src="/docs/screenshots/010_sign_in.jpg" width="400"/>
<img src="/docs/screenshots/011_sign_in_error.jpg" width="400"/>

### Forgot password <!-- omit in toc -->

<img src="/docs/screenshots/020_forgot_password.jpg" width="400"/>

### Sign up <!-- omit in toc -->

<img src="/docs/screenshots/030_sign_up.jpg" width="400"/>
<img src="/docs/screenshots/031_sign_up_errors.jpg" width="400"/>
<img src="/docs/screenshots/032_sign_up_success.jpg" width="400"/>

### Tasks <!-- omit in toc -->

<img src="/docs/screenshots/040_new_task.jpg" width="400"/>
<img src="/docs/screenshots/041_task_created.jpg" width="400"/>
<img src="/docs/screenshots/042_task_completed.jpg" width="400"/>
<img src="/docs/screenshots/043_tasks_completed.jpg" width="400"/>
<img src="/docs/screenshots/044_tasks_incomplete.jpg" width="400"/>
<img src="/docs/screenshots/045_edit_task.jpg" width="400"/>

### Task Lists <!-- omit in toc -->

<img src="/docs/screenshots/050_task_lists.jpg" width="400"/>
<img src="/docs/screenshots/051_new_task_list.jpg" width="400"/>
<img src="/docs/screenshots/052_select_task_list.jpg" width="400"/>

### Settings <!-- omit in toc -->

<img src="/docs/screenshots/060_settings_profile.jpg" width="400"/>
<img src="/docs/screenshots/061_settings_account_deletion.jpg" width="400"/>
<img src="/docs/screenshots/062_settings_api_access_token.jpg" width="400"/>

### Sign out <!-- omit in toc -->

<img src="/docs/screenshots/070_sign_out.jpg" width="400"/>
