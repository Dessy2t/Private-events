class EnrollmentsController < ApplicationController
   before_action :authenticate_user!, only: [:create]
   before_action :set_event, only: [:create, :destroy]
   before_action :already_enrolled, only: [:create]

    def create
       @event_attendance = EventAttendance.new(event_id: @event.id, attendee: current_user)

        if @event_attendance.save
          redirect_to @event, notice: "Successfully enrolled in #{@event.name}"
        else
           render :new, status: :unprocessable_entity
        end
    end

    def destroy
        event_attendance = EventAttendance.find_by(event: @event, attendee: current_user)

        if event_attendance&.destroy
           redirect_to @event, status: :see_other, notice: 'Successfully unenrolled.'
        else
           redirect_to @event, status: :unprocessable_entity, alert: 'Unable to unenroll.'
        end
    end

    private

    def set_event
        @event = Event.find_by(id: params[:event_id])
        redirect_to events_path, alert: "Event not found." unless @event
    end

    def already_enrolled
        redirect_to @event, notice: "You are already enrolled in #{@event.name}" if @event.attendees.include?(current_user)
    end
end