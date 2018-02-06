module SortableHelper
  def sortable(attribute, title, options = {})
    link_to column_title(attribute, title), { q: filter, sort: attribute, direction: direction(attribute) }, options
  end

  def column_title(attribute, title)
    return title unless attribute == sort_column
    "#{title} #{sort_icon(attribute)}".html_safe
  end

  def sort_icon(attribute)
    fa_icon "sort-#{direction(attribute)}"
  end

  def direction(attribute)
    attribute == sort_column && sort_direction == "asc" ? "desc" : "asc"
  end
end