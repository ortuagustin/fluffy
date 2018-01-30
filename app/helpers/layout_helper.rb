module LayoutHelper
  def form_title(title)
    content_for(:form_title) { h(title) }
  end

  def back_link_path(url)
    content_for(:back_link_path) { url }
  end
end