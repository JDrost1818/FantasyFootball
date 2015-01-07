class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def destroy_object model
    model.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: "#{model.class.name.titleize} successfully destroyed." }
      format.json { head :no_content }
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:first_name, :last_name, :email, :password, :password_confirmation) }
  end

  helper_method :destroy_object
end
