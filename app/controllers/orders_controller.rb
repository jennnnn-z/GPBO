class OrdersController < ApplicationController
  # include AppHelpers::Cart
  # include AppHelpers::Shipping
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  # before_action :check_login, except: :show
  # authorize_resource 

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
    @credit_card = CreditCard.new(params[:credit_card_number], params[:expiration_year], params[:expiration_month])
    # if !@order.save 
      if !@credit_card.valid? 
        redirect_to order_path(@order.id) 
        flash[:notice] = "redirected to checkout"
        
      else 
        flash[:notice] = "beep beep"
        redirect_to checkout_path
      end
    # else 
      # flash[:notice] = "creating order"
      # redirect_to order_path(Order.last)
    # end
    
    # if !@credit_card.valid?
    #   # flash[:notice] = @order.errors
    #   redirect_to checkout_path
    # else 
    #   render action: 'new'
    # end

    # @order = Order.new(order_params)
    # if !@order.save 
    #   if !@order.valid? 
    #     flash[:notice] = "WHY"
    #     # flash[:notice] = "bad credit"
    #     redirect_to checkout_path 
    #   else 
        
    #     render action: 'new' 
    #   end 
    # else 
    #   flash[:notice] = "Thank you for ordering from GBPO."
    #   redirect_to order_path(@order)
    # end
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
