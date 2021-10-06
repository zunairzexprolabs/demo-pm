class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy profile ]
  before_action :add_index_breadcrumb, only: [:show, :edit, :new]
  before_action :authenticate
  def index 
    @user = User.where(admin: false).order(:id)
    add_breadcrumbs('All Employees')
    # authorize @user
  end

  def admins 
    @user = User.where(admin: true).order(:id)
    add_breadcrumbs('All Admins')
  end
  
  def new
    @user = User.new
    add_breadcrumbs('New User')
  end

  def create
    @password = Random.rand(111111...999999)
    @user = User.new(user_params)
    @user.password = @password
    
    if @user.save
      UserMailer.with(user: @user).welcome_email.deliver_later
      UserMailer.with(user: @user, password: @password).send_credentials.deliver_later
      flash[:success] = "User was created successfully."
      redirect_to users_path
    else
      render "new"
    end
  end

  def show
    add_breadcrumbs(@user.name)
  end

  def edit
    add_breadcrumbs("Edit/"+@user.name)
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        unless user_params[:password].present?
          format.html { redirect_to users_path, notice: "User was successfully updated." }
        else
          format.html { redirect_to root_path, notice: "Your password is successfully updated - you've to login again." }
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_path, alert: "User was successfully destroyed." }
    end
  end

  def profile
  end

  private

  def user_params
    params.require(:user).permit(:email, :admin, :name, :designation, :password)
  end
  
  def set_user
  @user = User.find(params[:id])
  end

  def add_index_breadcrumb
    add_breadcrumbs('All Users', users_path)
  end

  def authenticate
    authorize User
  end
end
