module Kuhsaft
  module Cms
    class PagePartsController < AdminController
      
      def index
      end

      def show
      end

      def new
      end

      def create
      end

      def edit
      end

      def update
        if @page_part = Kuhsaft::PagePart::Content.find(params[:id])
          @page_part.reposition params[:reposition] if params[:reposition].present? || params.key?(:reposition)
        end
        render 'update'
      end

      def destroy
        @page_part = Kuhsaft::PagePart::Content.find(params[:id])
        @page_part.destroy
        render 'destroy'
      end
    end
  end
end