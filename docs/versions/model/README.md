# Diff <!-- omit from toc -->

Listed from latest to earliest versions.

- [solid-process-3..solid-process-4](#solid-process-3solid-process-4)
- [solid-process-2.95--2.99..solid-process-3](#solid-process-295--299solid-process-3)
- [solid-process-2.80..solid-process-2.95--2.99](#solid-process-280solid-process-295--299)
- [solid-process-2.60..solid-process-2.80](#solid-process-260solid-process-280)
- [solid-process-2.20--2.40..solid-process-2.60](#solid-process-220--240solid-process-260)
- [solid-process-2.00..solid-process-2.20--2.40](#solid-process-200solid-process-220--240)
- [solid-process-1..solid-process-2.00](#solid-process-1solid-process-200)
- [solid-process-0..solid-process-1](#solid-process-0solid-process-1)

## solid-process-3..solid-process-4

```diff
     attribute :repository, default: -> { User::Adapters.repository }
     attribute :temporary_token, default: -> { User::Adapters.temporary_token }

-    validates :mailer, respond_to: [:send_email_confirmation]
-    validates :repository, respond_to: [:create!, :exists?]
-    validates :temporary_token, respond_to: [:to]
+    validates :mailer, kind_of: User::Adapters::MailerInterface
+    validates :repository, kind_of: User::Adapters::RepositoryInterface
+    validates :temporary_token, kind_of: User::Adapters::TemporaryTokenInterface
   end

   input do
```

<p align="right"><a href="#diff-">⬆ back to top</a></p>

## solid-process-2.95--2.99..solid-process-3

```diff
     attribute :token_creation, default: User::Token::Creation
     attribute :account_creation, default: Account::Member::OwnerCreation

-    attribute :mailer, default: UserMailer
-    attribute :repository, default: User::Repository
-    attribute :temporary_token, default: User::TemporaryToken
+    attribute :mailer, default: -> { User::Adapters.mailer }
+    attribute :repository, default: -> { User::Adapters.repository }
+    attribute :temporary_token, default: -> { User::Adapters.temporary_token }

-    validates :repository, respond_to: [:exists?, :create!]
+    validates :mailer, respond_to: [:send_email_confirmation]
+    validates :repository, respond_to: [:create!, :exists?]
     validates :temporary_token, respond_to: [:to]
   end

@@ -73,7 +74,7 @@
   def send_email_confirmation(user:, **)
     token = deps.temporary_token.to(:email_confirmation, user)

-    deps.mailer.with(token:, email: user.email).email_confirmation.deliver_later
+    deps.mailer.send_email_confirmation(token:, email: user.email)

     Continue()
   end
```

<p align="right"><a href="#diff-">⬆ back to top</a></p>

## solid-process-2.80..solid-process-2.95--2.99

```diff
 class User::Registration < Solid::Process
   deps do
-    attribute :mailer, default: UserMailer
-    attribute :repository, default: User::Repository
     attribute :token_creation, default: User::Token::Creation
     attribute :account_creation, default: Account::Member::OwnerCreation

+    attribute :mailer, default: UserMailer
+    attribute :repository, default: User::Repository
+    attribute :temporary_token, default: User::TemporaryToken
+
     validates :repository, respond_to: [:exists?, :create!]
+    validates :temporary_token, respond_to: [:to]
   end

   input do
@@ -34,7 +37,7 @@
         .and_then(:create_user_token)
     }
       .and_then(:send_email_confirmation)
-      .and_expose(:user_registered, [:user])
+      .and_expose(:user_registered, [:user, :user_token])
   end

   private
@@ -63,15 +66,14 @@

   def create_user_token(user:, **)
     case deps.token_creation.call(user:)
-    in Solid::Success then Continue()
+    in Solid::Success(token:) then Continue(user_token: token.value)
     end
   end

   def send_email_confirmation(user:, **)
-    deps.mailer.with(
-      user:,
-      token: user.generate_token_for(:email_confirmation)
-    ).email_confirmation.deliver_later
+    token = deps.temporary_token.to(:email_confirmation, user)
+
+    deps.mailer.with(token:, email: user.email).email_confirmation.deliver_later

     Continue()
   end
```

<p align="right"><a href="#diff-">⬆ back to top</a></p>

## solid-process-2.60..solid-process-2.80

```diff
     attribute :mailer, default: UserMailer
     attribute :repository, default: User::Repository
     attribute :token_creation, default: User::Token::Creation
-    attribute :task_list_creation, default: Account::Task::List::Creation
+    attribute :account_creation, default: Account::Member::OwnerCreation

-    validates :repository, respond_to: [:exists?, :create!, :create_account!]
+    validates :repository, respond_to: [:exists?, :create!]
   end

   input do
+    attribute :uuid, :string, default: -> { ::UUID.generate }
     attribute :email, :string
     attribute :password, :string
     attribute :password_confirmation, :string
@@ -18,6 +19,7 @@
     end

     with_options presence: true do
+      validates :uuid, format: ::UUID::REGEXP
       validates :email, format: User::Email::REGEXP
       validates :password, confirmation: true, length: {minimum: User::Password::MINIMUM_LENGTH}
     end
@@ -29,7 +31,6 @@
         .and_then(:check_if_email_is_taken)
         .and_then(:create_user)
         .and_then(:create_user_account)
-        .and_then(:create_user_inbox)
         .and_then(:create_user_token)
     }
       .and_then(:send_email_confirmation)
@@ -44,8 +45,8 @@
     input.errors.any? ? Failure(:invalid_input, input:) : Continue()
   end

-  def create_user(email:, password:, password_confirmation:, **)
-    case deps.repository.create!(email:, password:, password_confirmation:)
+  def create_user(uuid:, email:, password:, password_confirmation:, **)
+    case deps.repository.create!(uuid:, email:, password:, password_confirmation:)
     in Solid::Success(user:) then Continue(user:)
     in Solid::Failure(user:)
       input.errors.merge!(user.errors)
@@ -55,20 +56,14 @@
   end

   def create_user_account(user:, **)
-    result = deps.repository.create_account!(user:)
-
-    Continue(account: result[:account])
+    case deps.account_creation.call(uuid: user.uuid)
+    in Solid::Success then Continue()
   end
-
-  def create_user_inbox(account:, **)
-    case deps.task_list_creation.call(account:, inbox: true)
-    in Solid::Success(task_list:) then Continue()
     end
-  end

   def create_user_token(user:, **)
     case deps.token_creation.call(user:)
-    in Solid::Success(token:) then Continue()
+    in Solid::Success then Continue()
     end
   end
```

<p align="right"><a href="#diff-">⬆ back to top</a></p>

## solid-process-2.20--2.40..solid-process-2.60

```diff
 class User::Registration < Solid::Process
   deps do
     attribute :mailer, default: UserMailer
+    attribute :repository, default: User::Repository
     attribute :token_creation, default: User::Token::Creation
     attribute :task_list_creation, default: Account::Task::List::Creation
+
+    validates :repository, respond_to: [:exists?, :create!, :create_account!]
   end

   input do
@@ -36,27 +39,25 @@
   private

   def check_if_email_is_taken(email:, **)
-    input.errors.add(:email, "has already been taken") if User::Record.exists?(email:)
+    input.errors.add(:email, "has already been taken") if deps.repository.exists?(email:)

     input.errors.any? ? Failure(:invalid_input, input:) : Continue()
   end

   def create_user(email:, password:, password_confirmation:, **)
-    user = User::Record.create(email:, password:, password_confirmation:)
-
-    return Continue(user:) if user.persisted?
-
+    case deps.repository.create!(email:, password:, password_confirmation:)
+    in Solid::Success(user:) then Continue(user:)
+    in Solid::Failure(user:)
       input.errors.merge!(user.errors)

       Failure(:invalid_input, input:)
     end
+  end

   def create_user_account(user:, **)
-    account = Account::Record.create!(uuid: SecureRandom.uuid)
+    result = deps.repository.create_account!(user:)

-    account.memberships.create!(user:, role: :owner)
-
-    Continue(account:)
+    Continue(account: result[:account])
   end

   def create_user_inbox(account:, **)
```

<p align="right"><a href="#diff-">⬆ back to top</a></p>

## solid-process-2.00..solid-process-2.20--2.40

```diff
   private

   def check_if_email_is_taken(email:, **)
-    input.errors.add(:email, "has already been taken") if User.exists?(email:)
+    input.errors.add(:email, "has already been taken") if User::Record.exists?(email:)

     input.errors.any? ? Failure(:invalid_input, input:) : Continue()
   end

   def create_user(email:, password:, password_confirmation:, **)
-    user = User.create(email:, password:, password_confirmation:)
+    user = User::Record.create(email:, password:, password_confirmation:)

     return Continue(user:) if user.persisted?

@@ -52,7 +52,7 @@
   end

   def create_user_account(user:, **)
-    account = Account.create!(uuid: SecureRandom.uuid)
+    account = Account::Record.create!(uuid: SecureRandom.uuid)

     account.memberships.create!(user:, role: :owner)
```

<p align="right"><a href="#diff-">⬆ back to top</a></p>

## solid-process-1..solid-process-2.00

```diff
 class User::Registration < Solid::Process
+  deps do
+    attribute :mailer, default: UserMailer
+    attribute :token_creation, default: User::Token::Creation
+    attribute :task_list_creation, default: Account::Task::List::Creation
+  end
+
   input do
     attribute :email, :string
     attribute :password, :string
     attribute :password_confirmation, :string
+
+    before_validation do
+      self.email = email.downcase.strip
     end

+    with_options presence: true do
+      validates :email, format: User::Email::REGEXP
+      validates :password, confirmation: true, length: {minimum: User::Password::MINIMUM_LENGTH}
+    end
+  end
+
   def call(attributes)
     rollback_on_failure {
       Given(attributes)
+        .and_then(:check_if_email_is_taken)
         .and_then(:create_user)
         .and_then(:create_user_account)
         .and_then(:create_user_inbox)
@@ -19,6 +35,12 @@

   private

+  def check_if_email_is_taken(email:, **)
+    input.errors.add(:email, "has already been taken") if User.exists?(email:)
+
+    input.errors.any? ? Failure(:invalid_input, input:) : Continue()
+  end
+
   def create_user(email:, password:, password_confirmation:, **)
     user = User.create(email:, password:, password_confirmation:)

@@ -38,19 +60,19 @@
   end

   def create_user_inbox(account:, **)
-    account.task_lists.inbox.create!
-
-    Continue()
+    case deps.task_list_creation.call(account:, inbox: true)
+    in Solid::Success(task_list:) then Continue()
     end
+  end

   def create_user_token(user:, **)
-    user.create_token!
-
-    Continue()
+    case deps.token_creation.call(user:)
+    in Solid::Success(token:) then Continue()
     end
+  end

   def send_email_confirmation(user:, **)
-    UserMailer.with(
+    deps.mailer.with(
       user:,
       token: user.generate_token_for(:email_confirmation)
     ).email_confirmation.deliver_later
```

<p align="right"><a href="#diff-">⬆ back to top</a></p>

## solid-process-0..solid-process-1

```diff
 class User::Registration < Solid::Process
   input do
-    attribute :email
-    attribute :password
-    attribute :password_confirmation
+    attribute :email, :string
+    attribute :password, :string
+    attribute :password_confirmation, :string
   end

   def call(attributes)
-    user = User.new(attributes)
+    rollback_on_failure {
+      Given(attributes)
+        .and_then(:create_user)
+        .and_then(:create_user_account)
+        .and_then(:create_user_inbox)
+        .and_then(:create_user_token)
+    }
+      .and_then(:send_email_confirmation)
+      .and_expose(:user_registered, [:user])
+  end

-    return Failure(:invalid_user, user:) if user.invalid?
+  private

-    ActiveRecord::Base.transaction do
-      user.save!
+  def create_user(email:, password:, password_confirmation:, **)
+    user = User.create(email:, password:, password_confirmation:)

+    return Continue(user:) if user.persisted?
+
+    input.errors.merge!(user.errors)
+
+    Failure(:invalid_input, input:)
+  end
+
+  def create_user_account(user:, **)
       account = Account.create!(uuid: SecureRandom.uuid)

-      account.memberships.create!(user: user, role: :owner)
+    account.memberships.create!(user:, role: :owner)

+    Continue(account:)
+  end
+
+  def create_user_inbox(account:, **)
     account.task_lists.inbox.create!

+    Continue()
+  end
+
+  def create_user_token(user:, **)
     user.create_token!
+
+    Continue()
   end

+  def send_email_confirmation(user:, **)
     UserMailer.with(
-      user: user,
+      user:,
       token: user.generate_token_for(:email_confirmation)
     ).email_confirmation.deliver_later

-    Success(:user_registered, user: user)
+    Continue()
   end
 end
```

<p align="right"><a href="#diff-">⬆ back to top</a></p>
