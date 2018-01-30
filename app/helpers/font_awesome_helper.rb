module FontAwesomeHelper
  def fa_link_to(fa_icon_name, label, url, options = {} )
    size = options[:size] || 16
    link_to(icon_with_label(fa_icon_name, label, size), url, options)
  end

  private
  def icon_with_label(icon_name, label, size)
    fa_icon icon_name, text: label, style: "font-size:#{size}px;"
  end
end