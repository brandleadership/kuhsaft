module RequestMacros

  def sign_in_cms_admin
    before do
      Kuhsaft::Cms::Admin.create(:email => 'max@demo.com',
                                 :password => '123456',
                                 :password_confirmation => '123456')

      visit kuhsaft.pages_path

      within "#new_admin" do
        fill_in "Email", :with => 'max@demo.com'
        fill_in "Password", :with => '123456'
        click_on "Sign in"
      end
    end
  end

end
