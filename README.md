<small>

> `MENU` **README** | [How to run locally](./docs/00_INSTALLATION.md) | [REST API doc](./docs/01_REST_API_DOC.md) | [Web app screenshots](./docs/02_WEB_APP_SCREENSHOTS.md)

</small>

# ✨ Solid Rails App <!-- omit in toc -->

Web and REST API application made with [Ruby on Rails](https://guides.rubyonrails.org/) + [solid-process](https://github.com/solid-process/solid-process).

## 📚 Table of contents <!-- omit in toc -->

- [📢 Disclaimer](#-disclaimer)
- [🙌 Repository branches](#-repository-branches)
- [🌟 Highlights of what solid-process can bring to you/your team](#-highlights-of-what-solid-process-can-bring-to-youyour-team)
- [🤔 How can we be aware of critical system processes?](#-how-can-we-be-aware-of-critical-system-processes)
- [👋 About](#-about)

## 📢 Disclaimer

The goal of this project is to demonstrate how the `solid-process` can be gradually integrated into a Rails application.

It's important to note that the **Rails Way** and the **Solid Process** are not mutually exclusive. You can implement the `solid-process` where it best fits your needs, allowing both approaches to coexist harmoniously and beneficially.

That said, this is not an invitation, guide, or recommendation to implement all applications in the more complex manner demonstrated in this project.

I (Rodrigo Serradura) believe in a pragmatic approach using the best tool for the job. The _**vanilla-rails**_ version is excellent and capable of handling all the complexity within this system's scope.

Therefore, view this project as a showcase of what the `solid-process` gem can achieve. You may discover valuable tools to add to your toolbox. Enjoy! ✌️😊

## 🙌 Repository branches

This repository has twelve branches that represent the application's evolution.

The `2.##` branches are percentages that indicate gradual progress toward the next version.

Architectural patterns are applied according to the following criteria:
-  `0` to `2.99` , stays on the **Layered Architecture**.
-  `3` onwards, applies the **Ports and Adapters (_Hexagonal_) Architecture**.

__*Click in the arrows*__ to see the summary of each branch:

<table>
<thead>
<tr>
  <th>Branch</th>
  <th style="text-align:center">LOC / GRADE</th>
</tr>
</thead>
<tbody>
<!-- VERSION: vanilla-rails -->
<tr>
  <td>
  <details>
  <summary>&nbsp;&nbsp;&nbsp;&nbsp;<a href="https://github.com/solid-process/solid-rails-app/blob/vanilla-rails?tab=readme-ov-file#-solid-rails-app-">vanilla-rails</a></summary>

  ---
  It is the base version that implements a web application and REST API using the Rails Way approach. The business rules are mainly implemented around the ActiveRecord lifecycle/features (normalization, validation, callbacks, and macros), which the application controllers orchestrate.

  However, with each new version, these models and controllers will have fewer responsibilities as we implement processes to wrap and orchestrate the core business logic.

  Note: Three concepts differ from a traditional CRUD. Are they:

  1. [Account Member](https://github.com/solid-process/solid-rails-app/blob/vanilla-rails/app/models/account/member.rb): This PORO performs access/scope control in the accounts.

  2. [User Registration](https://github.com/solid-process/solid-rails-app/blob/vanilla-rails/app/models/user.rb#L18-L49): This operation consists of creating the user and its account, defining the user as the account's owner, creating the user API token, and sending an email to confirm the user email.

  3. [User API token](https://github.com/solid-process/solid-rails-app/blob/vanilla-rails/app/models/user_token.rb): This implementation is based on the [prefixed API token concept](https://github.com/seamapi/prefixed-api-key), which consists of a short (public) and a long (encrypted) token.

  **Version samples:**
  - [API Controller](./docs/versions/controller/api/vanilla-rails.rb)
  - [Web Controller](./docs/versions/controller/web/vanilla-rails.rb)

  </details>
  </td>
  <td style="text-align:center">1434 / 94.06</td>
</tr>

<!-- VERSION: solid-process-0 -->
<tr>
  <td>
  <details>
  <summary>&nbsp;&nbsp;&nbsp;&nbsp;<a href="https://github.com/solid-process/solid-rails-app/blob/solid-process-0?tab=readme-ov-file#-solid-rails-app-">solid-process-0</a></summary>

  ---
  Introduces the solid-process gem and implements the application's first process ([User::Registration](https://github.com/solid-process/solid-rails-app/blob/solid-process-0/app/models/user/registration.rb)).

  It shows the low learning curve required to use gem features. Although basic, this implementation removes callbacks from the [User](https://github.com/solid-process/solid-rails-app/blob/solid-process-0/app/models/user.rb) model, as the process will orchestrate all account creation within a transaction and send a confirmation email after its commit.

  **Version samples:**
  - [API Controller](./docs/versions/controller/api/solid-process-0.rb) ([Diff](./docs/versions/controller/api/README.md#vanilla-railssolid-process-0))
  - [Web Controller](./docs/versions/controller/web/solid-process-0.rb) ([Diff](./docs/versions/controller/web/README.md#vanilla-railsrbsolid-process-0))
  - [Process](./docs/versions/model/solid-process-0.rb)

  </details>
  </td>
  <td style="text-align:center">1459 / 94.08</td>
</tr>

<!-- VERSION: solid-process-1 -->
<tr>
  <td>
  <details>
  <summary>&nbsp;&nbsp;&nbsp;&nbsp;<a href="https://github.com/solid-process/solid-rails-app/blob/solid-process-1?tab=readme-ov-file#-solid-rails-app-">solid-process-1</a></summary>

  ---
  Defines types for input attributes and uses steps to perform all operations within a transaction block that will perform a rollback if any step returns a failure. After the commit, the confirmation email is sent, and the created user is exposed in the [User::Registration](https://github.com/solid-process/solid-rails-app/blob/solid-process-1/app/models/user/registration.rb) result.

  Note: In this version, the process input ([User::Registration::Input](https://github.com/solid-process/solid-rails-app/blob/solid-process-1/app/controllers/web/guest/registrations_controller.rb#L6)) is used in the view forms, causing the view to be coupled to it and no longer to the User model (ActiveRecord).

  **Version samples:**
  - [API Controller](./docs/versions/controller/api/solid-process-1.rb) ([Diff](./docs/versions/controller/api/README.md#solid-process-0solid-process-1))
  - [Web Controller](./docs/versions/controller/web/solid-process-1--2.95.rb) ([Diff](./docs/versions/controller/web/README.md#solid-process-0solid-process-1--295))
  - [Process](./docs/versions/model/solid-process-1.rb) ([Diff](./docs/versions/model/README.md#solid-process-0solid-process-1))

  </details>
  </td>
  <td style="text-align:center">1481 / 93.98</td>
</tr>

<!-- VERSION: solid-process-2.00 -->
<tr>
  <td>
  <details>
  <summary>&nbsp;&nbsp;&nbsp;&nbsp;<a href="https://github.com/solid-process/solid-rails-app/blob/solid-process-2.00?tab=readme-ov-file#-solid-rails-app-">solid-process-2.00</a></summary>

  ---
  From version 2 onwards, all contexts (Account and User) implement their operations through processes. Because of this, it becomes possible to create a composition of processes where they are defined as dependencies that will be orchestrated through their steps.

  Notes:

  1. [UserToken](https://github.com/solid-process/solid-rails-app/blob/solid-process-2.00/app/models/user_token.rb) becomes hugely lean because the model's behavior has been diluted into different components within the [User::Token namespace](https://github.com/solid-process/solid-rails-app/tree/solid-process-2.00/app/models/user/token). I am highlighting [User::Token::Entity](https://github.com/solid-process/solid-rails-app/blob/solid-process-2.00/app/models/user/token/entity.rb), a PORO capable of representing a token without the need to interact with the database (ActiveRecord model).

  2. New features are added to input blocks, such as data normalization and validation.

  **Version samples:**
  - [API Controller](./docs/versions/controller/api/solid-process-2.00--2.80.rb) ([Diff](./docs/versions/controller/api/README.md#solid-process-1solid-process-200--280))
  - [Web Controller](./docs/versions/controller/web/solid-process-1--2.95.rb) ([Diff](./docs/versions/controller/web/README.md#solid-process-0solid-process-1--295))
  - [Process](./docs/versions/model/solid-process-2.00.rb) ([Diff](./docs/versions/model/README.md#solid-process-1solid-process-200))

  </details>
  </td>
  <td style="text-align:center">1866 / 93.78</td>
</tr>

<!-- VERSION: solid-process-2.20 -->
<tr>
  <td>
  <details>
  <summary>&nbsp;&nbsp;&nbsp;&nbsp;<a href="https://github.com/solid-process/solid-rails-app/blob/solid-process-2.20?tab=readme-ov-file#-solid-rails-app-">solid-process-2.20</a></summary>

  ---
  If we analyze the previous version, we will see that the ActiveRecord models are not defined within the context of the user or account.

  What this version does is rename the ActiveRecord models as [Record](https://github.com/solid-process/solid-rails-app/blob/solid-process-2.20/app/models/user/record.rb) (for this, it is necessary to define the table_name and class_name in the classes) within the [Account](https://github.com/solid-process/solid-rails-app/tree/solid-process-2.20/app/models/account) and [User](https://github.com/solid-process/solid-rails-app/tree/solid-process-2.20/app/models/user) namespaces (they become mere modules since before both were also an ActiveRecord model)

  **Version samples:**
  - [API Controller](./docs/versions/controller/api/solid-process-2.00--2.80.rb) ([Diff](./docs/versions/controller/api/README.md#solid-process-1solid-process-200--280))
  - [Web Controller](./docs/versions/controller/web/solid-process-1--2.95.rb) ([Diff](./docs/versions/controller/web/README.md#solid-process-0solid-process-1--295))
  - [Process](./docs/versions/model/solid-process-2.20--2.40.rb) ([Diff](./docs/versions/model/README.md#solid-process-200solid-process-220--240))

  </details>
  </td>
  <td style="text-align:center">1894 / 93.74</td>
</tr>

<!-- VERSION: solid-process-2.40 -->
<tr>
  <td>
  <details>
  <summary>&nbsp;&nbsp;&nbsp;&nbsp;<a href="https://github.com/solid-process/solid-rails-app/blob/solid-process-2.40?tab=readme-ov-file#-solid-rails-app-">solid-process-2.40</a></summary>

  ---
  The **vanilla-rails summary** presents the Account::Member as one of the application's most important components. It is responsible for controlling access to the accounts.

  It turns out that although it is a PORO (Solid::Model), its implementation also contains queries (ActiveRecord stuff).

  This version introduces [Account::Member::Repository](https://github.com/solid-process/solid-rails-app/blob/solid-process-2.40/app/models/account/member/repository.rb) to enhance the separation of concerns. This new component/pattern will serve as an abstraction layer for the data source, allowing queries to be moved to it and making the [Account::Member implementation more straightforward and concise](https://github.com/solid-process/solid-rails-app/blob/solid-process-2.40/app/models/account/member.rb).

  **Version samples:**
  - [API Controller](./docs/versions/controller/api/solid-process-2.00--2.80.rb) ([Diff](./docs/versions/controller/api/README.md#solid-process-1solid-process-200--280))
  - [Web Controller](./docs/versions/controller/web/solid-process-1--2.95.rb) ([Diff](./docs/versions/controller/web/README.md#solid-process-0solid-process-1--295))
  - [Process](./docs/versions/model/solid-process-2.20--2.40.rb) ([Diff](./docs/versions/model/README.md#solid-process-200solid-process-220--240))

  </details>
  </td>
  <td style="text-align:center">1904 / 93.80</td>
</tr>

<!-- VERSION: solid-process-2.60 -->
<tr>
  <td>
  <details>
  <summary>&nbsp;&nbsp;&nbsp;&nbsp;<a href="https://github.com/solid-process/solid-rails-app/blob/solid-process-2.60?tab=readme-ov-file#-solid-rails-app-">solid-process-2.60</a></summary>

  ---
  Since version 2.40 introduces the Repository pattern, what would happen if all processes/contexts started using this pattern?

  This version answers this question in practice by introducing a repository for each context and forcing the application to start using them instead of directly using the ActiveRecord models.

  **Version samples:**
  - [API Controller](./docs/versions/controller/api/solid-process-2.00--2.80.rb) ([Diff](./docs/versions/controller/api/README.md#solid-process-1solid-process-200--280))
  - [Web Controller](./docs/versions/controller/web/solid-process-1--2.95.rb) ([Diff](./docs/versions/controller/web/README.md#solid-process-0solid-process-1--295))
  - [Process](./docs/versions/model/solid-process-2.60.rb) ([Diff](./docs/versions/model/README.md#solid-process-220--240solid-process-260))

  </details>
  </td>
  <td style="text-align:center">2144 / 91.14</td>
</tr>

<!-- VERSION: solid-process-2.80 -->
<tr>
  <td>
  <details>
  <summary>&nbsp;&nbsp;&nbsp;&nbsp;<a href="https://github.com/solid-process/solid-rails-app/blob/solid-process-2.80?tab=readme-ov-file#-solid-rails-app-">solid-process-2.80</a></summary>

  ---
  Due to the addition of repositories in the previous version, it is evident that User::Registration and User::AccountDeletion have methods in their repositories that use an Account::Record. In other words, it is clear that User::Record is tightly coupled to Account::Record and should not be.

  To solve this, a new [account_members table](https://github.com/solid-process/solid-rails-app/blob/solid-process-2.80/db/schema.rb#L14-L19) (and model  Account::Member::Record) is created with just one column (uuid), and a column [uuid is also added to the user's table](https://github.com/solid-process/solid-rails-app/blob/solid-process-2.80/db/schema.rb#L73).

  While we won't be using a foreign key, the plan is to start referencing the users' UUID in the account members table. This approach will allow us to transfer several associations from the [User::Record](https://github.com/solid-process/solid-rails-app/blob/solid-process-2.80/app/models/user/record.rb) model to [Account::Member::Record](https://github.com/solid-process/solid-rails-app/blob/solid-process-2.80/app/models/account/member/record.rb), effectively decoupling the User and Account contexts. This will significantly enhance the system's orthogonality, minimizing the risk of changes in one context affecting the other.

  **Version samples:**
  - [API Controller](./docs/versions/controller/api/solid-process-2.00--2.80.rb) ([Diff](./docs/versions/controller/api/README.md#solid-process-1solid-process-200--280))
  - [Web Controller](./docs/versions/controller/web/solid-process-1--2.95.rb) ([Diff](./docs/versions/controller/web/README.md#solid-process-0solid-process-1--295))
  - [Process](./docs/versions/model/solid-process-2.80.rb) ([Diff](./docs/versions/model/README.md#solid-process-260solid-process-280))

  </details>
  </td>
  <td style="text-align:center">2234 / 91.34</td>
</tr>

<!-- VERSION: solid-process-2.95 -->
<tr>
  <td>
  <details>
  <summary>&nbsp;&nbsp;&nbsp;&nbsp;<a href="https://github.com/solid-process/solid-rails-app/blob/solid-process-2.95?tab=readme-ov-file#-solid-rails-app-">solid-process-2.95</a></summary>

  ---
  Once the contexts are more decoupled, the next step is to make the processes start to expose and receive only [entities (POROS)](https://github.com/solid-process/solid-rails-app/blob/solid-process-2.95/app/models/user/entity.rb) and no longer ActiveRecord objects.

  With this approach, each context gains enhanced control over side effects, be it writing or reading. All interactions with the database/ActiveRecord are now wrapped within the repositories, ensuring a more controlled and predictable system behavior.

  **Version samples:**
  - [API Controller](./docs/versions/controller/api/solid-process-2.95.rb) ([Diff](./docs/versions/controller/api/README.md#solid-process-200--280solid-process-295))
  - [Web Controller](./docs/versions/controller/web/solid-process-1--2.95.rb) ([Diff](./docs/versions/controller/web/README.md#solid-process-0solid-process-1--295))
  - [Process](./docs/versions/model/solid-process-2.95--2.99.rb) ([Diff](./docs/versions/model/README.md#solid-process-280solid-process-295--299))

  </details>
  </td>
  <td style="text-align:center">2365 / 91.50</td>
</tr>

<!-- VERSION: solid-process-2.99 -->
<tr>
  <td>
  <details>
  <summary>&nbsp;&nbsp;&nbsp;&nbsp;<a href="https://github.com/solid-process/solid-rails-app/blob/solid-process-2.99?tab=readme-ov-file#-solid-rails-app-">solid-process-2.99</a></summary>

  ---
  This version transforms the User and Account modules into facades. Processes and repositories are now exposed through simple methods. Another benefit is that shared and repeated behavior (such as instantiating entities) can be done through the facade, eliminating duplication and abstracting this complexity from the entry points.

  **Version samples:**
  - [API Controller](./docs/versions/controller/api/solid-process-2.99--4.rb) ([Diff](./docs/versions/controller/api/README.md#solid-process-295solid-process-299--4))
  - [Web Controller](./docs/versions/controller/web/solid-process-2.99--4.rb) ([Diff](./docs/versions/controller/web/README.md#solid-process-1--295solid-process-299--4))
  - [Process](./docs/versions/model/solid-process-2.95--2.99.rb) ([Diff](./docs/versions/model/README.md#solid-process-280solid-process-295--299))

  </details>
  </td>
  <td style="text-align:center">2474 / 92.40</td>
</tr>

<!-- VERSION: solid-process-3 -->
<tr>
  <td>
  <details>
  <summary>&nbsp;&nbsp;&nbsp;&nbsp;<a href="https://github.com/solid-process/solid-rails-app/blob/solid-process-3?tab=readme-ov-file#-solid-rails-app-">solid-process-3</a></summary>

  ---
  This version implements the Ports and Adapters architectural pattern (Hexagonal Architecture).

  In version [2.99](https://github.com/solid-process/solid-rails-app/blob/solid-process-2.99), the account and user namespaces encapsulated the core business logic. They began to receive and expose objects that belonged to them, in other words, objects that did not directly relate to the framework (Rails). Because of this, it becomes feasible to isolate this core outside the app folder; for this reason, these components were moved to [lib/core](https://github.com/solid-process/solid-rails-app/tree/solid-process-3/lib/core). So, through a new lib, [Solid::Adapters](https://github.com/solid-process/solid-adapters) was added, it is possible to use [initializers](https://github.com/solid-process/solid-rails-app/tree/solid-process-3/config/initializers/solid_adapters) to plug the adapters defined in the app folder (framework side) into the core. This way, it becomes protected as the app uses/implements its ports (interfaces).

  **Version samples:**
  - [API Controller](./docs/versions/controller/api/solid-process-2.99--4.rb) ([Diff](./docs/versions/controller/api/README.md#solid-process-295solid-process-299--4))
  - [Web Controller](./docs/versions/controller/web/solid-process-2.99--4.rb) ([Diff](./docs/versions/controller/web/README.md#solid-process-1--295solid-process-299--4))
  - [Process](./docs/versions/model/solid-process-3.rb) ([Diff](./docs/versions/model/README.md#solid-process-295--299solid-process-3))

  </details>
  </td>
  <td style="text-align:center">2527 / 93.42</td>
</tr>

<!-- VERSION: solid-process-4 -->
<tr>
  <td>
  <details>
  <summary>&nbsp;&nbsp;&nbsp;&nbsp;<a href="https://github.com/solid-process/solid-rails-app/blob/solid-process-4?tab=readme-ov-file#-solid-rails-app-">solid-process-4</a></summary>

  ---
  This version makes usage of another `Solid::Adapters` feature, the [interface mechanism](https://github.com/solid-process/solid-adapters?tab=readme-ov-file#solidadaptersinterface) to strengthen the contracts between the core and the application. Because of this, the core can [establish](https://github.com/solid-process/solid-rails-app/blob/solid-process-4/lib/core/user/adapters/repository_interface.rb) and [demand](https://github.com/solid-process/solid-rails-app/blob/solid-process-4/lib/core/user/registration.rb#L13) its contracts (ports).

  Note: In case of a breach of contract, the system will raise an exception indicating what was compromised and needs to be fixed.

  **Version samples:**
  - [API Controller](./docs/versions/controller/api/solid-process-2.99--4.rb) ([Diff](./docs/versions/controller/api/README.md#solid-process-295solid-process-299--4))
  - [Web Controller](./docs/versions/controller/web/solid-process-2.99--4.rb) ([Diff](./docs/versions/controller/web/README.md#solid-process-1--295solid-process-299--4))
  - [Process](./docs/versions/model/solid-process-4.rb) ([Diff](./docs/versions/model/README.md#solid-process-3solid-process-4))

  </details>
  </td>
  <td style="text-align:center">2947 / 93.42</td>
</tr>
</tbody>
</table>

The following commands were used to generate the LOC and GRADE reports:
- **LOC** (lines of code): `bin/rails stats`
- **GRADE** (code quality): `bin/rails rubycritic`

<p align="right"><a href="#-table-of-contents-">⬆ back to top</a></p>

## 🌟 Highlights of what solid-process can bring to you/your team

1. The [`solid-process`](https://github.com/solid-process/solid-process) uses Rails's known components, such as ActiveModel attributes, validations, callbacks, and more. This way, you can use the same tools you are already familiar with.

2. A way for representing/writing critical system operations. It feels like having code that documents itself. You can see the operation's steps, inputs, outputs, side effects, and more in one place.

3. A less coupled codebase, given that this structure encourages the creation of cohesive operations (with a specific purpose), thus reducing the concentration of logic in ActiveRecord models and/or controllers.

4. Standardization of instrumentation and observability of what occurs within each process (Implement a listener to do this automatically and transparently for the developer [[1]](https://github.com/solid-process/solid-rails-app/blob/solid-process-2.00/config/initializers/solid_process.rb)). This will help you better understand what is happening within the system.

    <details open>
    <summary><strong><a href="https://github.com/solid-process/solid-rails-app/blob/solid-process-2.00/app/models/user/registration.rb" target="_blank">User::Registration</a></strong> event logs sample (output from solid-process-2.00 branch)</summary>

    ```
    #0 User::Registration
    * Given(email:, password:, password_confirmation:)
    * Continue() from method: check_if_email_is_taken
    * Continue(user:) from method: create_user
    * Continue(account:) from method: create_user_account
      #1 Account::Task::List::Creation
       * Given(name:, inbox:, account:)
       * Continue(task_lists:) from method: fetch_task_lists_relation
       * Continue() from method: validate_uniqueness_if_inbox
       * Continue(task_list:) from method: create_task_list
       * Success(:task_list_created, task_list:)
    * Continue() from method: create_user_inbox
      #2 User::Token::Creation
       * Given(user:, token:)
       * Continue() from method: validate_token
       * Continue() from method: check_token_existance
       * Continue(token:) from method: create_token_if_not_exists
       * Success(:token_created, token:)
    * Continue() from method: create_user_token
    * Continue() from method: send_email_confirmation
    * Success(:user_registered, user:)
    ```

    </details>

5. The file structure reveals the system's critical processes, making it easier to understand its behavior and find where to make changes. Check out the [app/models](https://github.com/solid-process/solid-rails-app/blob/solid-process-2.00/app/models) directory.

    <details open>
    <summary><code>app/models</code> file structure (output from solid-process-2.00 branch)</summary>

    ```sh
    app/models
    ├── account
    │  ├── member.rb
    │  └── task
    │     ├── item
    │     │  ├── completion.rb
    │     │  ├── creation.rb
    │     │  ├── deletion.rb
    │     │  ├── finding.rb
    │     │  ├── incomplete.rb
    │     │  ├── listing.rb
    │     │  └── updating.rb
    │     └── list
    │        ├── creation.rb
    │        ├── deletion.rb
    │        ├── finding.rb
    │        ├── listing.rb
    │        └── updating.rb
    ├── user
    │  ├── account_deletion.rb
    │  ├── authentication.rb
    │  ├── email.rb
    │  ├── password
    │  │  ├── resetting.rb
    │  │  ├── sending_reset_instructions.rb
    │  │  └── updating.rb
    │  ├── password.rb
    │  ├── registration.rb
    │  └── token
    │     ├── creation.rb
    │     ├── entity.rb
    │     ├── long_value.rb
    │     ├── refreshing.rb
    │     └── short_value.rb
    └── ...
    ```

    </details>

<p align="right"><a href="#-table-of-contents-">⬆ back to top</a></p>

## 🤔 How can we be aware of critical system processes?

Adding a new folder under `app` is more common to focus on different patterns, such as `services`, `operations`, `queries`, etc. However, because of this idea of ​​putting processes inside the `app/models` directory, it can be argued that knowing what and where they are will be challenging.

To address this need, you can use the below command to list all existing processes in the application ([this task](https://github.com/solid-process/solid-rails-app/blob/solid-process-2.00/lib/tasks/solid_process.rake) is available on all solid-process-* branches).

<details open>
<summary><code>bin/rails solid:processes</code> (output from solid-process-2.00 branch)</summary>

```sh
Lines:
  27 ./app/models/user/token/refreshing.rb
  37 ./app/models/user/token/creation.rb
  31 ./app/models/user/password/updating.rb
  30 ./app/models/user/password/sending_reset_instructions.rb
  37 ./app/models/user/password/resetting.rb
  23 ./app/models/user/authentication.rb
  20 ./app/models/user/account_deletion.rb
  84 ./app/models/user/registration.rb
  54 ./app/models/account/task/item/updating.rb
  15 ./app/models/account/task/item/deletion.rb
  27 ./app/models/account/task/item/listing.rb
  15 ./app/models/account/task/item/incomplete.rb
  25 ./app/models/account/task/item/creation.rb
  15 ./app/models/account/task/item/completion.rb
  23 ./app/models/account/task/item/finding.rb
  29 ./app/models/account/task/list/updating.rb
  15 ./app/models/account/task/list/deletion.rb
  17 ./app/models/account/task/list/listing.rb
  40 ./app/models/account/task/list/creation.rb
  23 ./app/models/account/task/list/finding.rb
  587 total

Files: 20
```

<p align="right"><a href="#-table-of-contents-">⬆ back to top</a></p>

## 👋 About

[Rodrigo Serradura](https://rodrigoserradura.com/) created this project. He is the creator of Solid Process, among other projects similar to this, such as ["from fat controllers to use cases"](https://github.com/serradura/from-fat-controllers-to-use-cases) and ["todo-bcdd"](https://github.com/serradura/todo-bcdd). These other two were made with an ecosystem before solid-process ([u-case](https://github.com/serradura/u-case), [kind](https://github.com/serradura/kind) - which will be archived).

The primary goal of this project is to create an application that reflects the new ecosystem's capabilities, a product of collective learning over the years. This learning journey was enriched by technical knowledge and the invaluable contributions of the Ruby/Rails community (with special mention to the [Ada.rb](https://adarb.org/) community).

Within the Rails community, we have people at different career stages and companies in different phases (validating idea, refining, scaling product); the objective of Solid Process is to be able to follow each of these stages (whether of people or companies that are made up of people). Rails is notoriously known for maximizing development speed. With this in mind, the idea is to have a set of gems that adhere to [its principles and values](https://rubyonrails.org/doctrine) ​​and add value when implementing business/domain logic.

In other words, the gem was created to implement simple services/form objects and even something more complex and decoupled from the framework, such as ports and adapters. All this without fighting and harming the use of Rails. On the contrary, the objective is the difficult task of adding to what is already extremely good (Rails rocks!!! 🤘😎)

<p align="right"><a href="#-table-of-contents-">⬆ back to top</a></p>
