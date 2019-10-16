# MetsConverter

[![Build Status](https://travis-ci.com/nulib/mets_converter.svg)](https://travis-ci.com/nulib/mets_converter)

Convert a mets xml file into a yml file according to the Hathi Trust specifications for ingest. Note: this project was developed to satisfy Northwestern Libraries' specific use case, so many values are hard-coded in `MetsConverter::YamlBuilder#build`.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mets_converter'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mets_converter

Once installed, the `mets_to_yaml` command line utility should be available in your terminal.

## Usage

Run `mets_to_yaml` without any arguments to see help text.

```sh
# Running the mets_to_yaml command
mets_to_yaml [options] input_file output_file_basename
```

```sh
# Example with optional arguments
mets_to_yaml --force --resolution="300" /cygdrive/e/books/limb_output/35556004429411/35556004429411.mets.xml meta

# meta.yml will be created in the same directory as the input file
```

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `bundle exec rspec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nulib/mets_converter. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.
