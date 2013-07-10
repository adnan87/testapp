class Takeoff < ActiveRecord::Base
  validate :dates_must_not_overlap
  #before_validation :add_correct_time_to_date

  attr_accessible :active, :enddate, :name, :startdate, :sale_period
  validates :name, :startdate, :enddate, :presence => true
  
  belongs_to :candidate
  def add_correct_time_to_date
    self.startdate = self.startdate.beginning_of_day
    self.enddate = self.enddate.end_of_day
  end

  
  def dates_must_not_overlap
    # if i'm editing a record, don't include itself in the overlap check
    #if self.startdate > self.enddate or self.enddate < self.startdate
      #self.errors[:base] << "Invalid date range"
    #end
    
    if self.new_record?
      overlapping_events = Takeoff.find(:all, :conditions => ["(? > startdate and ? < enddate) or (? > startdate and ? < enddate)", self.startdate, self.startdate, self.enddate, self.enddate])
    else
      overlapping_events = Takeoff.find(:all, :conditions => ["((? > startdate and ? < enddate) or (? > startdate and ? < enddate)) and id != ?", self.startdate, self.startdate, self.enddate, self.enddate, self.id])
    end
    #SELECT "takeoffs".* FROM "takeoffs" WHERE ((('2013-02-18 00:00:00.000000' > startdate and '2013-02-18 00:00:00.000000' < enddate) or ('2013-03-06 23:59:59.999999' > startdate and '2013-03-06 23:59:59.999999' < enddate)) and id != 2)
    #if it found overlapping events, throw an error
    if overlapping_events.size > 0
      event_titles = []
      for event in overlapping_events
        event_titles << event.name
      end
        errors[:base] << "Date range overlaps with these takeoffs: #{event_titles.join(', ')}"
    end
  end
  
  def self.UpcomingTakeOff(activetakeoff)
    if activetakeoff
      find(:first, :conditions => ['id > ? AND startdate >= ?', "#{activetakeoff}", "#{DateTime.now.beginning_of_day}"])
    end
  end
end
