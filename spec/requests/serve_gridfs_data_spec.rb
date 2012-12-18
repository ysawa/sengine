# -*- coding: utf-8 -*-

require 'spec_helper'

describe ServeGridfsData do

  before :each do
    @tag = Fabricate.build(:tag)
    @file = File.open(File.join(Rails.root, '/app/assets/images/rails.png'))
    @tag.image = @file
    @tag.save
  end

  describe 'uploaded image' do

    it 'can be downloaded' do
      get @tag.image.url
      response.body.should_not == 'File not found.'
    end

    it 'content_type can be set' do
      get @tag.image.url
      response.headers['Content-Type'].should == 'image/png'
    end
  end

  describe 'unknown file' do

    it 'cannot be downloaded' do
      get @tag.image.url + '_'
      response.body.should == 'File not found.'
    end
  end
end
