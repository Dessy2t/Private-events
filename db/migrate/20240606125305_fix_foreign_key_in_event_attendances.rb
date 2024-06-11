class FixForeignKeyInEventAttendances < ActiveRecord::Migration[7.1]
  def change
    # Remove the incorrect foreign key
    remove_foreign_key :event_attendances, :attendees if foreign_key_exists?(:event_attendances, :attendees)

    # Add the correct foreign key
    add_foreign_key :event_attendances, :users, column: :attendee_id
  end
end
