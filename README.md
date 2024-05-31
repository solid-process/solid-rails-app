<small>

> `MENU` **README** | [How to run locally](./docs/00_INSTALLATION.md) | [REST API doc](./docs/01_REST_API_DOC.md) | [Web app screenshots](./docs/02_WEB_APP_SCREENSHOTS.md)

</small>

# ✨ Solid Rails App <!-- omit in toc -->

Web and REST API application made with [Ruby on Rails](https://guides.rubyonrails.org/) + [solid-process](https://github.com/solid-process/solid-process).

## 📚 Table of contents <!-- omit in toc -->

- [💡 Branch summary](#-branch-summary)
- [📣 Important info](#-important-info)

## 💡 Branch summary

If we analyze the previous version, we will see that the [ActiveRecord models are not defined within the context of the user or account](https://github.com/solid-process/solid-rails-app/tree/solid-process-2.00/app/models).

What this version does is rename the ActiveRecord models as [Record](https://github.com/solid-process/solid-rails-app/blob/solid-process-2.20/app/models/user/record.rb) (for this, it is necessary to define the table_name and class_name in the classes) within the [Account](https://github.com/solid-process/solid-rails-app/tree/solid-process-2.20/app/models/account) and [User](https://github.com/solid-process/solid-rails-app/tree/solid-process-2.20/app/models/user) namespaces (they become mere modules since before both were also an ActiveRecord model)

## 📣 Important info

To understand the project's context, I'd like you to please read the [main branch's README](https://github.com/solid-process/solid-rails-app/tree/main?tab=readme-ov-file).

Check out the:
1. [disclaimer](https://github.com/solid-process/solid-rails-app/tree/main?tab=readme-ov-file#-disclaimer) to understand the project's purpose.
2. [summary](https://github.com/solid-process/solid-rails-app/tree/main?tab=readme-ov-file#-repository-branches) of all branches.
3. [highlights](https://github.com/solid-process/solid-rails-app/tree/main?tab=readme-ov-file#-highlights-of-what-solid-process-can-bring-to-youyour-team-) of what solid-process can bring to you/your team.
