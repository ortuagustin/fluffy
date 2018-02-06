module FiltersModels
  extend ActiveSupport::Concern

  included do
    helper_method :filter
  end

  def filter
    params[:q]
  end
end