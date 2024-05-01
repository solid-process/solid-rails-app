<small>

> `MENU` **README** | [How to run locally](./docs/00_INSTALLATION.md) | [REST API doc](./docs/01_REST_API_DOC.md) | [Web app screenshots](./docs/02_WEB_APP_SCREENSHOTS.md)

</small>

# ✨ Solid Rails App <!-- omit in toc -->

Web and REST API application made with [Ruby on Rails](https://guides.rubyonrails.org/) + [solid-process](https://github.com/solid-process/solid-process).

## 📚 Table of contents <!-- omit in toc -->

- [💡 Branch summary](#-branch-summary)
- [📣 Important info](#-important-info)

## 💡 Branch summary

From version 2 onwards, all contexts (Account and User) implement their operations through processes. Because of this, it becomes possible to create a composition of processes where they are defined as dependencies that will be orchestrated through their steps.

Notes:

1. [UserToken](https://github.com/solid-process/solid-rails-app/blob/solid-process-2.00/app/models/user_token.rb) becomes hugely lean because the model's behavior has been diluted into different components within the [User::Token namespace](https://github.com/solid-process/solid-rails-app/tree/solid-process-2.00/app/models/user/token). I am highlighting [User::Token::Entity](https://github.com/solid-process/solid-rails-app/blob/solid-process-2.00/app/models/user/token/entity.rb), a PORO capable of representing a token without the need to interact with the database (ActiveRecord model).

2. New features are added to input blocks, such as data normalization and validation.

## 📣 Important info

To understand the project's context, I'd like you to please read the [main branch's README](https://github.com/solid-process/solid-rails-app/tree/main?tab=readme-ov-file).

Check out the:
1. [disclaimer](https://github.com/solid-process/solid-rails-app/tree/main?tab=readme-ov-file#-disclaimer) to understand the project's purpose.
2. [summary](https://github.com/solid-process/solid-rails-app/tree/main?tab=readme-ov-file#-repository-branches) of all branches.
3. [highlights](https://github.com/solid-process/solid-rails-app/tree/main?tab=readme-ov-file#-highlights-of-what-solid-process-can-bring-to-youyour-team-) of what solid-process can bring to you/your team.
