module SortableHelper
  def sortable(attribute, title, options = {})
    link_to column_title(attribute, title), args(attribute), options
  end

  def sort_form_inputs
    fields = ''
    fields << (hidden_field_tag :sort, sort_column) if sort_column?
    fields << (hidden_field_tag :direction, sort_direction) if sort_direction?
    fields.html_safe
  end
private
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

  def args(attribute)
    p = params.permit(:sort, :direction)
    p.merge(sort: attribute, direction: direction(attribute))
  end
end