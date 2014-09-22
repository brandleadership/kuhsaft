require 'kuhsaft/page_tree'

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
        @page = Kuhsaft::Page.create(page_params)

        if @page.valid?
          flash[:success] = t('layouts.kuhsaft.cms.flash.success', subject: Kuhsaft::Page.model_name.human)
          respond_with @page, location: kuhsaft.edit_cms_page_path(@page)
        else
          render 'new'
        end
      end

      def edit
        @page = Kuhsaft::Page.find(params[:id])
        @page.published ||= Kuhsaft::PublishState::UNPUBLISHED
        @page.bricks.each { |brick| brick.valid? }
        respond_with @page
      end

      def update
        @page = Kuhsaft::Page.find(params[:id])
        if @page.update_attributes(page_params)
          flash[:success] = t('layouts.kuhsaft.cms.flash.success', subject: Kuhsaft::Page.model_name.human)
          respond_with @page, location: kuhsaft.edit_cms_page_path(@page)
        else
          render 'edit'
        end
      end

      def destroy
        @page = Kuhsaft::Page.find(params[:id])
        @page.destroy
        redirect_to kuhsaft.cms_pages_path
      end

      def sort
        Kuhsaft::PageTree.update(params[:page_tree])
      end

      def mirror
        @page = Kuhsaft::Page.find(params[:page_id])

        unless @page.bricks.empty?
          if params[:rutheless] == 'true' || @page.bricks.unscoped.where(locale: params[:target_locale]).empty?
            @page.clear_bricks_for_locale(params[:target_locale])
            params[:failed_bricks] = @page.clone_bricks_to(params[:target_locale])
            params[:rutheless] = 'true'
          end
        end

        respond_to :js, :html
      end

      private

      def page_params
        safe_params = [
          :title, :page_title, :slug, :redirect_url, :url, :page_type, :parent_id,
          :keywords, :description, :published, :position, :google_verification_key
        ]
        params.require(:page).permit(*safe_params)
      end
    end
  end
end
