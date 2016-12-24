# NewlineHw

Is a tool to rapidly clone and setup projects in a standard format, this is primarily
used to improving the speed to review homework turned in in a bootcamp like setting.

## Installation

Install from rubygems:

    $ gem install newline_hw

In your .bashrc / .bash_profile / .zshrc

    $ eval "$(newlinehw init)"

## Usage

Once the the eval code has been added to your bash or zsh profile you will have access to the `hw` command.  This is where the majority of the tools use comes into play.

  `hw GIT_REPO`

  Example

  `hw https://github.com/rposborne/countries`

### What it does

_All languages_

1. Clone a repo into ~/theironyard/homework using githubname-reponame
2. Trigger your editor to open. 
3. `cd` current shell into new directory

_Ruby_

1. Run `bundle install`  if `Gemfile` is present

_Rails_

1. `bin/rake db:setup`
2.  Start a rails server / open it in default browser
3.  `bin/rake test`
4.  Reown rails server process so everything behaves as expected.

_Javascript_

1. Run `npm install` when `package.json` present

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/newline_hw. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

