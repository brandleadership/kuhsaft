module Kuhsaft
  module Cms
    class BricksController < AdminController

      respond_to :js

      def create
        @brick = params[:brick][:type].constantize.new(params[:brick])
        @brick.save(:validate => false)
      end

      def update
        @brick = Kuhsaft::Brick.find(params[:id])
        @brick.update_attributes(params[:brick])
      end

      def destroy
        @brick = Kuhsaft::Brick.find(params[:id])
        @brick.destroy
      end

    end
  end
end
