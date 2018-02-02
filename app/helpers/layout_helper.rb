module LayoutHelper
  def form_title(title)
    content_for(:title) { h(title) }
  end

  def form_subtitle(subtitle)
    content_for(:subtitle) { h(subtitle) }
  end

  def back_link_path(url)
    content_for(:back_link_path) { url }
  end

  def html_spacing(times = 1)
    ("&nbsp;" * times).html_safe
  end
end