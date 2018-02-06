module SortsModels
  extend ActiveSupport::Concern

  included do
    before_action :set_params
    helper_method :sort_column, :sort_direction
  end

  def set_params
    p = params.permit(:sort, :direction)
    @sort = p[:sort]
    @direction = p[:direction]
  end

  def default_sort_column
    ''
  end

  def default_sort_direction
    'asc'
  end

  def sort_column
    sortable_columns.include?(@sort) ? @sort : default_sort_column
  end

  def sort_direction
    %w[asc desc].include?(@direction) ? @direction : default_sort_direction
  end

  def sort_params
    sort_column + ' ' + sort_direction
  end
end