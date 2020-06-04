require 'illegal_class_cop'
namespace :test do
  task illegal_class_cop: :environment do |_t, _args|
    require 'parser/current'
    engine_names = ARGV[1..-1]
    IllegalClassCop::print_offences engine_names.presence
  end
end