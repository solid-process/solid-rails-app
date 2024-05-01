<small>

> `MENU` **README** | [How to run locally](./docs/00_INSTALLATION.md) | [REST API doc](./docs/01_REST_API_DOC.md) | [Web app screenshots](./docs/02_WEB_APP_SCREENSHOTS.md)

</small>

# ✨ Solid Rails App <!-- omit in toc -->

Web and REST API application made with [Ruby on Rails](https://guides.rubyonrails.org/) + [solid-process](https://github.com/solid-process/solid-process).

## 📚 Table of contents <!-- omit in toc -->

- [💡 Branch summary](#-branch-summary)
- [📣 Important info](#-important-info)

## 💡 Branch summary

Defines types for input attributes and uses steps to perform all operations within a transaction block that will perform a rollback if any step returns a failure. After the commit, the confirmation email is sent, and the created user is exposed in the [User::Registration](https://github.com/solid-process/solid-rails-app/blob/solid-process-1/app/models/user/registration.rb) result.

Note: In this version, the process input ([User::Registration::Input](https://github.com/solid-process/solid-rails-app/blob/solid-process-1/app/controllers/web/guest/registrations_controller.rb#L6)) is used in the view forms, causing the view to be coupled to it and no longer to the User model (ActiveRecord).

## 📣 Important info

To understand the project's context, I'd like you to please read the [main branch's README](https://github.com/solid-process/solid-rails-app/tree/main?tab=readme-ov-file).

Check out the:
1. [disclaimer](https://github.com/solid-process/solid-rails-app/tree/main?tab=readme-ov-file#-disclaimer) to understand the project's purpose.
2. [summary](https://github.com/solid-process/solid-rails-app/tree/main?tab=readme-ov-file#-repository-branches) of all branches.
3. [highlights](https://github.com/solid-process/solid-rails-app/tree/main?tab=readme-ov-file#-highlights-of-what-solid-process-can-bring-to-youyour-team-) of what solid-process can bring to you/your team.
