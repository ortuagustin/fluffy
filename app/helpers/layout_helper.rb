module LayoutHelper
  def form_title(title)
    content_for(:title) { h(title) }
  end

  def form_subtitle(subtitle)
    content_for(:subtitle) { h(subtitle) }
  end

  def html_spacing(times = 1)
    ("&nbsp;" * times).html_safe
  end

  def custom_form_for(record, options = {}, &block)
    options.merge! builder: FormBuilder
    form_for record, options, &block
  end
end