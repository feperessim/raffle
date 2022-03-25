# README

## Raffle API

### Task description

[Raffle Challenge](https://gist.github.com/romulostorel/b18e39e350362fe99d712e31de74184d)

### Dependencies

`Ruby ~> 3.1.0`
`Bundler ~> 2.3.8`

### Setup

```
$ bundle install
$ bundle exec rails db:create db:migrate
$ mv .env.example .env
```
After this step, replace 'your_token_here' by your token in .env file

### Testing

```
$ bundle exec rspec
```
