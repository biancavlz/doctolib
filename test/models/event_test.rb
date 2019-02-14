require "test_helper"

class EventTest < ActiveSupport::TestCase
  setup do
    Event.create kind: "opening", starts_at: DateTime.parse("2014-08-04 09:30"), ends_at: DateTime.parse("2014-08-04 12:30"), weekly_recurring: true
    Event.create kind: "appointment", starts_at: DateTime.parse("2014-08-11 10:30"), ends_at: DateTime.parse("2014-08-11 11:30")
  end
  
  test "one simple test example" do    
    availabilities = Event.availabilities DateTime.parse("2014-08-10")
    assert_equal Date.new(2014, 8, 10), availabilities[0][:date]
    assert_equal [], availabilities[0][:slots]
    
    assert_equal Date.new(2014, 8, 11), availabilities[1][:date]
    assert_equal ["9:30", "10:00", "11:30", "12:00"], availabilities[1][:slots]
    
    assert_equal [], availabilities[2][:slots]
    assert_equal Date.new(2014, 8, 16), availabilities[6][:date]
    assert_equal 7, availabilities.length
  end
  
  test "Adding two openings more" do
    Event.create kind: "opening",starts_at: DateTime.parse("2014-08-07 09:00"), ends_at: DateTime.parse("2014-08-07 12:30"), weekly_recurring: true
    Event.create kind: "opening",starts_at: DateTime.parse("2014-08-08 13:00"),ends_at: DateTime.parse("2014-08-08 15:00"),weekly_recurring: true

    availabilities = Event.availabilities DateTime.parse("2014-08-10")

    assert_equal Date.new(2014, 8, 10), availabilities[0][:date]
    assert_equal [], availabilities[0][:slots]
    
    assert_equal Date.new(2014, 8, 14), availabilities[4][:date]
    assert_equal ["9:00", "9:30", "10:00", "10:30", "11:00", "11:30", "12:00"], availabilities[4][:slots]
    
    assert_equal Date.new(2014, 8, 15), availabilities[5][:date]
    assert_equal ["13:00", "13:30", "14:00", "14:30"], availabilities[5][:slots]
    
    assert_equal 7, availabilities.length
  end

  test "Adding two appointments more" do
    Event.create kind: "appointment", starts_at: DateTime.parse("2014-08-12 09:30"), ends_at: DateTime.parse("2014-08-12 11:30")
    Event.create kind: "appointment", starts_at: DateTime.parse("2014-08-13 13:30"), ends_at: DateTime.parse("2014-08-13 15:30")
    
    availabilities = Event.availabilities DateTime.parse("2014-08-10")

    assert_equal Date.new(2014, 8, 10), availabilities[0][:date]
    assert_equal [], availabilities[0][:slots]

    assert_equal Date.new(2014, 8, 11), availabilities[1][:date]
    assert_equal ["9:30", "10:00", "11:30", "12:00"], availabilities[1][:slots]

    assert_equal Date.new(2014, 8, 12), availabilities[2][:date]
    assert_equal [], availabilities[2][:slots]

    assert_equal Date.new(2014, 8, 13), availabilities[3][:date]
    assert_equal [], availabilities[3][:slots]

    assert_equal Date.new(2014, 8, 14), availabilities[4][:date]
    assert_equal [], availabilities[4][:slots]

    assert_equal Date.new(2014, 8, 15), availabilities[5][:date]
    assert_equal [], availabilities[5][:slots]

    assert_equal Date.new(2014, 8, 16), availabilities[6][:date]
    assert_equal [], availabilities[6][:slots]
    
    assert_equal 7, availabilities.length
  end

  test "with another date" do    
    availabilities = Event.availabilities DateTime.parse("2014-08-05")
    
    assert_equal Date.new(2014, 8, 5), availabilities[0][:date]
    assert_equal [], availabilities[0][:slots]
    
    assert_equal Date.new(2014, 8, 6), availabilities[1][:date]
    assert_equal [], availabilities[1][:slots]

    assert_equal Date.new(2014, 8, 7), availabilities[2][:date]
    assert_equal [], availabilities[2][:slots]

    assert_equal Date.new(2014, 8, 8), availabilities[3][:date]
    assert_equal [], availabilities[3][:slots]

    assert_equal Date.new(2014, 8, 9), availabilities[4][:date]
    assert_equal [], availabilities[4][:slots]

    assert_equal Date.new(2014, 8, 10), availabilities[5][:date]
    assert_equal [], availabilities[5][:slots]

    assert_equal Date.new(2014, 8, 11), availabilities[6][:date]
    assert_equal ["9:30", "10:00", "11:30", "12:00"], availabilities[6][:slots]
    
    assert_equal 7, availabilities.length
  end

  test "with no recurring openings " do
    Event.create kind: "opening",starts_at: DateTime.parse("2014-08-05 09:00"), ends_at: DateTime.parse("2014-08-05 12:30"), weekly_recurring: false
    availabilities = Event.availabilities DateTime.parse("2014-08-10")

    assert_equal Date.new(2014, 8, 10), availabilities[0][:date]
    assert_equal [], availabilities[0][:slots]

    assert_equal Date.new(2014, 8, 11), availabilities[1][:date]
    assert_equal ["9:30", "10:00", "11:30", "12:00"], availabilities[1][:slots]

    assert_equal Date.new(2014, 8, 12), availabilities[2][:date]
    assert_equal [], availabilities[2][:slots]
  end
end
