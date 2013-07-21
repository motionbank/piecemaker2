class EventGroup < Sequel::Model(:event_groups)
  
  set_primary_key :id

  one_to_many :events
  many_to_many :users, :join_table => :user_has_event_groups
  
end