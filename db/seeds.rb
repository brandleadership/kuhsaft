# Add default backend user
Kuhsaft::Cms::Admin.create(:email => 'admin@screenconcept.ch', :password => 'bambus')

# Add default kuhsaft brick types

Kuhsaft::BrickType.create(:class_name => 'Kuhsaft::TextBrick', :group => 'elements')
Kuhsaft::BrickType.create(:class_name => 'Kuhsaft::LinkBrick', :group => 'elements')
Kuhsaft::BrickType.create(:class_name => 'Kuhsaft::TwoColumnBrick', :group => 'layout_elements')
Kuhsaft::BrickType.create(:class_name => 'Kuhsaft::SliderBrick', :group => 'elements')
Kuhsaft::BrickType.create(:class_name => 'Kuhsaft::ImageBrick', :group => 'elements')
