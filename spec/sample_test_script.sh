#!/bin/bash
# Attempts to build dataset collection based on local wax tasks variant
# Ran this from within the examples-repository repo folder, and built
# the exarepo_tasks gem based on a folder in the same super-directory.
# (Tested alongside images to make sure there were no side effects.)

echo "Begin testing! Note you must run this from examples repository root directory."

# Instruct bundler to use local repo in place of wax-tasks
# https://bundler.io/v2.2/guides/git.html#local
# Note: you may have to run bundle install first
bundle config local.wax_tasks ../exarepo_tasks

# Clobber existing wax-generated files for the dataset collection
bundle exec rake wax:clobber datasets
bundle exec rake wax:clobber datavis

# Generate image derivatives
bundle exec rake wax:derivatives:simple datavis

# Generate file derivatives
bundle exec rake wax:file_derivatives:simple datasets

# After clobber, run pages again
bundle exec rake wax:pages datasets
bundle exec rake wax:pages datavis

# Finally, recreate wax search
bundle exec rake wax:search main

# bundle exec rake --tasks
# bundle exec jekyll serve
