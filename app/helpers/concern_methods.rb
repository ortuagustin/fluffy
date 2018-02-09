module ConcernMethods
  def define_helper_method(name, &block)
    helper_method define_method(name, &block)
  end

  def model_fields(resource, fields = [])
    return get_model_class(resource.classify).column_names if fields.blank?
    fields.map {|f| f.to_s }
  end

  def get_model_class(klass)
    Object.const_get klass
  end
end