module Kuhsaft
  module Cms
    class PagesController < AdminController
      def index
        @pages = Kuhsaft::Page.root_pages
        respond_with @pages
      end

      def show
        @page = Kuhsaft::Page.find(params[:id])
        respond_with @page
      end

      def new
        @page = Kuhsaft::Page.new
        @localized_page = @page.localized_pages.find_or_initialize_by_locale(params[:locale])
        respond_with @page
      end

      def create
        parent = Kuhsaft::Page.find(params[:kuhsaft_page][:parent_id]) if params[:kuhsaft_page][:parent_id].present?
        @page = Kuhsaft::Page.create params[:kuhsaft_page]
        if parent.present?
          parent.childs << @page
          parent.save
        end
        respond_with @page, :location => edit_cms_page_path(@page)
      end

      def edit
        @page = Kuhsaft::Page.find(params[:id])
        @localized_page = @page.localized_pages.find_or_initialize_by_locale(params[:locale])

        if params[:add_page_part].present?
          @localized_page.page_parts.build :type => params[:kuhsaft_page][:page_part_type].constantize
        end
        
        respond_with @page
      end

      def update
        @page = Kuhsaft::Page.find(params[:id])
        @page.update_attributes(params[:kuhsaft_page]) if params[:kuhsaft_page].present?
        # TODO: refactor 'reposition' as a page attribute, so it can be set through update_attributes
        @page.reposition params[:reposition] if params[:reposition].present? || params.key?(:reposition)
        respond_with @page, :location => edit_cms_page_path(@page)
      end

      def destroy
        @page = Kuhsaft::Page.find(params[:id])
        @page.destroy
        redirect_to cms_pages_path
      end
    end
  end
end
