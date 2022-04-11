class OrdersController < ApplicationController
  # include AppHelpers::Cart
  # include AppHelpers::Shipping
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :check_login
  authorize_resource 

  def index 
    @pending_orders = Order.where(payment_receipt: nil)
    if current_user.role?(:customer)
      @all_orders = Order.for_customer(current_user.customer_id)
    elsif current_user.role?(:admin)
      @past_orders = Order.paid
    end
    
  end

  def show 
    @previous_orders = Order.for_customer(current_user.customer_id).paid 
    @order_items = @order.order_items
  end

  def new 
  end

  def create 
    @order = Order.new(order_params)
    @order.date = Date.current
    @order.products_total = 0
    # @order.update(tax: 0)
    @order.shipping = 0
    # @order.payment_receipt = ''
    # @credit_card = CreditCard.new(params[:credit_card_number], params[:expiration_year], params[:expiration_month])
    if @order.save 
      flash[:notice] = "Thank you for ordering from GPBO."
      redirect_to order_path(@order)
    else 
      redirect_to checkout_path
      # render action: 'new' 
    end
  end

  # def checkout 
    
  # end

  private
  def set_order 
    @order = Order.find(params[:id])
    
  end

  def order_params
    params.require(:order).permit(:credit_card_number, :expiration_year, :expiration_month, :customer_id, :address_id, :date, :products_total, :tax, :shipping, :payment_receipt)
  end

end
