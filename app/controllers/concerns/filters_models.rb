module FiltersModels
  extend ActiveSupport::Concern

  module ClassMethods
    include MetaModel

    def filters(model, *fields)
      create_filter_method(resource(model))
    end

    private
      def create_filter_method(resource)
        define_helper_method "#{resource}_filter" do
          send("#{resource}_sanitized_filter_params")[:q]
        end

        define_helper_method "#{resource}_sanitized_filter_params" do
          params.permit(:q)
        end

        define_helper_method "#{resource}" do
          collection = instance_variable_get("@#{resource}")
          proxify(collection, resource, self)
        end
      end
  end

  class FilterableModel
    attr_reader :this, :resource, :controller

    def initialize(obj, resource, controller)
      @this = obj
      @resource = resource
      @controller = controller
    end

    def ctx
      controller.view_context
    end

    def filter
      controller.send("#{resource}_filter")
    end

    def highlight(text)
      ctx.highlight(text, filter)
    end
  end

  def proxify(collection, resource, controller)
    collection.map do |each|
      m = FiltersModels::FilterableModel.new(each, resource, controller)
      each.class.column_names.each do |f|
        m.class.send :define_method, f.to_sym do
          m.highlight each.send(f)
        end
      end
      m
    end
  end
end