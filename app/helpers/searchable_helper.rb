module SearchableHelper
  def search_form(url, &block)
    render('application/search', &block)
  end
end