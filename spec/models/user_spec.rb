require 'spec_helper'

describe User do
  let(:user) { User.new }
  describe '.save' do
    context 'with invalid attributes' do
      it 'works!' do
        user.save.should be_false
      end
    end

    context 'with invalid attributes' do
      before :each do
        user.attributes = {
          email: 'test@leaping.jp',
          password: 'testtest',
          password_confirmation: 'testtest'
        }
      end

      it 'works!' do
        user.save.should be_true
      end
    end
  end
end
