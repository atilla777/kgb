class ApplicationController < ActionController::Base
  include Pundit

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user_session, :current_user
  before_filter :authenticate?
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private
    def authenticate?
      unless current_user
        redirect_to :sign_in
      end
    end

    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end

    def user_not_authorized
      flash[:danger] = t('messages.not_allowed')
      redirect_to(request.referrer || root_path)
    end

end
