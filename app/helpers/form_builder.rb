class FormBuilder < ActionView::Helpers::FormBuilder
  def label(object_name, options = {})
    options[:class] = 'label'
    super
  end
end