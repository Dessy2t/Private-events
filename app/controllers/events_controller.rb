class EventsController < ApplicationController
    before_action :authenticate_user!, only: [:new, :create, :index]
    before_action :authorize_creator, only: [:edit, :update, :destroy]
    before_action :authorize_access, only: [:show]
  
    def index
      @events = Event.user_accessible(current_user)
    end
  
    def show
      @event = Event.find(params[:id])
    end
  
    def new
      @event = Event.new
    end
  
    def edit
      @event = Event.find(params[:id])
    end
  
    def create
      @event = current_user.created_events.build(event_params)
  
      # attended_emails.each do |email|
      #   attendee_user = User.find_by(email: email)
      #   @event.attendees << attendee_user if attendee_user
      # end
  
      if @event.save
        redirect_to @event, notice: 'Event was successfully created.'
      else
        render :new, status: :unprocessable_entity
      end
    end
  
    def update
      @event = Event.find(params[:id])
  
      # attendee_emails.each do |email|
      #   attendee_user = User.find_by(email: email)
      #   @event.attendees << attendee_user if valid_attendee?(attendee_user)
      # end
  
      if @event.update(event_params)
        redirect_to @event, notice: 'Event was successfully updated.'
      else
        render :edit, status: :unprocessable_entity
      end
    end
  
    def destroy
      @event = Event.find(params[:id]).destroy
      redirect_to events_url, notice: 'Event was successfully deleted.'
    end
  
    private
  
    # def attendee_emails
    #   params[:event][:attendee_emails].split(',').map(&:strip)
    # end
  
    # def valid_attendee?(attendee)
    #   attendee_user && !@event.attendees.include?(attendee)
    # end
  
    def authorize_access
      return if Event.find_by(id: params[:id])&.accessible_by?(current_user)
  
      redirect_to events_url, alert: 'You do not have access to that event!'
    end
  
    def authorize_creator
      return if Event.find(params[:id]).creator == current_user
  
      redirect_to events_url, alert: 'You are not allowed to do that!'
    end
  
    def event_params
      params.require(:event).permit(:name, :date, :location, :creator_id, :attendee_emails)
    end
end