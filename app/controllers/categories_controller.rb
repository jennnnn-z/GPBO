# module Api::V1
  class CategoriesController < ApplicationController
    before_action :set_category, only: [:show, :edit, :update, :destroy]
    before_action :check_login 
    authorize_resource

    def index 
      @active_categories = Category.active 
      @inactive_categories = Category.inactive 
    end

    def new 
      @category = Category.new 

    end

    def create
      @category = Category.new(cat_params)
      if @category.save
        flash[:notice] = "Successfully added #{@category.name} to the system."
        redirect_to categories_path
      else
        render action: 'new'
      end
    end
    
    def edit 
    end

    def update 
      if @category.update_attributes(cat_params)
        flash[:notice] = "Successfully updated #{@category.name}."
        redirect_to categories_path
      else
        render action: 'edit'
      end
    end 

    # def destroy 

    # end 


    # def show 
      
    # end

    private 
      def set_category 
        @category = Category.find(params[:id])
      end

      def cat_params 
        params.require(:category).permit(:name, :active)
      end
  end
# end