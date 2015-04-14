load 'lib/model/property.rb'

class PropertyReader

  def read_fields(args)
    property = load_property(args)
    return unless property

    if property.status == 'completed'
      puts "The property #{property.id} was already completed."
      return
    end

    read_title(property) if property.status == nil
    read_property_type(property) if property.status == 'title'
    read_address(property) if property.status == 'property_type'
    read_nightly_rate(property) if property.status == 'address'
    read_max_guests(property) if property.status == 'nightly_rate'
    read_email(property) if property.status == 'max_guests'
    read_phone(property) if property.status == 'email'

    puts "Great job! Listing property #{property.id} is complete!"
  end

  private
  def load_property(args)
    if args.empty?
      property = Property.create
      puts "Starting with new property #{property.id}."

      property
    else
      begin
        Property.find(args.first)
      rescue ActiveRecord::RecordNotFound
        puts "Property with id #{args.first} not found!"
        nil
      end
    end
  end

  def read_title(property)
    property.title = ask("Title: ") do |q|
      q.validate = lambda { |p| p.length >= 3 }
      q.responses[:not_valid] = "A title needs at least 3 characters."
    end

    save_property(property, 'title')
  end

  def read_property_type(property)
    property.property_type = choose("Property type?", :holiday_room, :apartment, :private_room)

    save_property(property, 'property_type')
  end

  def read_address(property)
    property.address = ask("Address: ") do |q|
      q.validate = lambda { |p| p.length >= 5 }
      q.responses[:not_valid] = "An address needs at least 5 characters."
    end

    save_property(property, 'address')
  end

  def read_nightly_rate(property)
    property.nightly_rate = ask("Nightly rate (in EUR): ") do |q|
      q.validate = lambda { |p| begin Float(p); true rescue ArgumentError false end }
      q.responses[:not_valid] = "Must be a currency value, greater than 0.1."
    end

    save_property(property, 'nightly_rate')
  end

  def read_max_guests(property)
    property.max_guests = ask("Max guests: ", Integer) do |q|
      q.validate = lambda { |p| p.length >= 1 }
      q.responses[:not_valid] = "Max guests must be a number, greater than 1."
    end

    save_property(property, 'max_guests')    
  end

  def read_email(property)
    property.email = ask("Email: ") do |q|
      q.validate = /(.+)@(.+){2,}\.(.+){2,}/ 
      q.responses[:not_valid] = "Please enter a valid email address."
    end

    save_property(property, 'email')
  end

  def read_phone(property)
    property.phone = ask("Phone: ") do |q|
      q.validate = /\+\d\d \d\d\d \d\d\d\d/ # Using an invented format just to validate...
      q.responses[:not_valid] = "A phone must be in format +99 999 9999"
    end

    save_property(property, 'completed')    
  end

  def save_property(property, status)
    property.status = status
    property.save
  end
end