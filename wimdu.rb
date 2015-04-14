#!/usr/bin/env ruby

require 'rubygems'
require 'commander/import'

load 'config/active_record_config.rb'
load 'lib/service/property_reader.rb'

program :version, '0.0.1'
program :description, 'Wimdu CLI'

trap "SIGINT" do
  puts "\r\n"
  puts "\n"
  puts "^C"
  puts "\r"
  puts "Remember: You could use ./wimdu.rb continue <ID> to continue..."
  exit 130
end

command :list do |c|
  c.syntax = 'wimdu list'
  c.action do |args, options|
    properties = Property.where(status: 'completed')

    if properties.empty?
      puts "No properties found."
    else
      puts "Found #{properties.size} offer(s)."
      properties.each { |property| puts "#{property.id} - #{property.title}" } 
    end
  end
end

command :uncompleted do |c|
  c.syntax = 'wimdu uncompleted'
  c.action do |args, options|
    properties = Property.where("status != 'completed' OR status IS NULL")

    if properties.empty?
      puts "No uncompleted properties found."
    else
      puts "Found #{properties.size} uncompleted offer(s)."
      properties.each { |property| puts "#{property.id} - #{property.try(:title)}" } 
    end
  end
end

command :new do |c|
  c.syntax = 'wimdu new'
  c.action do |args, options|
    PropertyReader.new.read_fields([])
  end
end

command :show do |c|
  c.syntax = 'wimdu new'
  c.action do |args, options|
    if args.empty?
      puts "You must pass an id to retrieve a property info."
      return
    end
    begin
      property = Property.find(args.first)
      puts "Title: #{property.title}"
      puts "Type: #{property.property_type}"
      puts "Address: #{property.address}"
      puts "Nightly rate (EUR): #{property.nightly_rate}"
      puts "Max Guests allowed: #{property.max_guests}"
      puts "Email: #{property.email}"
      puts "Phone: #{property.phone}"
    rescue ActiveRecord::RecordNotFound
      puts "Property with id: #{args.first} was not found!"
    end
  end
end

command :continue do |c|
  c.syntax = 'wimdu continue [code]'
  c.action do |args, options|
    if args.empty?
      puts "You must pass an id to continue filling a property info."
      return
    end
    PropertyReader.new.read_fields(args)
  end
end