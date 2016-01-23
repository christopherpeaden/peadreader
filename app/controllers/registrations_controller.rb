class RegistrationsController < Devise::RegistrationsController

  def edit
    @categories = current_user.categories
  end

  def update
    @categories = current_user.categories
    if @user.update(user_params)
      flash[:notice] = "Account updated."
      redirect_to root_path
    else
      render 'edit'
    end
  end

  private
  
    def user_params
      params.require(:user).permit(:email)
    end
end
