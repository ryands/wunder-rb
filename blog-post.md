# Writing Awesome CLI Tools in Ruby Part I

## Introduction

I am always writing small tools to help me out on a daily basis.  Sometimes shell scripts, but other
times I want something a bit more complex.  When I need more than a simple shell script, I like to
leverage ruby for its vast library of gems which can greatly accelerate and simplify the task of
building these helpful tools.

This post will give an introduction to writing your own CLI tools in ruby and packaging them as a
gem.  There are more concepts that I wanted to cover here, but that would prove to be a very lengthy
post.  To simplify and make this concept more easy to digest, this post is the first of a short
series of posts.

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


#### Packaging your gem

Bundler provides some rake tasks to help you package, install, and even publish your gem.  

 * `rake build` - build and package your gem into `pkg/mygem-version.gem`
 * `rake install` - build and install your gem to your local system
 * `rake release` - publish your gem on [rubygems.org]

While developing you'll want to be testing your code manually.  In order to run your gem without
building and installing it, you can run it with `bundle exec bin/myapp` and your executable will
be run in the context of your defined environment in the Gemfile/gemspec.

## Next steps

This post leaves you at a place where you are able to create a gem project structure, add an
executable to the bin/ directory, and package/install your gem.  If you've done everything
correctly, you will be able to run your installed gem by simply executing the command that
corresponds with the name of your executable in `bin/`.  In our case, `$ wunder` works.

You will notice that the example project has a lot more things going on.  I will cover each
of those things in Part II of *Writing Awesome CLI Tools in Ruby*

Some topics to be covered:

  * Designing your utility to function both as a library and a CLI tool
  * Gems to make your life easy when writing these types of utilities
  * Configuration files
  * Rich commandline api's


----------

**Part II below this line **

Introduction
============

This is part II of my series on writing awesome CLI tools using ruby. In the first part I described how to create
your project layout, add an executable binary, and get started. In this next part I will cover:

  * How to structure your code to be usable as both a tool and a library
  * Building your CLI frontend to your library.

The Library
===========

Your library lives within `lib/`. Break up the library into modules and classes. In this example we have a single module,
`wunder`. 

### Classes

All of your work should be done from classes within your gem. These classes will be configured and executed by the CLI,
but can also be reused within other scripts and programs by requiring them.

Be sure to design your classes to be configurable, and to return values rather than simply printing the output. It also
helps if any IO is configurable with defaults to stdin/stdout. 

You notice that the `Wunder::Wunderground` class takes a configuration object, provided by the CLI class (or potentially
any other object that wants to take advantage of its features).

### The commandline interface

Within the library, I have a class called "cli" (`lib/wunder/cli.rb`), which is my commandline interface. The commandline
interface uses the fantastic [Thor] gem. An example of a thor interface might look like

```ruby
class CLI < Thor
  desc 'echo ARG', 'Echo.  Takes an arg, prints it.'
  def echo(arg)
    puts arg
  end
end
```

As you can see right away: it is as simple as extending `Thor` and defining public methods. The methods are executable
as sub-commands when this script is run. Arguments are simply method arguments.

Options are a bit different though...

```ruby
class CLI < Thor
  desc 'take_option', 'Option taking class'
  option :opt, required: false, default: nil, aliases: ['o'], desc: 'An option.'
  def take_option
    puts "My option: #{options[:opt]}"
  end
end
```

The above method can be passed an option ('opt') either through `--opt=value` or `-o value`.

The CLI portion gets invoked from our 'binary' in `bin/wunder`, which calls `Wunder::CLI.start(ARGV)` to kick it off.

The methods within the CLI class should configure objects, call methods, and format/print the results.

Conclusion
==========

This post covered how to structure and build your library and commandline interface. Hopefully this will help you create
useful and effective tools!

----------

## Selected gems

Some of the gems that I use to aid in the process of creating these tools are:

  * [Bundler] - gem management, packaging, and deployment
  * [Thor] - 'framework' for building CLI applications
  * [Nokogiri] - html/xml parsing (great for api clients and web utilities)
  * [multi_json] - json parsing/creation (great for api clients and web utilities)

Each of these can be added to the gemspec as a dependency.  After adding any dependency
be sure to run `bundle` to install them.

[Bundler]:http://bundler.io
[Thor]:http://whatisthor.com
[Nokogiri]:http://nokogiri.org
[multi_json]:https://github.com/intridea/multi_json
[wunder]:https://github.com/ryands/wunder-rb
[rubygems.org]:http://rubygems.org
