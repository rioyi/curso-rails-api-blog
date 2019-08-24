# README

## Rspec

In your project directory:

### Download and install

`$ bundle install`

### Generate boilerplate configuration files

### (check the comments in each generated file for more information)

`$ rails generate rspec:install
      create  .rspec
      create  spec
      create  spec/spec_helper.rb
      create  spec/rails_helper.rb`

Creating boilerplate specs with rails generate

### RSpec hooks into built-in generators

`$ rails generate model user
      invoke  active_record
      create    db/migrate/20181017040312_create_users.rb
      create    app/models/user.rb
      invoke    rspec
      create      spec/models/user_spec.rb`

### RSpec also provides its own spec file generators

`$ rails generate rspec:model user
      create  spec/models/user_spec.rb`

### List all RSpec generators

`$ rails generate --help | grep rspec`

Running specs

### Default: Run all spec files (i.e., those matching spec/**/*_spec.rb)

`$ bundle exec rspec`

### Run all spec files in a single directory (recursively)

`$ bundle exec rspec spec/models`

### Run a single spec file

`$ bundle exec rspec spec/controllers/accounts_controller_spec.rb`

### Run a single example from a spec file (by line number)

`$ bundle exec rspec spec/controllers/accounts_controller_spec.rb:8`

### See all options for running specs

`$ bundle exec rspec --help`
