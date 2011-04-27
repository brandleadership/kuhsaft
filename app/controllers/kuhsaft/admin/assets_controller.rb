module Kuhsaft
  module Admin
    class AssetsController < AdminController
      def index
        @assets = Kuhsaft::Asset.by_date
        respond_with @assets
      end
    
      def new
        @asset = Kuhsaft::Asset.new
        respond_with @asset
      end
    
      def create
        @asset = Kuhsaft::Asset.create params[:kuhsaft_asset]
        @asset.save
        respond_with @asset, :location => admin_assets_path
      end
    
      def edit
        @asset = Kuhsaft::Asset.find(params[:id])
        respond_with @asset
      end
    
      def update
        @asset = Kuhsaft::Asset.find(params[:id])
        @asset.update_attributes(params[:kuhsaft_asset])
        respond_with @asset, :location => admin_assets_path
      end
    
      def destroy
        @asset = Kuhsaft::Asset.find(params[:id])
        @asset.destroy
        redirect_to admin_assets_path
      end
    end
  end
end