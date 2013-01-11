require 'spec_helper'

describe 'Admin authentication' do
  sign_in_cms_admin

  it 'redirects to the pages index' do
    current_path.should == kuhsaft.cms_pages_path
  end
end
