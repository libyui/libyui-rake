# Libyui::Rake

[![Build Status](https://travis-ci.org/libyui/libyui-rake.svg?branch=master
)](https://travis-ci.org/libyui/libyui-rake)

Rake tasks to help with uniform handling of libyui related projects. It provides setup for
[packaging tasks](http://github.com/openSUSE/packaging_tasks) and add some additional tasks.

## Quick Start

Create a `Rakefile` with this content:

```
  require "libyui/rake"
```

## Packaging tasks setup

Libyui::Tasks provides a method to change packaging tasks configuration. As it's
just a proxy for `::Packaging.configuration`, the same options will be
available.

```ruby
  Libyui::Tasks.configuration do |conf|
    conf.obs_api = "https://api.opensuse.org/"
    conf.obs_project = "Devel:Libyui:Head"
  end
```

To avoid duplication, Libyui::Tasks provides a method to set packaging tasks
configuration choosing from a set of [targets
definitions](https://github.com/libyui/libyui-rake/blob/master/data/targets.yml).
For example, if you want to submit to SLE12, you can do:

```
  Libyui::Tasks.submit_to(:sle12)
```
This method can receive, as a second parameter, the path to your own
definitions if needed.

If `submit_to` is not explicitly used, it will be read from the environment
variable `LIBYUI_SUBMIT`. If that variable is not set, the variable
`YAST_SUBMIT` will be used instead. Finally, if none of the special
environment variables is set, `:factory` will be used as target.

## Additional tasks

### version:check

Check that version numbers are in sync.

### version:bump

Increase the last part of version in spec and CMake files.

### test

Pretend to run the test suite.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License
This package is licensed under
[LGPL-2.1](http://www.gnu.org/licenses/lgpl-2.1.html).
