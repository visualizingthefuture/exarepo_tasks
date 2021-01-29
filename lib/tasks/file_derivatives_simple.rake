# frozen_string_literal: true

require 'wax_tasks'

namespace :wax do
  namespace :file_derivatives do
    desc 'generate simple derivatives from local data files'
    task :simple do
      args = ARGV.drop(1).each { |a| task a.to_sym }
      args.reject! { |a| a.start_with? '-' }
      raise WaxTasks::Error::MissingArguments, Rainbow("You must specify a collection after 'wax:file_derivatives:simple'").magenta if args.empty?

      site = WaxTasks::Site.new
      args.each { |a| site.generate_file_derivatives(a, 'simple') }
    end
  end
end
