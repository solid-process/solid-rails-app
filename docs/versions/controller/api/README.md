# Diff <!-- omit from toc -->

Listed from latest to earliest versions.

- [solid-process-2.95..solid-process-2.99--4](#solid-process-295solid-process-299--4)
- [solid-process-2.00--2.80..solid-process-2.95](#solid-process-200--280solid-process-295)
- [solid-process-1..solid-process-2.00--2.80](#solid-process-1solid-process-200--280)
- [solid-process-0..solid-process-1](#solid-process-0solid-process-1)
- [vanilla-rails..solid-process-0](#vanilla-railssolid-process-0)

## solid-process-2.95..solid-process-2.99--4

```diff
     skip_before_action :authenticate_user!, only: [:create]

     def create
-      case ::User::Registration.call(user_params)
+      case ::User.register(user_params)
       in Solid::Success(user_token:)
         render_json_with_success(status: :created, data: {user_token:})
       in Solid::Failure(input:)
@@ -12,7 +12,7 @@
     end

     def destroy
-      result = ::User::AccountDeletion.call(user: current_user)
+      result = ::User.delete_account(user: current_user)

       result.account_deleted? and return render_json_with_success(status: :ok)
     end
```

<p align="right"><a href="#diff-">⬆ back to top</a></p>


## solid-process-2.00--2.80..solid-process-2.95

```diff
     def create
       case ::User::Registration.call(user_params)
-      in Solid::Success(user:)
-        render_json_with_success(status: :created, data: {user_token: user.token.value})
+      in Solid::Success(user_token:)
+        render_json_with_success(status: :created, data: {user_token:})
       in Solid::Failure(input:)
         render_json_with_model_errors(input)
       end
```

<p align="right"><a href="#diff-">⬆ back to top</a></p>

## solid-process-1..solid-process-2.00--2.80

```diff
     end

     def destroy
-      current_user.destroy!
+      result = ::User::AccountDeletion.call(user: current_user)

-      render_json_with_success(status: :ok)
+      result.account_deleted? and return render_json_with_success(status: :ok)
     end

     private
```

<p align="right"><a href="#diff-">⬆ back to top</a></p>

## solid-process-0..solid-process-1

```diff
       case ::User::Registration.call(user_params)
       in Solid::Success(user:)
         render_json_with_success(status: :created, data: {user_token: user.token.value})
-      in Solid::Failure(user:)
-        render_json_with_model_errors(user)
+      in Solid::Failure(input:)
+        render_json_with_model_errors(input)
       end
     end
```

<p align="right"><a href="#diff-">⬆ back to top</a></p>

## vanilla-rails..solid-process-0

```diff
     skip_before_action :authenticate_user!, only: [:create]

     def create
-      user = ::User.new(user_params)
-
-      if user.save
+      case ::User::Registration.call(user_params)
+      in Solid::Success(user:)
         render_json_with_success(status: :created, data: {user_token: user.token.value})
-      else
+      in Solid::Failure(user:)
         render_json_with_model_errors(user)
       end
     end
```

<p align="right"><a href="#diff-">⬆ back to top</a></p>
