require "spec_helper"
require "pry"
load 'config/active_record_config.rb'
load 'lib/model/property.rb'

describe "Wimdu CLI" do
  let(:exe) { File.expand_path('../../bin/wimdu', __FILE__) }

  describe "new" do
    let(:cmd) { "#{exe} new" }

    it "allows for entering data" do
      process = run_interactive(cmd)
      expect(process.output).to include("Starting with new property")
      expect(process.output).to include("Title: ")
      type "My"
      expect(process.output).to include("A title needs at least 3 characters")
      type "My title"
      expect(process.output).to include("Property type?\n1. holiday_room\n2. apartment\n3. private_room")
      type "20"
      expect(process.output).to include("You must choose one of ")
      type "2"
      expect(process.output).to include("Address: ")
      type "My"
      expect(process.output).to include("An address needs at least 5 characters")
      type "My address"
      expect(process.output).to include("Nightly rate (in EUR): ")
      type "Aaaaa"
      expect(process.output).to include("must enter a valid")
      type "12.3"
      expect(process.output).to include("Max guests: ")
      type "aaaa"
      expect(process.output).to include("You must enter a valid Integer")
      type "2"
      expect(process.output).to include("Email: ")
      type "iamnotanemail"
      expect(process.output).to include("Please enter a valid email address")
      type "blabla@email.com"
      expect(process.output).to include("Phone: ")
      type "My address" 
      expect(process.output).to include("A phone must be in format +99 999 9999")
      type "+99 999 9999"
      expect(process.output).to include("Max guests must be a number, greater than 1")
      expect(process.output).to include("Great job! Listing property")
    end
  end

  describe "continue" do

    describe "on title" do
      let(:property) { Property.new(title: "Title") }
      let(:cmd) { "#{exe} continue #{property.id}" }
      before { property.save }

      it "allows for entering data" do
        process = run_interactive(cmd)
        expect(process.output).to include("Property type?\n1. holiday_room\n2. apartment\n3. private_room")
      end
    end

    describe "on property_type" do
      let(:property) { Property.new(title: "Title", property_type: "apartment") }
      let(:cmd) { "#{exe} continue #{property.id}" }
      before { property.save }

      it "allows for entering data" do
        process = run_interactive(cmd)
        expect(process.output).to include("Address: ")
      end
    end

    describe "on nightly_rate" do
      let(:property) { Property.new(title: "Title", property_type: "apartment", address: "I am an address") }
      let(:cmd) { "#{exe} continue #{property.id}" }
      before { property.save }

      it "allows for entering data" do
        process = run_interactive(cmd)
        expect(process.output).to include("Nightly rate (in EUR): ")
      end
    end

    describe "on max_guests" do
      let(:property) { Property.new(title: "Title", property_type: "apartment", address: "I am an address", nightly_rate: 10.2) }
      let(:cmd) { "#{exe} continue #{property.id}" }
      before { property.save }

      it "allows for entering data" do
        process = run_interactive(cmd)
        expect(process.output).to include("Max guests: ")
      end
    end

    describe "on email" do
      let(:property) { Property.new(title: "Title", property_type: "apartment", address: "I am an address", nightly_rate: 10.2, max_guests: 10) }
      let(:cmd) { "#{exe} continue #{property.id}" }
      before { property.save }

      it "allows for entering data" do
        process = run_interactive(cmd)
        expect(process.output).to include("Email: ")
      end
    end

    describe "on phone" do
      let(:property) { Property.new(title: "Title", property_type: "apartment", address: "I am an address", nightly_rate: 10.2, max_guests: 10, email: "blabla@email.com") }
      let(:cmd) { "#{exe} continue #{property.id}" }
      before { property.save }

      it "allows for entering data" do
        process = run_interactive(cmd)
        expect(process.output).to include("Phone: ")
      end
    end
  end

end
