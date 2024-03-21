# README

* System dependencies
  * Ruby `3.2.3`
    * bundler `>= 2.5.6`
  * Sqlite3

* Configuration
  1. Install the system dependencies
  2. Create the `master.key`
    ```sh
    echo 'a061933f96843c82342fb8ab9e9db503' > config/master.key

    chmod 600 config/master.key
    ```
  3. Run `bin/setup`

* Database creation
  * Run `bin/rails db:setup`

* How to run the test suite
  * `bin/rails test`

* How to run the application locally
  1. `bin/rails s`
  2. Open in your browser: `http://localhost:3000`
