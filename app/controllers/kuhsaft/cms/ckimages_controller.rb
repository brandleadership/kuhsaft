module Kuhsaft
  module Cms
    class CkimagesController < AdminController
      layout 'kuhsaft/cms/ckimages'
      skip_before_action :verify_authenticity_token
      respond_to :html, :js

      def create
        @func_num = params["CKEditorFuncNum"]
        @ck_editor = params["CKEditor"]
        @ckimage = Kuhsaft::Ckimage.create(file: params[:upload])
      end

      def index
        @func_num = params["CKEditorFuncNum"]
        @ck_editor = params["CKEditor"]
        @ckimages = Kuhsaft::Ckimage.all
      end

      def destroy
        @ckimage = Kuhsaft::Ckimage.find(params[:id])
        @ckimage.destroy
      end
    end
  end
end
