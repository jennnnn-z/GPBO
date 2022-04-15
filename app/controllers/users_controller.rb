# module Api::V1
  class UsersController < ApplicationController
    before_action :set_user, only: [:show, :edit, :update]
    before_action :check_login
    authorize_resource

    def index 
      # @users = User.all
      @employees = User.employees
    end

    def new 
      @user = User.new 
    end

    def create
      @user = User.new(user_params)
      if @user.save
        flash[:notice] = "Successfully added #{@user.username} as a user."
        redirect_to users_path
      else
        render action: 'new'
      end
    end
    
    def edit 
    end

    def update 
      if @user.update_attributes(user_params)
        flash[:notice] = "Successfully updated #{@user.username}."
        redirect_to users_path
      else
        render action: 'edit'
      end
    end 

    # def destroy 

    # end 


    # def show 
      
    # end

    private 
      def set_user 
        @user = User.find(params[:id])
      end

      def user_params 
        params.require(:user).permit(:username, :password, :password_confirmation, :greeting, :role, :active)
      end
  end
# end