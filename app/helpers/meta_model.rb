module MetaModel
  include ConcernMethods

  def resource(model)
    model.to_s.tableize
  end
end