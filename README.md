<small>

> `MENU` **README** | [How to run locally](./docs/00_INSTALLATION.md) | [REST API doc](./docs/01_REST_API_DOC.md) | [Web app screenshots](./docs/02_WEB_APP_SCREENSHOTS.md)

</small>

# ✨ Solid Rails App <!-- omit in toc -->

Web and REST API application made with [Ruby on Rails](https://guides.rubyonrails.org/) + [solid-process](https://github.com/solid-process/solid-process).

## 📚 Table of contents <!-- omit in toc -->

- [💡 Branch summary](#-branch-summary)
- [📣 Important info](#-important-info)

## 💡 Branch summary

Due to the addition of repositories in the [previous version](https://github.com/solid-process/solid-rails-app/blob/solid-process-2.60), it is evident that User::Registration and User::AccountDeletion have methods in their repositories that use an Account::Record. In other words, it is clear that User::Record is tightly coupled to Account::Record and should not be.

To solve this, a new [account_members table](https://github.com/solid-process/solid-rails-app/blob/solid-process-2.80/db/schema.rb#L14-L19) (and model  Account::Member::Record) is created with just one column (uuid), and a column [uuid is also added to the user's table](https://github.com/solid-process/solid-rails-app/blob/solid-process-2.80/db/schema.rb#L73).

While we won't be using a foreign key, the plan is to start referencing the users' UUID in the account members table. This approach will allow us to transfer several associations from the [User::Record](https://github.com/solid-process/solid-rails-app/blob/solid-process-2.80/app/models/user/record.rb) model to [Account::Member::Record](https://github.com/solid-process/solid-rails-app/blob/solid-process-2.80/app/models/account/member/record.rb), effectively decoupling the User and Account contexts. This will significantly enhance the system's orthogonality, minimizing the risk of changes in one context affecting the other.

## 📣 Important info

To understand the project's context, I'd like you to please read the [main branch's README](https://github.com/solid-process/solid-rails-app/tree/main?tab=readme-ov-file).

Check out the:
1. [disclaimer](https://github.com/solid-process/solid-rails-app/tree/main?tab=readme-ov-file#-disclaimer) to understand the project's purpose.
2. [summary](https://github.com/solid-process/solid-rails-app/tree/main?tab=readme-ov-file#-repository-branches) of all branches.
3. [highlights](https://github.com/solid-process/solid-rails-app/tree/main?tab=readme-ov-file#-highlights-of-what-solid-process-can-bring-to-youyour-team-) of what solid-process can bring to you/your team.
