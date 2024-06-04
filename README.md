<small>

> `MENU` **README** | [How to run locally](./docs/00_INSTALLATION.md) | [REST API doc](./docs/01_REST_API_DOC.md) | [Web app screenshots](./docs/02_WEB_APP_SCREENSHOTS.md)

</small>

# ✨ Solid Rails App <!-- omit in toc -->

Web and REST API application made with [Ruby on Rails](https://guides.rubyonrails.org/) + [solid-process](https://github.com/solid-process/solid-process) + [solid-adapters](https://github.com/solid-process/solid-adapters).

## 📚 Table of contents <!-- omit in toc -->

- [💡 Branch summary](#-branch-summary)
- [📣 Important info](#-important-info)

## 💡 Branch summary

This version implements the Ports and Adapters architectural pattern (Hexagonal Architecture).

In version [2.99](https://github.com/solid-process/solid-rails-app/blob/solid-process-2.99), the account and user namespaces encapsulated the core business logic. They began to receive and expose objects that belonged to them, in other words, objects that did not directly relate to the framework (Rails). Because of this, it becomes feasible to isolate this core outside the app folder; for this reason, these components were moved to [lib/core](https://github.com/solid-process/solid-rails-app/tree/solid-process-3/lib/core). So, through a new lib, [Solid::Adapters](https://github.com/solid-process/solid-adapters) was added, it is possible to use [initializers](https://github.com/solid-process/solid-rails-app/tree/solid-process-3/config/initializers/solid_adapters) to plug the adapters defined in the app folder (framework side) into the core. This way, it becomes protected as the app uses/implements its ports (interfaces).

## 📣 Important info

To understand the project's context, I'd like you to please read the [main branch's README](https://github.com/solid-process/solid-rails-app/tree/main?tab=readme-ov-file).

Check out the:
1. [disclaimer](https://github.com/solid-process/solid-rails-app/tree/main?tab=readme-ov-file#-disclaimer) to understand the project's purpose.
2. [summary](https://github.com/solid-process/solid-rails-app/tree/main?tab=readme-ov-file#-repository-branches) of all branches.
3. [highlights](https://github.com/solid-process/solid-rails-app/tree/main?tab=readme-ov-file#-highlights-of-what-solid-process-can-bring-to-youyour-team-) of what solid-process can bring to you/your team.
