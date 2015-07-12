require_relative './example'
require_relative './component'

module Ui
  class App
    def self.call(env)
      new.call(env)
    end

    # Component library root
    def self.root
      @root ||= Pathname(File.dirname(__FILE__)).join("..")
    end

    def self.base=(base)
      if !base.start_with?("/") || base.end_with?("/")
        raise ArugmentError.new("`base` is malformed: #{base}. Must start with a slash and must not end with a slash.")
      end

      @base = base
    end

    def self.base
      @base
    end

    def base
      self.class.base
    end

    def call(env)
      path = env["ORIGINAL_FULLPATH"].sub(/^#{Regexp.escape(base)}\/*/, '')
      handle_request(env, path)
    end

    def rack_file
      @rack_file ||= Rack::File.new(root)
    end

    def root
      self.class.root
    end

    def handle_request(env, path)
      raise "Path must be relative: #{env["REQUEST_PATH"]} => #{path}" if path.start_with?("/")

      if path == "components.json"
        components_response
      elsif path.match(/components\/([^\/]+)\/examples\/([^\/]+).js/)
        example_response(component_name: $1, example_name: $2)
      elsif path.start_with?("components/")
        component_response(path)
      else
        send_file(env, path)
      end
    end

    def components_response
      [
        200,
        {"Content-Type" => "application/json"},
        [Component.all.to_json]
      ]
    end

    def component_response(path)
      component_name = path.match(/\Acomponents\/([^.]+).json\Z/) {|m| m[1] } || ""

      [
        200,
        {"Content-Type" => "application/json"},
        [Component.new(component_name).to_json]
      ]
    end

    def example_response(component_name:, example_name:)
      example_name = CGI.unescape(example_name)
      component = Component.new(component_name)
      example = component.examples.find {|example| example.name == example_name }

      if example
        [
          200,
          {"Content-Type" => "application/javascript"},
          [CoffeeScript.compile(example.coffee)]
        ]
      else
        [404]
      end
    end

    def send_file(env, path)
      response = rack_file.call(env.merge("PATH_INFO" => "public/#{path}"))

      if [200, 304].include?(response.first)
        response
      else
        [
          200,
          {"Content-Type" => "text/html"},
          [File.read(root.join("public/index.html")).gsub("__BASE_PATH__", base)]
        ]
      end
    end
  end
end
