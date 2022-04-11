# module Api::V1
  class ItemsController < ApplicationController
    before_action :set_item, only: [:show, :edit, :update, :destroy, :toggle_active, :toggle_feature]
    before_action :check_login, except: :index
    authorize_resource

    def index  
      if params[:category].present?
        cat = Category.find(params[:category])
        @categories = Item.for_category(cat).alphabetical
        @featured_items = Item.for_category(cat).featured.paginate(page: params[:page]).per_page(15)
        @other_items = Item.for_category(cat).where(is_featured: false)
      else 
        @categories = Item.alphabetical
        @featured_items = Item.featured 
        @other_items = Item.where(is_featured: false)
      end
    end

    def show 
      @prices = @item.item_prices
      @similar_items = Item.search(@item.name)
    end

    def toggle_active 
      # @item.active = !@item.active
      if @item.active 
        @item.make_inactive
        redirect_to item_path
        flash[:notice] = "#{@item.name} was made inactive"
      else 
        @item.make_active 
        redirect_to item_path
        flash[:notice] = "#{@item.name} was made active"
      end
    end

    def toggle_feature 
      # @item.is_featured = !@item.is_featured 
      if @item.is_featured == true
        @item.update_attributes(:is_featured => false)
        redirect_to item_path
        flash[:notice] = "#{@item.name} is no longer featured"
      else 
        @item.update_attributes(:is_featured => true)        
        redirect_to item_path
        flash[:notice] = "#{@item.name} is now featured"
      end
    end

    def new 
      @item = Item.new 
    end

    def create 
      @item = Item.new(item_params)
      if @item.save 
        redirect_to @item, notice: "#{@item.name} was added to the system."
      else 
        render action: 'new'
      end
    end

    def edit 
    end

    def update 
      respond_to do |format|
        if @item.update_attributes(item_params)
          format.html { redirect_to(@item, :notice => "Successfully updated #{@item.name}.") }
          format.json { respond_with_bip(@item) }
        else
          format.html { render :action => "edit" }
          format.json { respond_with_bip(@item) }
        end
      end
    end

    def destroy 
      if @item.destroy 
        flash[:notice] = "Successfully removed #{@item.name}."
        redirect_to items_path 
      else 
        redirect_to item_path(@item)
      end
    end

    private 
    def set_item
      @item = Item.find(params[:id])
    end

    def item_params 
      params.require(:item).permit(:name, :description, :color, :inventory_level, :reorder_level, :category_id, :weight, :is_featured, :active)
    end
  end
# end