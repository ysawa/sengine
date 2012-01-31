require 'spec_helper'

describe Movement do
  let :movement do
    Fabricate.build(:movement)
  end

  describe '.save' do
    it 'works!' do
      movement.save.should be_true
    end
  end
end
