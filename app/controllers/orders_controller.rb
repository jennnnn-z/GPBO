class OrdersController < ApplicationController
  # include AppHelpers::Cart
  # include AppHelpers::Shipping
  before_action :set_order, only: [:show, :edit, :update, :destroy, :checkout]
  before_action :check_login
  authorize_resource 

  def index 
    @pending_orders = Order.where(payment_receipt: nil)
    if current_user.role?(:customer)
      @all_orders = Order.all
    elsif current_user.role?(:admin)
      @past_orders = Order.paid
    end
    
  end

  def show 
    @previous_orders = Order.for_customer(current_user.customer_id).paid 
    @order_items = @order.order_items
  end

  def new 
    @order = Order.new 
  end

  def create 
    @order = Order.new(order_params)
    if @order.save 
      flash[:notice] = "Thank you for ordering from GPBO."
      redirect_to order_path(@order)
    else 
      render action: 'new'
    end
  end

  def checkout 
    if !@order.credit_card.valid? || !@order.credit_card.expired? 
      redirect_to checkout_path
    end
  end

  private
  def set_order 
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:credit_card ,:customer_id, :address_id, :date, :products_total, :tax, :shipping, :payment_receipt)
  end

end
