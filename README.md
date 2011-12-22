# Guard::Rake

Guard::Rake allows you to automatically run a Rake task when files are
modified.

## Install

Please be sure to have [Guard](https://github.com/guard/guard) installed
before continuing.

Install the gem:
```bash
$ gem install guard-rake```

Add it to your `Gemfile`

```ruby
gem 'guard-rake'
```

Add the default Guard::Rake template to your `Guardfile` by running this
command:

```bash
$ guard init rake
```

## Usage

Please read the [Guard usage documentation](https://github.com/guard/guard#readme).

## Guardfile

Guard::Rake comes with a default template that looks like this:

```ruby
guard 'rake', :task => 'doit' do
  watch(%r{^some_files/.+$})
end
```

This will run the rake task `doit` from your `Rakefile` whenever any of
the watched files change.

### List of available options:

``` ruby
:task => 'doit'              # name of the task to be executed, required
:run_on_all => false         # runs when the 'run_all' signal is received from Guard (enter is pressed), default: true
```

## Development

- Source hosted at [GitHub](https://github.com/rubyist/guard-rake)
- Report issues and feature requests to [GitHub Issues](https://github.com/rubyist/guard-rake/issues)

Pull requests welcome!

## License

(The MIT License)

Copyright (c) 2011 Scott Barron

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

