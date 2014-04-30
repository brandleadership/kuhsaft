module Kuhsaft
  class Page < ActiveRecord::Base
    include Kuhsaft::Engine.routes.url_helpers
    include Kuhsaft::Orderable
    include Kuhsaft::Translatable
    include Kuhsaft::BrickList
    include Kuhsaft::Searchable

    has_ancestry
    acts_as_brick_list

    translate :title, :page_title, :slug, :keywords, :description,
              :body, :redirect_url, :url

    default_scope { order 'position ASC' }

    scope :published, -> { where published: Kuhsaft::PublishState::PUBLISHED }
    scope :translated, -> { where "url_#{I18n.locale.to_s.underscore} is not null" }

    scope :content_page, -> { where page_type: Kuhsaft::PageType::CONTENT }

    scope :navigation, lambda { |slug|
      where(
        locale_attr(:slug) => slug,
        locale_attr(:page_type) => Kuhsaft::PageType::NAVIGATION)
    }

    before_validation :create_slug, :create_url

    validates :title, presence: true
    validates :slug, presence: true
    validates :redirect_url, presence: true, if: :redirect?
    validates :title, :slug, :keywords, :page_type, length: { maximum: 255 }
    validates :identifier, uniqueness: true, allow_blank: true

    class << self
      def flat_tree(pages = nil)
        arrange_as_array
      end

      def arrange_as_array(options = {}, hash = nil)
        hash ||= arrange(options)

        arr = []
        hash.each do |node, children|
          arr << node
          arr += arrange_as_array(options, children) unless children.empty?
        end

        arr
      end

      def by_identifier(identifier)
        where(identifier: identifier).first
      end
    end

    def without_self
      self.class.where 'id != ?', id
    end

    def published?
      published == Kuhsaft::PublishState::PUBLISHED
    end

    def state_class
      published? ? 'published' : 'unpublished'
    end

    def redirect?
      page_type == Kuhsaft::PageType::REDIRECT
    end

    def navigation?
      page_type == Kuhsaft::PageType::NAVIGATION
    end

    def parent_pages
      ancestors
    end

    def translated?
      url.present? && title.present? && slug.present?
    end

    def link
      if bricks.count == 0 && children.count > 0
        children.first.link
      else
        url_with_locale
      end
    end

    # TODO: needs naming and routing refactoring (url/locale/path/slug)
    def path_segments
      paths = parent.present? ? parent.path_segments : []
      paths << slug unless navigation?
      paths
    end

    def url_without_locale
      path_segments.join('/')
    end

    def url_with_locale
      opts = { locale: I18n.locale }
      url = url_without_locale
      opts[:url] = url if url.present?
      page_path(opts)
    end

    def create_url
      self.url = url_with_locale[1..-1]
    end

    def create_slug
      has_slug = title.present? && slug.blank?
      self.slug = title.downcase.parameterize if has_slug
    end

    def nesting_name
      num_dashes = parent_pages.size
      num_dashes = 0 if num_dashes < 0
      "#{'-' * num_dashes} #{title}".strip
    end

    def brick_list_type
      'Kuhsaft::Page'
    end

    def to_style_class
      'kuhsaft-page'
    end

    def allowed_brick_types
      Kuhsaft::BrickType.enabled.pluck(:class_name) - ['Kuhsaft::AccordionItemBrick']
    end

    def cache_key
      super + bricks.map(&:cache_key).join
    end

    def as_json(options = {})
      Hash.new.tap do |json|
        json['title'] = send("title_#{I18n.locale.to_s.underscore}")
        json['pretty_url'] = '/' + send("url_#{I18n.locale.to_s.underscore}")
        json['url'] = "/pages/#{id}"
      end
    end
  end
end
