module SearchableHelper
  def remote_search_form(url, filter, &block)
    search_form(url, filter, true, &block)
  end

  def search_form(url, filter, remote = false, &block)
    form_id = remote ? 'search' : nil
    render layout: 'application/search', locals: { url: url, filter: filter, form_id: form_id, remote: remote }, &block
  end
end