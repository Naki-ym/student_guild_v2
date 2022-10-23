class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def admin_user
    if current_user.admin == false || current_user.id != 1
      flash[:notice] = "管理者権限のあるアカウントのみアクセスできます"
      redirect_to("/users/#{current_user.id}")
    end
  end

  private
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up,keys:[:name, :email, :icon, :icon_cache])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :email, :icon, :icon_cache])
  end  
end
