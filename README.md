<small>

> `MENU` **README** | [How to run locally](./docs/00_INSTALLATION.md) | [REST API doc](./docs/01_REST_API_DOC.md) | [Web app screenshots](./docs/02_WEB_APP_SCREENSHOTS.md)

</small>

# ✨ Solid Rails App <!-- omit in toc -->

Web and REST API application made with [Ruby on Rails](https://guides.rubyonrails.org/).

## 📚 Table of contents <!-- omit in toc -->

- [💡 Branch summary](#-branch-summary)
- [📣 Important info](#-important-info)

## 💡 Branch summary

It is the base version that implements a web application and REST API using the Rails Way approach. The business rules are mainly implemented around the ActiveRecord lifecycle/features (normalization, validation, callbacks, and macros), which the application controllers orchestrate.

However, with each new version, these models and controllers will have fewer responsibilities as we implement processes to wrap and orchestrate the core business logic.

Note: Three concepts differ from a traditional CRUD. Are they:

1. [Account Member](https://github.com/solid-process/solid-rails-app/blob/vanilla-rails/app/models/account/member.rb): This PORO performs access/scope control in the accounts.

2. [User Registration](https://github.com/solid-process/solid-rails-app/blob/vanilla-rails/app/models/user.rb#L18-L49): This operation consists of creating the user and its account, defining the user as the account's owner, creating the user API token, and sending an email to confirm the user email.

3. [User API token](https://github.com/solid-process/solid-rails-app/blob/vanilla-rails/app/models/user_token.rb): This implementation is based on the [prefixed API token concept](https://github.com/seamapi/prefixed-api-key), which consists of a short (public) and a long (encrypted) token.

## 📣 Important info

To understand the project's context, I'd like you to please read the [main branch's README](https://github.com/solid-process/solid-rails-app/tree/main?tab=readme-ov-file).

Check out the:
1. [disclaimer](https://github.com/solid-process/solid-rails-app/tree/main?tab=readme-ov-file#-disclaimer) to understand the project's purpose.
2. [summary](https://github.com/solid-process/solid-rails-app/tree/main?tab=readme-ov-file#-repository-branches) of all branches.
3. [highlights](https://github.com/solid-process/solid-rails-app/tree/main?tab=readme-ov-file#-highlights-of-what-solid-process-can-bring-to-youyour-team-) of what solid-process can bring to you/your team.
