# lib/railtie.rb
require 'illegal_class_cop'
require 'rails'

module MyGem
  class Railtie < Rails::Railtie

    rake_tasks do
      # path = File.expand_path(__dir__)
      # Dir.glob("#{path}/tasks/**/*.rake").each { |f| load f }
      load 'tasks/illegal_class_cop.rake'
      # load 'illegal_class_cop/test/illegal_class_cop.rake'
      # load 'tasks/illegal_class_cop.rake'
    end
  end
end