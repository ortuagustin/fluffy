module SortsModels
  extend ActiveSupport::Concern

  included do
    helper_method :sort_column, :sort_direction
  end
protected
  def default_sort_column
    ''
  end

  def default_sort_direction
    'asc'
  end

  def sort_column
    sortable_columns.include?(params[:sort]) ? params[:sort] : default_sort_column
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : default_sort_direction
  end

  def sort_params
    sort_column + ' ' + sort_direction
  end
end