class CartController < ApplicationController
  include AppHelpers::Cart 
  include AppHelpers::Shipping
  
  # before_action :set_cart
  # before_action :check_login
  # authorize_resource

  def new 
    create_cart
  end

  def show 
    @items_in_cart = get_list_of_items_in_cart
    @subtotal = calculate_cart_items_cost
    @shipping_cost = calculate_cart_shipping
    @total = calculate_cart_items_cost + calculate_cart_shipping
  end

  def add_item 
    # @item = Item.find(params[:id])
    add_item_to_cart(params[:item_id])
    flash[:notice] = "#{Item.find(params[:item_id]).name}  was added to cart."
    redirect_to view_cart_path
  end

  def remove_item 
    # @item = Item.find(params[:item_id])
    remove_item_from_cart(params[:id])
    flash[:notice] = "#{Item.find(params[:item_id]).name} was removed from cart."
    redirect_to view_cart_path
  end

  def empty_cart 
    clear_cart 
    flash[:notice] = "Cart is emptied."
    redirect_to view_cart_path
  end

  def checkout 
    @items_in_cart = get_list_of_items_in_cart
    @subtotal = calculate_cart_items_cost
    @shipping_cost = calculate_cart_shipping
    @total = calculate_cart_items_cost + calculate_cart_shipping
    @addresses = Address.where(customer: current_user.customer_id)
    @order = Order.new 
  end

  # private 

  # def set_cart 
  #   @cart = session[:cart]
  # end


end
