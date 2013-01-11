module Kuhsaft
  module Cms
    class PagesController < AdminController
      def index
        @pages = Kuhsaft::Page.roots
        respond_with @pages
      end

      def show
        @page = Kuhsaft::Page.find(params[:id])
        respond_with @page
      end

      def new
        @page = Kuhsaft::Page.new
        @page.published ||= Kuhsaft::PublishState::UNPUBLISHED
        respond_with @page
      end

      def create
        @page = Kuhsaft::Page.create params[:page]

        if @page.valid?
          respond_with @page, :location => kuhsaft.edit_cms_page_path(@page)
        else
          render 'new'
        end
      end

      def edit
        @page = Kuhsaft::Page.find(params[:id])
        @page.published ||= Kuhsaft::PublishState::UNPUBLISHED
        respond_with @page
      end

      def update
        @page = Kuhsaft::Page.find(params[:id])
        @page.update_attributes(params[:page]) if params[:page].present?
        # TODO: refactor 'reposition' as a page attribute, so it can be set through update_attributes
        @page.reposition params[:reposition] if params[:reposition].present? || params.key?(:reposition)

        if params[:add_page_part].present?
          @page.bricks << params[:page][:page_part_type].constantize.new
        end

        respond_with @page, :location => kuhsaft.edit_cms_page_path(@page)
      end

      def destroy
        @page = Kuhsaft::Page.find(params[:id])
        @page.destroy
        redirect_to kuhsaft.cms_pages_path
      end
    end
  end
end
