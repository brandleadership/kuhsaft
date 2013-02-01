module Kuhsaft
  module Cms
    class BricksController < AdminController

      respond_to :html, :js

      def create
        @brick = params[:brick][:type].constantize.new(params[:brick])
        @brick.save(:validate => false)
      end

      def update
        @brick = Kuhsaft::Brick.find(params[:id])
        @brick.update_attributes(params[:brick])

        #
        # rails will fall back to html if ajax can't be used
        # this is the case with the image brick, because ajax does not
        # support image uploads
        #
        respond_with @brick do |format|
          format.js
          format.html { redirect_to edit_cms_page_path(@brick.parents.first) }
        end
      end

      def destroy
        @brick = Kuhsaft::Brick.find(params[:id])
        @parent_brick = @brick.brick_list
        @brick.destroy
      end

    end
  end
end
