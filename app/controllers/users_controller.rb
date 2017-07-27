class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :set_organizations, only: [:new, :create, :edit, :update]
  before_action :set_previous_action, only: [:new, :edit, :destroy]
  before_action :reset_previous_action, only: [:index]

  # GET /users
  # GET /users.json
  def index
    authorize User
    @users = policy_scope(User).includes(:organization)
  end

  # GET /users/1
  # GET /users/1.json
  def show
    authorize @user
    set_user_roles
  end

  # GET /users/new
  def new
    authorize User
    if params[:user].present?
      if params[:user][:organization_id].present?
        organization = Organization.find(params[:user][:organization_id])
        h = {name: organization.name,
             organization_id: organization.id}
      else
        h = {}
      end
      @user = User.new(h)
    else
      @user = User.new
    end
  end

  # GET /users/1/edit
  def edit
    authorize @user
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    authorize @user
    if @user.active == false
    end

    respond_to do |format|
      if @user.save
        flash[:success] = t('flashes.create', model: User.model_name.human)
        format.html { redirect_to session.delete(:return_to) || users_path }
        format.json { render :show, status: :created, location: @user }
        protocol_action("создание пользователя #{@user.name}")
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    authorize @user
    respond_to do |format|
      if @user.update(user_params)
        flash[:success] = t('flashes.update', model: User.model_name.human)
        format.html { redirect_to session.delete(:return_to) || users_path}
        format.json { render :show, status: :ok, location: @user }
        protocol_action("редактирование пользователя #{@user.name}")
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    authorize @user
    @user.destroy
    protocol_action("удаление пользователя #{@user.name}")
    respond_to do |format|
      flash[:success] = t('flashes.destroy', model: User.model_name.human)
      format.html { redirect_to session.delete(:return_to) }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  def set_organizations
    @organizations = policy_scope(Organization).order(:name)
  end

  def set_user_roles
    # глобальные роли
    @roles = @user.roles
    user_roles_names = @roles.map{|role| role.name.to_sym}
    @allowed_roles = User.roles.keys.select{|role_name| user_roles_names.exclude?(role_name) }
    # роли организации (к информации каких организаций  имеет доступ пользователь)
    @assigned_organizations = Organization.with_role(Organization.beholder_role_name, @user)
    @allowed_organizations = Organization.all
    @allowed_organizations = @allowed_organizations.select{ |organization| @assigned_organizations.exclude?(organization) }
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:name, :phone, :job, :description, :organization_id, :department,
                                :email, :password, :password_confirmation, :active)
  end

  def set_previous_action
      session[:return_to] ||= request.env['HTTP_REFERER']
  end

  def reset_previous_action
      session.delete(:return_to)
  end
end
