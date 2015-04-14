require "spec_helper"
load 'config/active_record_config.rb'
load 'lib/model/property.rb'

describe "Property" do
  describe "full_print" do

    let(:property) { Property.new(title: "title", property_type: "apartment", address: "address", nightly_rate: 12.3, 
      max_guests: 12, email: "test@mail.com", phone: "+99 999 9999") }

    it "prints full data" do
      expect { property.full_print }.to output("Title: title\nType: apartment\nAddress: address\nNightly rate (EUR): 12.3\nMax Guests allowed: 12\nEmail: test@mail.com\nPhone: +99 999 9999\n").to_stdout
    end
  end

  describe "one_line_print" do
    let(:property) { Property.create }

    it "prints without title if not filled" do
      expect { property.one_line_print }.to output("#{property.id} - \n").to_stdout
    end

    it "prints with title if filled" do
      property.title = "I am a test title"
      expect { property.one_line_print }.to output("#{property.id} - I am a test title\n").to_stdout
    end
  end
end
