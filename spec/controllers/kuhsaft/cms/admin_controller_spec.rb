require 'spec_helper'

describe Kuhsaft::Cms::AdminController do
  subject { described_class }

  it { expect(Kuhsaft::Cms::AdminController.ancestors).to include(InheritedResources::Base) }
end
