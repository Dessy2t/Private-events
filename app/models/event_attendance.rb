class EventAttendance < ApplicationRecord
    belongs_to :event
    belongs_to :attendee, class_name: 'User'
  
    validates :event, presence: true
    validates :attendee, presence: true
end
  