module SortsModels
  extend ActiveSupport::Concern

  module ClassMethods
    def sorts(model, default = nil, *fields)
      resource = model.to_s.tableize
      @@fields ||= ActiveSupport::HashWithIndifferentAccess.new
      @@fields[resource] = model_fields(resource, fields)
      create_sort_by_methods(resource, @@fields[resource])
      create_helpers(resource, default)
    end

    private
      def define_helper_method(name, &block)
        helper_method define_method(name, &block)
      end

      def create_helpers(resource, default)
        define_helper_method "#{resource}_sort_column?" do
          @@fields[resource].include?(send("#{resource}_sanitized_sort_params")[:sort])
        end

        define_helper_method "#{resource}_default_sort_column" do
          default.blank? ? @@fields[resource].first : default.to_s
        end

        define_helper_method "#{resource}_sanitized_sort_params" do
          params.permit(:sort, :direction)
        end

        define_helper_method "#{resource}_sort_column" do
          send("#{resource}_sort_column?") ?
            send("#{resource}_sanitized_sort_params")[:sort] :
            send("#{resource}_default_sort_column")
        end

        define_helper_method "#{resource}_sort_direction?" do
          %w[asc desc].include?(send("#{resource}_sanitized_sort_params")[:direction])
        end

        define_helper_method "#{resource}_sort_direction" do
          send("#{resource}_sort_direction?") ?
            send("#{resource}_sanitized_sort_params")[:direction] :
            send("#{resource}_default_sort_direction")
        end

        define_helper_method "#{resource}_default_sort_direction" do
          'asc'
        end

        define_helper_method "#{resource}_sort_params" do
          send("#{resource}_sort_column") + ' ' + send("#{resource}_sort_direction")
        end

        define_helper_method "#{resource}_sort_form_inputs" do
          ctx = view_context
          fields = ''
          fields << (ctx.hidden_field_tag :sort, send("#{resource}_sort_column")) if send("#{resource}_sort_column?")
          fields << (ctx.hidden_field_tag :direction, send("#{resource}_sort_direction")) if send("#{resource}_sort_direction")
          fields.html_safe
        end

        define_method :header do |name, field|
          h = I18n.t("#{name}.fields.#{field}")
          return h unless field == send("#{resource}_sort_column")
          "#{h} #{icon(field)}".html_safe
        end

        define_method :url do |field|
          { q: filter, sort: field, direction: direction(field) }
        end

        define_method :direction do |field|
          field == send("#{resource}_sort_column") && send("#{resource}_sort_direction") == "asc" ? "desc" : "asc"
        end

        define_method :icon do |field|
          view_context.fa_icon "sort-#{direction(field)}"
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
end