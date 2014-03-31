# Writing awesome cli tools as Ruby Gems

## Introduction

I am always writing small tools to help me out on a daily basis.  Sometimes shell scripts, but other
times I want something a bit more complex.  When I need more than a simple shell script, I like to
leverage ruby for its vast library of gems which can greatly accelerate and simplify the task of
building these helpful tools.  

This post will give an introduction to writing your own CLI tools in ruby and packaging them as a
gem.  

### Benefits to building gem packaged utilities

  * Gems can install to your $PATH, allowing you to run your utility from anywhere
  * We can leverage a giant library of existing gems to simplify and accelerate development
  * Sharing/distributing your tool becomes extremely easy.
  * When properly designed, a CLI tool can also function as a reusable library for future projects.

### Selected gems

Some of the gems that I use to aid in the process of creating these tools are:

  * Bundler - gem management, packaging, and deployment
  * Thor - 'framework' for building CLI applications
  * Nokogiri - html/xml parsing (great for api clients and web utilities)
  * multi_json - json parsing/creation (great for api clients and web utilities)

### Example application

This post will walk you through a simple example that I threw together.  The example utility is a
tool to query wunderground from your commandline called "wunder-rb".

If you wish to follow along and use this example utility, you will need an API token for
wunderground.

## Getting Started

Ensure that bundler is installed.  If not, `$ gem install bundler` (you may need sudo if you cannot
  install gems locally).

Once you have bundler installed, execute `$ bundle gem mytool`, which creates your basic project
structure for a gem.  For my example, wunder, structure looks like this:

    wunder/Gemfile
    wunder/Rakefile
    wunder/LICENSE.txt
    wunder/README.md
    wunder/.gitignore
    wunder/wunder.gemspec
    wunder/lib/wunder.rb
    wunder/lib/wunder/version.rb
