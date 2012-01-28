module DeviseAuthenticationHelper
  def sign_in_user(user = nil)
    @request.env["devise.mapping"] = Devise.mappings[:user]
    if user
      @user = user
    else
      @user = user || Fabricate(:user)
    end
    sign_in @user
  end
end
