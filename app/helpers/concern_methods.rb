module ConcernMethods
  def define_helper_method(name, &block)
    helper_method define_method(name, &block)
  end
end