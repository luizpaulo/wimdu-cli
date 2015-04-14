class Property < ActiveRecord::Base
  def full_print
    puts "Title: #{self.title}"
    puts "Type: #{self.property_type}"
    puts "Address: #{self.address}"
    puts "Nightly rate (EUR): #{self.nightly_rate}"
    puts "Max Guests allowed: #{self.max_guests}"
    puts "Email: #{self.email}"
    puts "Phone: #{self.phone}"
  end

  def one_line_print
    puts "#{self.id} - #{self.try(:title)}"
  end
end