class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :handle_post_creation, :update_object, :destroy_object

  def handle_post_creation model
    respond_to do |format|
      if mdoel.save
        format.html { redirect_to model, notice: '#{model.class.name.titleize} was successfully created.' }
        format.json { render :show, status: :created, location: model }
      else
        format.html { render :new }
        format.json { render json: model.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_object model, params
    respond_to do |format|
      if model.update(params)
        format.html { redirect_to model, notice: '#{model.class.name.titleize} was successfully updated.' }
        format.json { render :show, status: :ok, location: model }
      else
        format.html { render :edit }
        format.json { render json: model.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy_object model
    model.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: "#{model.class.name.titleize} was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:first_name, :last_name, :email, :password, :password_confirmation) }
  end
end
