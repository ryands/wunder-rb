# Writing awesome cli tools as Ruby Gems - Part I

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

### Example application

This post will walk you through a simple example that I threw together.  The example utility is a
tool to query wunderground from your commandline called "[wunder]".

If you wish to follow along and use this example utility, you will need an API token for
wunderground.

## Getting Started

Ensure that [bundler] is installed.  If not, `$ gem install bundler` (you may need sudo if you cannot
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

### Organization

You should put all of your source files in `lib/` within modules named for your gem. Looking to the
example, you will notice that everything within `lib/` is inside of the Wunder module.  This keeps
everything separate and organized for future use, and does not pollute your ruby's load path.

#### Executables

The whole point of building a CLI tool is to have an executable command in your path once it is
installed.  My preferred approach is to build a single executable per gem that takes subcommands as
arguments.  That executable is placed in `bin/` and is executable.

In our example, `wunder-rb/bin/wunder` is the executable.  To make your script executable run
`$ chmod +x bin/myexecutable`.

The *gemspec* (`wunder.gemspec`) declares files in `bin/` to be executable with this line:

    spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }


## Selected gems

Some of the gems that I use to aid in the process of creating these tools are:

  * [Bundler] - gem management, packaging, and deployment
  * [Thor] - 'framework' for building CLI applications
  * [Nokogiri] - html/xml parsing (great for api clients and web utilities)
  * [multi_json] - json parsing/creation (great for api clients and web utilities)

[Bundler]:http://bundler.io
[Thor]:http://whatisthor.com
[Nokogiri]:http://nokogiri.org
[multi_json]:https://github.com/intridea/multi_json
[wunder]:https://github.com/ryands/wunder-rb
