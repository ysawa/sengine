# -*- coding: utf-8 -*-

module IntegrationTestHelper
  def mail_should_be_sent(count = nil)
    size = ActionMailer::Base.deliveries.size
    if count
      size.should == count
    else
      size.should > 0
    end
  end

  def page_should_have_subtitle(subtitle)
    within('.common_container h2') do
      page.should have_content(subtitle)
    end
  end

  def setup_controller_request(env = {})
    c = ApplicationController.new
    c.request = ActionDispatch::TestRequest.new(env)
    c.set_current_view_context
  end

  %w(user).each do |resource_name|
    resource_table_name = resource_name.tableize
    class_eval <<-EOS
      def #{resource_name}_sign_in_with_post(#{resource_name}, password, remember_me = false)
        params = {
          '#{resource_name}[email]' => #{resource_name}.email,
          '#{resource_name}[password]' => password
        }
        if remember_me
          params['#{resource_name}[remember_me]'] = '1'
        else
          params['#{resource_name}[remember_me]'] = '0'
        end
        post '/#{resource_table_name}/sign_in', params
      end

      def #{resource_name}_sign_in_with_visit(user, password, remember_me = false)
        visit new_#{resource_name}_session_path
        within('form#user_sign_in') do
          fill_in '#{resource_name}[email]', with: user.email
          fill_in '#{resource_name}[password]', with: password
          check '#{resource_name}[remember_me]' if remember_me
          click_button 'Sign in'
        end
      end
    EOS
  end
end
