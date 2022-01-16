# ExarepoTasks

## Installation

To install this gem from GitHub, add this line to your application's Gemfile:

```ruby
gem "exarepo_tasks", :git => "git://github.com/visualizingthefuture/exarepo_tasks.git"
```

For a local installation, add this line to your application's Gemfile:

```ruby
gem "exarepo_tasks", path: "path_to_exarepo_tasks_directory"
```

If/when gem is distributed on RubyGems.org, use this line instead:

```ruby
gem 'exarepo_tasks'
```

Or you can include the gem as a dependency in your gemspec file:

```ruby
spec.add_dependency 'exarepo_tasks'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install exarepo_tasks

## Usage

This gem offers some post-processing workarounds for minicomp/wax, styled off the original [wax_tasks](https://github.com/minicomp/wax_tasks/). Like wax_tasks, exarepo_tasks defines rake tasks to accomplish file processing work for [Wax](https://github.com/minicomp/wax) exhibitions.

To use exarepo_tasks on a Wax exhibition, install the gem as instructed above. You will also need to tell the Wax project how to find the rake tasks in the new gem by editing the Rakefile.

In the Rakefile for the Wax project, you can add a sequence like this for a local installation:

```ruby
gem_dir = File.expand_path("path_to_exarepo_tasks_directory")
Dir.glob("#{gem_dir}/lib/tasks/*.rake").each { |r| load r }
```

For an installation using the gemspec, you can add a sequence like this:

```ruby
spec = Gem::Specification.find_by_name 'exarepo_tasks'
Dir.glob("#{spec.gem_dir}/lib/tasks/*.rake").each { |r| load r }
```

At that point, you should be able to use the rake tasks on the command like just like the [Wax tasks](https://minicomp.github.io/wiki/wax/running-the-tasks/).

Check for tasks:

    $ bundle exec rake --tasks

Run the file derivatives task:

    $ bundle exec rake exarepo:file_derivatives:simple YOUR_COLLECTION_NAME


## Development

Run `bundle exec rspec spec` to execute the tests specified in `spec/exarepo_tasks_spec.rb`.

Additional generic instructions (not tested):

* After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.
* To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/visualizingthefuture/exarepo_tasks. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/visualizingthefuture/exarepo_tasks/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ExarepoTasks project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/visualizingthefuture/exarepo_tasks/blob/master/CODE_OF_CONDUCT.md).
