# frozen_string_literal: true

require 'wax_tasks'

require_relative  'exarepo_tasks/version'
require_relative  'exarepo_tasks/site'
require_relative  'exarepo_tasks/config'
require_relative  'exarepo_tasks/item'
require_relative  'exarepo_tasks/collection'
require_relative  'exarepo_tasks/asset'
require_relative  'exarepo_tasks/food'

module ExarepoTasks
  class Error < StandardError; end

end
