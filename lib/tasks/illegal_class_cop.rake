task :illegal_class_cop do
  # task :find do
  #   require 'parser/current'
  #   engine_names = ARGV[1..-1]
  #   IllegalClassCop::print_offences engine_names.presence
  # end
  require 'parser/current'
  engine_names = ARGV[1..-1]
  IllegalClassCop::print_offences engine_names.presence
end