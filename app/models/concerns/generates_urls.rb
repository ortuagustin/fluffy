module GeneratesUrls
  extend ActiveSupport::Concern

  included do
    include Rails.application.routes.url_helpers
  end
end