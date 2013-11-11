require 'spec_helper'
# Use Carrierwave's provided test matchers
require 'carrierwave/test/matchers'

describe CarPhotoUploader do
  include CarrierWave::Test::Matchers

  let(:uploader) do
    CarPhotoUploader.new(FactoryGirl.build(:registration),
      :car_photo)
  end

  let(:path) do
    Rails.root.join('spec/file_fixtures/valid_car_image.jpg')
  end

  before do
    CarPhotoUploader.enable_processing = true
  end

  after do
    CarPhotoUploader.enable_processing = false
  end

  it 'stores without error' do
    expect(lambda { uploader.store!(File.open(path)) }).to_not raise_error
  end
end
