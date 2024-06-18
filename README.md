<small>

> `MENU` **README** | [How to run locally](./docs/00_INSTALLATION.md) | [REST API doc](./docs/01_REST_API_DOC.md) | [Web app screenshots](./docs/02_WEB_APP_SCREENSHOTS.md)

</small>

# ✨ Solid Rails App <!-- omit in toc -->

Web and REST API application made with [Ruby on Rails](https://guides.rubyonrails.org/) + [solid-process](https://github.com/solid-process/solid-process) + [solid-adapters](https://github.com/solid-process/solid-adapters).

## 📚 Table of contents <!-- omit in toc -->

- [💡 Branch summary](#-branch-summary)
- [📣 Important info](#-important-info)

## 💡 Branch summary

This version makes usage of another `Solid::Adapters` feature, the [interface mechanism](https://github.com/solid-process/solid-adapters?tab=readme-ov-file#solidadaptersinterface) to strengthen the contracts between the core and the application. Because of this, the core can [establish](https://github.com/solid-process/solid-rails-app/blob/solid-process-4/lib/core/user/adapters/repository_interface.rb) and [demand](https://github.com/solid-process/solid-rails-app/blob/solid-process-4/lib/core/user/registration.rb#L13) its contracts (ports).

Note: In case of a breach of contract, the system will raise an exception indicating what was compromised and needs to be fixed.

## 📣 Important info

To understand the project's context, I'd like you to please read the [main branch's README](https://github.com/solid-process/solid-rails-app/tree/main?tab=readme-ov-file).

Check out the:
1. [disclaimer](https://github.com/solid-process/solid-rails-app/tree/main?tab=readme-ov-file#-disclaimer) to understand the project's purpose.
2. [summary](https://github.com/solid-process/solid-rails-app/tree/main?tab=readme-ov-file#-repository-branches) of all branches.
3. [highlights](https://github.com/solid-process/solid-rails-app/tree/main?tab=readme-ov-file#-highlights-of-what-solid-process-can-bring-to-youyour-team-) of what solid-process can bring to you/your team.
