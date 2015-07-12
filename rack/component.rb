module Ui
  class Component
    attr_reader :name

    def self.all
      Ui::App.root.join("themis_components").children.select(&:directory?).map(&:basename).map(&:to_s)
    end

    def initialize(name)
      raise "Component cannot contain a slash: #{name}" if name.include?("/")

      @name = name
    end

    def as_json(*)
      {
        name: name,
        readme: readme,
        readmeHTML: "",
        examples: examples
      }
    end

    def root
      Ui::App.root.join("themis_components", name)
    end

    def exist?
      root.exist?
    end

    def readme
      path = root.join("readme.md")
      path.exist? ? File.read(path) : ""
    end

    def examples
      path = root.join("examples")
      return [] unless path.exist?

      path.children.select(&:directory?).map do |path|
        Example.new(path)
      end
    end
  end
end
