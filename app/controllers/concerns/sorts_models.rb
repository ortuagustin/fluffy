module SortsModels
  extend ActiveSupport::Concern

  included do
    helper_method :sort_column, :sort_direction, :sort_column?, :sort_direction?, :sort_form_inputs
  end

  def sort_form_inputs
    fields = ''
    fields << (view_context.hidden_field_tag :sort, sort_column) if sort_column?
    fields << (view_context.hidden_field_tag :direction, sort_direction) if sort_direction?
    fields.html_safe
  end

  def sanitized_sort_params
    params.permit(:sort, :direction)
  end

  def sort_column
    sort_column? ? sanitized_sort_params[:sort] : default_sort_column
  end

  def sort_direction?
    %w[asc desc].include?(sanitized_sort_params[:direction])
  end

  def sort_direction
    sort_direction? ? sanitized_sort_params[:direction] : default_sort_direction
  end

  def default_sort_direction
    'asc'
  end

  def sort_params
    sort_column + ' ' + sort_direction
  end

  module ClassMethods
    def sorts(model, default = nil, *fields)
      resource = model.to_s.tableize
      @@fields = model_fields(resource, fields)
      create_sort_by_methods(resource, @@fields)
      create_helpers(fields, default)
    end

    private
      def create_helpers(fields, default)
        define_method(:sort_column?) do
          @@fields.include?(sanitized_sort_params[:sort])
        end

        define_method(:default_sort_column) do
          default.blank? ? @@fields.first : default.to_s
        end
      end

      def create_sort_by_methods(resource, fields)
        fields.each do |field|
          method_name = "sort_#{resource}_by_#{field}".to_sym
          define_method(method_name) do
            view_context.link_to header(resource, field), url(field), remote: true
          end

          helper_method method_name
        end
      end

      def model_fields(resource, fields = [])
        return get_model_class(resource.classify).column_names if fields.blank?
        fields.map {|f| f.to_s }
      end

      def get_model_class(klass)
        Object.const_get klass
      end
  end
private
  def header(name, field)
    h = I18n.t("#{name}.fields.#{field}")
    return h unless field == sort_column
    "#{h} #{icon(field)}".html_safe
  end

  def url(field)
    { q: filter, sort: field, direction: direction(field) }
  end

  def direction(field)
    field == sort_column && sort_direction == "asc" ? "desc" : "asc"
  end

  def icon(field)
    view_context.fa_icon "sort-#{direction(field)}"
  end
end