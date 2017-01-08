# NewlineHw
[![Build Status](https://travis-ci.org/TIYDC/newline_hw.svg?branch=master)](https://travis-ci.org/TIYDC/newline_hw)

Is a tool to rapidly clone and setup projects in a standard format, this is primarily
used to improving the speed to review homework turned in during a bootcamp setting.

## Installation

Install from rubygems:

    $ gem install newline_hw

Run to install the config file and chrome integration.

    $ newline_hw install

In your .bashrc / .bash_profile / .zshrc **THIS IS VERY REQUIRED**

    $ eval "$(newline_hw init)"

## Usage

Once the the eval code has been added to your bash or zsh profile you will have access to the `hw` command.  This is where the majority of the tools use comes into play.

  `hw GIT_REPO`

  Example

  Newline Assignment Submission ID
  `hw 30698`

  Github Repo

  `hw https://github.com/rposborne/countries`

  Pull Request

  `hw https://github.com/hexorx/countries/pull/416`

  Gist

  `hw https://gist.github.com/alirobe/7f3b34ad89a159e6daa1`

  Any Git URL

  `hw git@bitbucket.org:pzolee/tcpserver.git`

### Configuration

User specific configuration is stored in a yaml file at the HOME path for a user.

Quickly edit this config in your editor by running this command.

`newline_hw config`

To see all possible config options go to [lib/newline_hw/config.rb](lib/newline_hw/config.rb)

### What it does

_All languages_

1. Clone a git-url/repo/gist/pull-request into ~/theironyard/homework by default using githubname-reponame
2. Trigger your editor to open.
3. `cd` current shell into new directory

_Ruby_

1. Run `bundle install`  if `Gemfile` is present

_Rails_

1. `bin/rake db:setup`
2.  Start a rails server / open it in default browser
3.  `bin/rake test`
4.  Reown rails server process so everything behaves as expected.
5.  Tell spring die when it needs to die.

_Javascript_

1. Run `npm install` when `package.json` present and no yarn file
1. Run `yarn install` when `yarn.lock` present

## TIYO-Assistant Integration

This provides a message bus to allow TIYO assistant to send json to our local binary. This is used to open a terminal window (Apple Terminal or iTerm2) using appleScript and start a `hw <submission-id>` command.  We use the NewlineCli to backfill data required to run the remainder of the commands.

1. You MUST be on a MAC (hope to drop this in the future)
1. You MUST have `newline_cli` installed
2. You MUST be running a ruby 2.3 or higher
3. You MUST have that ruby either in the system loadpath or use, rbenv, rvm, or chruby.
4. THIS IS ALPHA so please send logs.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/TIYDC/newline_hw. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
