class User < ApplicationRecord
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :validatable
  
    has_many :created_events, class_name: 'Event', foreign_key: 'creator_id'
    has_many :event_attendances, foreign_key: 'attendee_id'
    has_many :attended_events, class_name: 'Event', through: :event_attendances, source: :event, foreign_key: 'event_id'
  
    validates :username, presence: true
end
  