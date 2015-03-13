class DevTools::ComponentsController < DevTools::DevToolsController
  # Rails' gem loading voodoo seems to fall apart here. Need to manually require this.
  require 'coffee-script'

  def index
    respond_to do |format|
      format.html {
        render nothing: true, layout: 'components'
      }
      format.json {
        render json: component_list
      }
    end
  end

  def show
    name = File.basename params[:id]
    directory = File.join components_root, name

    readme = File.read File.join directory, 'readme.md'

    respond_to do |format|
      format.json {
        render json: {
          name: name,
          readme: readme,
          examples: examples_for_component(name)
        }
      }
    end
  end

  def example
    component_name = File.basename params[:component_id]
    component_directory = File.join components_root, component_name

    examples = File.join component_directory, 'examples'
    return unless File.directory? examples

    example = File.join examples, params[:id]
    return unless File.directory? example

    respond_to do |format|
      format.js {
        coffee_file = File.join example, 'coffee.coffee'
        coffee = File.read(coffee_file)
        brewed_coffee = CoffeeScript.compile(coffee)
        render js: brewed_coffee
      }
    end
  end

  private

  def components_root
    @components_root ||= Rails.root.join 'app', 'dev_tools', 'themis_components'
  end

  def collect_example(example)
    example_data = { name: File.basename(example) }

    pieces = {
      html: 'html.html',
      coffee: 'coffee.coffee'
    }

    pieces.each do |name, filename|
      file = File.join example, filename
      example_data[name] = File.read file if File.file? file
    end

    return example_data
  end

  def examples_for_component(name)
    directory = File.join components_root, name, 'examples'
    examples = File.directory?(directory) ? Dir.glob(File.join(directory, '*')) : []

    examples.each_with_object [] do |example, result|
      result << collect_example(example) if File.directory? example
    end
  end

  def component_directories
    all_items = Dir.glob File.join components_root, '*'

    all_items.each_with_object [] do |item, result|
      result << item if File.directory?(item) && !File.basename(item).eql?("theme")
    end
  end

  def component_list
    component_directories.map do |item|
      File.basename item
    end
  end

end
