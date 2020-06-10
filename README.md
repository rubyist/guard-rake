# Guard::Rake

Guard::Rake allows you to automatically run a Rake task when files are
modified.

## Install

Please be sure to have [Guard](https://github.com/guard/guard) installed
before continuing.

Install the gem:
```bash
$ gem install guard-rake
```

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

```ruby
:task => 'doit'              # name of the task to be executed, required
:run_on_all => false         # runs when the 'run_all' signal is received from Guard (enter is pressed), default: true
:run_on_start => true        # runs when guard is started, default: true
:task_args => []             # arguments to pass to Rake::Task#invoke, default: []
```

### Rake task arguments
By default, the changed file paths will be passed into the rake task. Example:

```ruby
task :doit, :paths do |t, args|
  args.paths  # Will contain an array of changed paths
end
```

You may also use this in conjunction with the :task_args options. Anything in :task_args will
be passed in first, then the array of changed paths. Example:

```ruby
# Guardfile
guard 'rake', :task => 'doit', :task_args => ['a', 'b'] do
  watch(%r{^some_files/.+$})
end

# Rakefile
task :doit, [:first, :second, :paths] do |t, args|
  args.first  # "a"
  args.second # "b"
  args.paths  # ['changed1.rb', 'changed2.rb']
end
```

## Second usage

This second usage will describe how to create a rake task that generates Guardfile from rake tasks.

First, add this to your Gemfile:

```ruby
gem 'guard-rake'
gem 'guard-shell'
```

You will need some tasks with file dependencies in your Rakefile. I'f you don't have those, try put this code in your Rakefile:

```ruby
files = Rake::FileList.new('*.md')
desc "Create a book"
task 'book' => files do
  sh "cat #{files.join(" ")} > book.txt"
end
```

Now you are ready to import our rake task, put  Inside your `Rakefile`:

```ruby
require "guard/rake/task"

Guard::Rake::Task.new
```

You can see you have two new tasks:

```
$ rake -T
rake book             # Create a book
rake guard            # Create Guardfile from rake tasks
```

And the book task have these dependencies:

```
$ rake -P
rake book
    README.md
rake guard
```

If you call the `guard` task it will create `Guardfile`:

```
$ rake guard
$ cat Guardfile
guard :shell do

    watch(%r{^(README.md)$}) do |m|
      system("rake book")
    end

end
```

You can also add the `Rakefile` dependency:

```
task :guard => ['Rakefile']
```

And using the `guard` task it will produce this `Guardfile`:

```ruby
guard :shell do

    watch(%r{^(README.md)$}) do |m|
      system("rake book")
    end

    watch(%r{^(Rakefile)$}) do |m|
      system("rake guard")
    end

end
```

### Advanced usage

If you want update your `Guardfile` with other content, it's best to create your own ERB template:

```ruby
Guard::Rake::Task.new do |t|
  t.template=File.read('Guardfile.erb')
end
```

And then create your `Guardfile.erb` as a template:

```ruby
guard :shell do
  <% all_tasks.each do |t, files| %>
    watch(%r{^(<%= files.join('|') %>)$}) do |m|
      system("rake <%= t %>")
    end
  <% end %>

  <%# Add your custom code here %>
end

<%# Or here %>
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
