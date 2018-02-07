module SearchableHelper
  def remote_search_form(url, &block)
    search_form(url, true, &block)
  end

  def search_form(url, remote = false, &block)
    form_id = remote ? 'search' : nil
    render layout: 'application/search', locals: { url: url, remote: remote, form_id: form_id }, &block
  end
end