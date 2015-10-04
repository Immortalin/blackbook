# Blackbook: A Membership System for Elixir

This is the machinery behind an authentication system and is still a bit of a work in progress. You can still do the basics (register, authenticate) and have logs that go along with each. You can tweak statuses and also login using different services if you have OAuth plumbed into your app.

This is the backing store.

## Installing

First, drop Blackbook in your dependencies:

```
[{:blackbook, ">= 0.1.0"}]
```

And then add it to your apps:

```
[applications: [:blackbook]]
```

Next setup `config/dev.exs` (and the other environments) to tell Ecto where your DB is:

```
config :blackbook, Blackbook.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "bigmachine_dev",
  username: "rob"
```

Add `:blackbook` to your supervision tree to it starts up and then migrate the database:


```
mix blackbook.install
```

This will use your config settings and migrate the membership bits to the database. Once this is done, you're all set.

## Some Notes

I'm not an ORM person, and I don't particularly care for migrations. However I find that if the project is small enough that neither get in my way, so I chose to use Ecto. You'll find many things in this library are **specific to Postgres**, which is the system I built it on.

If you find any issues please let me know.

Also, this is one of my very first Elixir projects and there is likely tons of room for improvement. If you'd like to suggest changes please do!

## Basic Usage

I've tried to make this as simple as I possibly can. Here's the core of it:


### Registration

All you need for registration is an email address and a matching set of passwords. Currently the password checks are pretty free,
but if you want to tweak that you can easily do so in the `registration.exs` file in `/lib`. The package I used is [Comeonin](https://github.com/elixircnx/comeonin) which is pretty configurable.

```
{:ok, new_user} = Blackbook.Regstration.submit_application [email: 'test@test.com', password: 'password', confirm: 'password']
```

### Authentication

There are two ways to authenticate, the first is by email/password and the second is by some kind of service, like an OAuth link or whatever. You can tweak this as you like but the defaults are email/password and token:

```
{:ok, user} = Blackbook.Authentication.authenticate_by_email_password 'test@test.com', 'password'
{:ok, user} = Blackbook.Authentication.authenticate_by_token 'BIGLONGTOKEN'
```

### Changing Password

Does what it says. You have to provide both old and new password.

```
{:ok, user} = Blackbook.Authentication.change_password 'test@test.com', 'password', 'new_password'
```

### Password Reminders

Ask for a token for a user and it will reset that token and the expiration of that token:

```
token = Blackbook.Authentication.get_reminder_token 'test@test.com'
```

Pass that to the user in an email or whatever, then when they come back to validate you can ask if it's valid. You'll get the user record back if everything is OK.

```
{:ok, user} = Blackbook.Authentication.validate_password_reset 'test@test.com'
```

## Current User

How you store the current user token is up to you and your app, but there is a unique token that will identify the user that you can store on the client if you like:

```
{:ok, user} = Blackbook.Authentication.get_user 'MY_USER_KEY'
```

## Extend As You Wish

The models are all available to you, as is the Repo so have a good time:

 - `Blackbook.User` - the core user model
 - `Blackbook.Login` - the validation bits for locating and retrieving a user
 - `Blackbook.UserLog` - if you want to log something just pop a record in here
 - `Blackbook.Repo` - the Ecto repo used in the app

 
