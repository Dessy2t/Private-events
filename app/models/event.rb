class Event < ApplicationRecord
    belongs_to :creator, class_name: 'User'
    has_many :event_attendances
    has_many :attendees, class_name: 'User', through: :event_attendances, source: :attendee
  
    validates :creator, presence: true
    validates :date, presence: true
    validates :name, presence: true
  
    scope :past, -> { where('date < ?', Date.today).order(date: :desc) }
    scope :future, -> { where('date >= ?', Date.today).order(date: :asc) }
  
    def self.user_accessible(user)
      left_joins(:attendees)
        .where(events: { creator_id: user.id })
        .or(where(users: { id: user.id }))
        .distinct
    end
  
    def accessible_by?(user)
      return true if user.created_events.include?(self) || attendees.include?(user)
  
      false
    end
  
    def attendee_emails
      attendees.pluck(:email).join(', ')
    end
  
    def attendee_emails=(emails)
      self.attendees = emails.split(',').map(&:strip).uniq.map do |email|
        User.find_by(email: email)
      end.compact
    end
  
end
  