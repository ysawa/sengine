require 'spec_helper'

describe AudioController do

  describe "GET 'encode'" do
    context 'with mp3 format' do
      before :each do
        get 'encode', filename: 'put', format: 'mp3'
      end

      it "returns http success" do
        response.should be_success
      end

      it "render text of encoded Data URI Scheme" do
        response.body.should match %r(^data:audio/mp3)
        response.header['Content-Type'].should match(/text\/plain;/)
      end
    end

    context 'with wav format' do
      before :each do
        get 'encode', filename: 'put', format: 'wav'
      end

      it "returns http success" do
        response.should be_success
      end

      it "render text of encoded Data URI Scheme" do
        response.body.should match %r(^data:audio/wav)
        response.header['Content-Type'].should match(/text\/plain;/)
      end
    end

    context 'with ogg format' do
      before :each do
        get 'encode', filename: 'put', format: 'ogg'
      end

      it "returns http success" do
        response.should be_success
      end

      it "render text of encoded Data URI Scheme" do
        response.body.should match %r(^data:audio/ogg)
        response.header['Content-Type'].should match(/text\/plain;/)
      end
    end
  end
end
