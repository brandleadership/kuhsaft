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
          flash[:success] = t('layouts.kuhsaft.cms.flash.success', :subject => Kuhsaft::Page.model_name.human)
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
        if @page.update_attributes(params[:page])
          flash[:success] = t('layouts.kuhsaft.cms.flash.success', :subject => Kuhsaft::Page.model_name.human)
          respond_with @page, :location => kuhsaft.edit_cms_page_path(@page)
        else
          render 'edit'
        end
      end

      def destroy
        @page = Kuhsaft::Page.find(params[:id])
        @page.destroy
        redirect_to kuhsaft.cms_pages_path
      end
    end
  end
end
