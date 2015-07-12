module Ui
  class Example
    attr_reader :path

    def initialize(path)
      @path = path
    end

    def name
      path.basename.to_s
    end

    def coffee
      File.read(path.join("coffee.coffee"))
    end

    def html
      File.read(path.join("html.html"))
    end

    def as_json(*)
      {
        name: name,
        html: html,
        coffee: coffee
      }
    end
  end
end
