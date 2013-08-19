# Add default kuhsaft brick types
brick_types = [
  { class_name: 'Kuhsaft::TextBrick', group: 'elements' },
  { class_name: 'Kuhsaft::LinkBrick', group: 'elements' },
  { class_name: 'Kuhsaft::VideoBrick', group: 'elements' },
  { class_name: 'Kuhsaft::AccordionBrick', group: 'elements' },
  { class_name: 'Kuhsaft::AccordionItemBrick', group: 'elements' },
  { class_name: 'Kuhsaft::TwoColumnBrick', group: 'layout_elements' },
  { class_name: 'Kuhsaft::SliderBrick', group: 'elements' },
  { class_name: 'Kuhsaft::ImageBrick', group: 'elements' },
  { class_name: 'Kuhsaft::PlaceholderBrick', group: 'elements' },
  { class_name: 'Kuhsaft::AnchorBrick', group: 'elements' },
  { class_name: 'Kuhsaft::AssetBrick', group: 'elements' }
]

brick_types.each do |bt|
  brick_type = Kuhsaft::BrickType.find_or_create_by(class_name: bt[:class_name])
  brick_type.update! bt
end

