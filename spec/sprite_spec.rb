require 'spec_helper'

RSpec.describe Sprite do
  it 'has a version number' do
    expect(Sprite::VERSION).not_to be nil
  end
end
