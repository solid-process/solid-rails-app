# Diff <!-- omit from toc -->

Listed from latest to earliest versions.

- [solid-process-1--2.95..solid-process-2.99--4](#solid-process-1--295solid-process-299--4)
- [solid-process-0..solid-process-1--2.95](#solid-process-0solid-process-1--295)
- [vanilla-rails.rb..solid-process-0](#vanilla-railsrbsolid-process-0)

# solid-process-1--2.95..solid-process-2.99--4

```diff
 module Web::Guest
   class RegistrationsController < BaseController
     def new
-      render("web/guest/registrations/new", locals: {user: ::User::Registration::Input.new})
+      render("web/guest/registrations/new", locals: {user: ::User.register.input.new})
     end

     def create
-      case ::User::Registration.call(registrations_params)
+      case ::User.register(registrations_params)
       in Solid::Success(user:)
         sign_in(user)
```

<p align="right"><a href="#diff-">⬆ back to top</a></p>

# solid-process-0..solid-process-1--2.95

```diff
 module Web::Guest
   class RegistrationsController < BaseController
     def new
-      render("web/guest/registrations/new", locals: {user: ::User.new})
+      render("web/guest/registrations/new", locals: {user: ::User::Registration::Input.new})
     end

     def create
@@ -10,8 +10,8 @@
         sign_in(user)

         redirect_to web_task_items_path, notice: "You have successfully registered!"
-      in Solid::Failure(user:)
-        render("web/guest/registrations/new", locals: {user:}, status: :unprocessable_entity)
+      in Solid::Failure(input:)
+        render("web/guest/registrations/new", locals: {user: input}, status: :unprocessable_entity)
       end
     end
```

<p align="right"><a href="#diff-">⬆ back to top</a></p>

# vanilla-rails.rb..solid-process-0

```diff
     def create
-      user = ::User.new(registrations_params)
-
-      if user.save
+      case ::User::Registration.call(registrations_params)
+      in Solid::Success(user:)
         sign_in(user)

         redirect_to web_task_items_path, notice: "You have successfully registered!"
-      else
+      in Solid::Failure(user:)
         render("web/guest/registrations/new", locals: {user:}, status: :unprocessable_entity)
       end
     end
```

<p align="right"><a href="#diff-">⬆ back to top</a></p>
