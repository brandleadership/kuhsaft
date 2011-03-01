require 'kuhsaft/engine'

describe Kuhsaft do
  
  it 'should be a rails engine' do
    defined?(Kuhsaft::Engine).should be_true
  end

end