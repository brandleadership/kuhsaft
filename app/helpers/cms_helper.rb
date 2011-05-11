module CmsHelper
  def admin_tab title, path
    content_tag :li, link_to(title, path), :class => (:current if request.path.include?(path))
  end
end