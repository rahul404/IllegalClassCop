require "illegal_class_cop/version"
require 'illegal_class_cop/realtie' if defined?(Rails)
require 'parser/current'

class IllegalClassCop
  class ConstantMap
    def initialize
      @engines = {}
    end

    def add_constants(engine_name, constants)
      @engines[engine_name][:constants] += constants
    end

    def add_engine(engine_name, path)
      @engines[engine_name] = {constants: Set.new, path: path}
    end

    def constants(engine_name)
      @engines[engine_name][:constants]
    end

    def path(engine_name)
      @engines[engine_name][:path]
    end

    def engines
      @engines.keys
    end

    def [](engine)
      @engines[engine]
    end

    def include?(engine_name, constant)
      @engines[engine_name][:constants].include?(constant)
    end
  end

  class << self
    def t
      p "HI"
    end

    def print_offences(engine_names = nil)
      raise StandardError.new("Not a rails app") if !defined?(Rails)
      puts "=========Scanning Project for illegal Constant Access\n"
      error_messages = []
      puts "=========Building Constant Map\n"
      constant_map = build_constant_map
      engine_paths(engine_names).each do |engine_root|
        engine_name = engine_name(engine_root)
        puts "=========Scanning Engine #{engine_name}\n"
        ruby_files(engine_root).each do |file_path|
          tree = file_to_ast(file_path)
          constant_list = fetch_all_constants(tree)
          constant_list.each do |constant|
            if illegally_accessed?(constant, engine_name, constant_map)
              error_messages << "Constant #{constant} illegally accessed in #{file_path}\n"
            end
          end
        end
      end
      error_messages.each_with_index { |msg, index| puts "#{index + 1}. #{msg}".red }
      final_message = "#{error_messages.size} offences found."
      if error_messages.any?
        puts final_message.red
      else
        puts final_message.green
      end
    end

    private

    def build_constant_map(engine_names = nil)
      constant_map = ConstantMap.new
      engine_paths(engine_names).each do |engine_root|
        engine_name = engine_name(engine_root)
        next if engine_names.present? && !engine_names.include?(engine_name)
        constant_map.add_engine(engine_name, engine_root)
        ruby_files(engine_root).each do |file_path|
          tree = file_to_ast(file_path)
          constant_list = declared_constants(tree)
          constant_map.add_constants(engine_name, constant_list) if constant_list.present?
        end
      end
      constant_map
    end

    def fetch_all_constants(node)
      constants = []
      return constants if node.nil? || !node.is_a?(Parser::AST::Node)
      if node.type == :const
        constants << const_node_to_a(node).join("::")
      elsif node.type == :module || node.type == :class
        constants += fetch_all_constants(node.children.last)
      else
        node.children.each do |child|
          constants += fetch_all_constants(child)
        end
      end
      constants
    end

    def declared_constants(node, parent_const_name="")
      constants = []
      return constants unless node.is_a?(Parser::AST::Node)
      const_name = parent_const_name.present? ? [parent_const_name] : []
      if node.type == :casgn
        const_name += (const_node_to_a(node.children.first) + [node.children[1].to_s])
        constants << const_name.join("::")
      elsif node.type == :module || node.type == :class
        const_name += const_node_to_a(node.children.first)
        constants << const_name.join("::")
        constants = (constants + declared_constants(node.children.last, const_name)).flatten
      end
      constants
    end

    def illegally_accessed?(constant, engine_name, constant_map)
      !constant_map.include?(engine_name, constant) && (constant_map.engines - [engine_name]).any? do |other_engine|
        constant_map.include?(other_engine, constant)
      end
    end

    def engine_paths(engine_names = nil)
      paths = Dir.glob(File.join(Rails.root.to_s, "apps", "**")).select
      if engine_names.present?
        paths = paths.select{ |path| engine_names.any?{ |name| path.include?(name) } }
      end
      paths
    end

    def engine_name(engine_path)
      engine_path.split("/").last
    end

    def ruby_files(engine_path)
      Dir.glob(File.join(engine_path, "**", "*.rb"))
    end

    def file_to_ast(file_path)
      file_content = File.read(file_path)
      parser = Parser::CurrentRuby.new
      buffer = Parser::Source::Buffer.new('(string)')
      buffer.source = file_content
      parser.parse(buffer)
    end

    def const_node_to_s(const_node)
      const_node_to_a(const_node).join("::")
    end

    def const_node_to_a(const_node)
      return [] if const_node.nil?
      ([const_node_to_a(const_node.children.first)] + [const_node.children.last.to_s]).flatten
    end
  end
end
