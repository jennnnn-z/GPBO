class CustomersController < ApplicationController
  before_action :set_customer, only: [:show, :edit, :update, :destroy]
  before_action :check_login, except: [:new, :create]
  authorize_resource
  
  def index
    @active_customers = Customer.active.alphabetical
    @inactive_customers = Customer.inactive.alphabetical
  end
  
  def show
    @previous_orders = @customer.orders.paid
    @addresses = @customer.addresses
  end
  
  def new
    @customer = Customer.new
  end
  
  def edit
  end
  
  def create
    @customer = Customer.new(cust_params)
    @user = User.new(user_params)
    @user.role = "customer"
    if !@user.save
      @customer.valid?
      render action: 'new'
    else
      @customer.user_id = @user.id
      if @customer.save
        flash[:notice] = "#{@customer.proper_name} was added to the system."
        redirect_to customer_path(@customer)
      else
        render action: 'new'
      end
    end
  end
  
  def update
    respond_to do |format|
      if @customer.update_attributes(cust_params)
        format.html {redirect_to(@customer, :notice => "Successfully  updated #{@customer.proper_name}.")}
        format.json { respond_with_bip(@customer) }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@customer) }
      end
    end
  end
  
  # def destroy
  
  # end
  
  private
    def set_customer
      @customer = Customer.find(params[:id])
    end
  
    def cust_params
      params.require(:customer).permit(:first_name, :last_name, :email, :phone, :active, :username, :password, :password_confirmation, :greeting)
        # :first_name, :last_name, :email, :phone, :active, :username, :password, :password_confirmation,:role, :greeting)
    end
  
    def user_params
      params.require(:customer).permit(:username, :password, :password_confirmation, :greeting, :active)
    end
  
 end
 
 