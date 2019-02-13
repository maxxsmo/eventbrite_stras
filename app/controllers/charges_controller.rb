class ChargesController < ApplicationController
  
  def index 
    @event = Event.find(params[:event_id])
  end
  
  def new
    @event = Event.find(params[:event_id])
    @attendance = Attendance.new
    @amount = @event.price
  end
  
  def create
    # Amount in cents
    @amount = Event.find(params[:event_id]).price
  
    customer = Stripe::Customer.create(
      :email => params[:stripeEmail],   
      :source  => params[:stripeToken]   
    )
  
    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => @amount,
      :description => 'Rails Stripe customer',
      :currency    => 'usd'
    )

    @attendance = Attendance.new(event_id: params[:event_id],
                                stripe_customer_id: customer.id,
                                user_id: current_user.id)
  
    # rescue Stripe::CardError => e
    # flash[:error] = e.message

    if @attendance.save
      redirect_to event_path(@event) 
    else
      puts attendance.errors.full_messages
      render 'new'
    end 
  end

  def show

  end
end
