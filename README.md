<small>

> `MENU` **README** | [How to run locally](./docs/00_INSTALLATION.md) | [REST API doc](./docs/01_REST_API_DOC.md) | [Web app screenshots](./docs/02_WEB_APP_SCREENSHOTS.md)

</small>

# ✨ Solid Rails App <!-- omit in toc -->

Web and REST API application made with [Ruby on Rails](https://guides.rubyonrails.org/) + [solid-process](https://github.com/solid-process/solid-process).

## 📚 Table of contents <!-- omit in toc -->

- [💡 Branch summary](#-branch-summary)
- [📣 Important info](#-important-info)

## 💡 Branch summary

The [vanilla-rails summary](https://github.com/solid-process/solid-rails-app/blob/vanilla-rails?tab=readme-ov-file#-solid-rails-app-) presents the Account::Member as one of the application's most important components. It is responsible for controlling access to the accounts.

It turns out that although it is a PORO (Solid::Model), its implementation also contains queries (ActiveRecord stuff).

This version introduces [Account::Member::Repository](https://github.com/solid-process/solid-rails-app/blob/solid-process-2.40/app/models/account/member/repository.rb) to enhance the separation of concerns. This new component/pattern will serve as an abstraction layer for the data source, allowing queries to be moved to it and making the [Account::Member implementation more straightforward and concise](https://github.com/solid-process/solid-rails-app/blob/solid-process-2.40/app/models/account/member.rb).

## 📣 Important info

To understand the project's context, I'd like you to please read the [main branch's README](https://github.com/solid-process/solid-rails-app/tree/main?tab=readme-ov-file).

Check out the:
1. [disclaimer](https://github.com/solid-process/solid-rails-app/tree/main?tab=readme-ov-file#-disclaimer) to understand the project's purpose.
2. [summary](https://github.com/solid-process/solid-rails-app/tree/main?tab=readme-ov-file#-repository-branches) of all branches.
3. [highlights](https://github.com/solid-process/solid-rails-app/tree/main?tab=readme-ov-file#-highlights-of-what-solid-process-can-bring-to-youyour-team-) of what solid-process can bring to you/your team.
