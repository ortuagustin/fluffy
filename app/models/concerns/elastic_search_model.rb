module ElasticSearchModel
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model                                     ## elasticsearch-model
    include Elasticsearch::Model::Callbacks unless Rails.env.test?   ## elasticsearch-model
  end
end
