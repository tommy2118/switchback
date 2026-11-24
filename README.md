# Switchback

A small Rails 8.1 app where hikers leave notes about the trails they just walked. It's the app the
[Understanding Rails](https://rails.vetmgmedia.com) series films, and the codebase its "On the job" tickets are
worked in. The trails, hikers and notes are invented.

## Run it

You need Ruby 4.0.10 (see `.ruby-version`).

```sh
bin/setup
```

That installs the gems, prepares the database, loads the seeds and starts the server at http://localhost:3000.
Sign in as `sam@switchback.test` with the password `switchback-hiker`. Eagle Ridge Loop is trail 42.

## Check it

```sh
bin/ci
```

Runs the style check, the security audits and the tests, as CI does on every push.
