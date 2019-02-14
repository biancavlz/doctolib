class Event < ApplicationRecord
  scope :openings,     -> { where(kind: 'opening')}
  scope :appointments, -> { where(kind: 'appointment') }

  scope :weekly_openings,     -> { openings.where('weekly_recurring = ?', true) }
  scope :booked_appointments, -> (date){ appointments.where(starts_at: date.midnight..date.end_of_day).order(:starts_at) }

  TO_HOUR_FORMAT = "%-k:%M"
  
  def self.availabilities(date)
    date = date.to_date
    gets_results(date)
  end

  private

  def self.list_of_hours_available(per_date)
    # Gets booked hours
    booked_hours = []
    booked_appointments(per_date).map do |booked|
      starts_at = booked.starts_at
      
      while starts_at < booked.ends_at
        hour = starts_at.strftime(TO_HOUR_FORMAT)
        booked_hours.push(hour)
        
        starts_at = starts_at + 30.minute
      end
    end

    #Gets opening hours
    opening_hours = []
    weekly_openings.map do |opening|
      start_opening = opening.starts_at
      days_to_next_openning = TimeDifference.between(start_opening.midnight, per_date.midnight).in_days
      
      if (start_opening <= per_date) && (days_to_next_openning.to_i == 7)
        while (start_opening < opening.ends_at) 
          hour = start_opening.strftime(TO_HOUR_FORMAT)
          opening_hours.push(hour)
        
          start_opening = start_opening + 30.minute
        end
      end
    end
    
    # List of available hours, excluding booked ones
    list = [] 
    opening_hours.map { |hour| list.push(hour) unless booked_hours.include?(hour) }
    return list
  end

  def self.gets_results(date)
    availabilities = []
    
    7.times do
      availabilities.push({
        date:  date,
        slots: list_of_hours_available(date)
      })
      date = date.next_day
    end
  
    return availabilities
  end
end
