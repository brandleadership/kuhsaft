require "spec_helper"

feature 'homepage' do
  scenario 'website has no kuhsaft pages' do
    visit root_path
    expect(page).to have_content('getting started')
  end
end
