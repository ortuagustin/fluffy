module Searchable
  extend ActiveSupport::Concern

  module ClassMethods
    def search(keyword)
      return all if keyword.nil?
      conditions = self.searchable_fields.map { |field| "#{field} LIKE '%#{keyword}%'" }.join(' OR ')
      where(conditions)
    end
  end
end