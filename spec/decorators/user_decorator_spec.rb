require 'spec_helper'

describe UserDecorator do
  before :each do
    ApplicationController.new.set_current_view_context
  end
end
