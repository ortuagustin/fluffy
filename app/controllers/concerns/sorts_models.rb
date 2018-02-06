module SortsModels
  extend ActiveSupport::Concern

  included do
    helper_method :sort_column, :sort_direction
  end
protected
  def sort_column
    sortable_columns.include?(params[:sort]) ? params[:sort] : ''
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : ''
  end

  def sort_params
    sort_column + ' ' + sort_direction
  end
end