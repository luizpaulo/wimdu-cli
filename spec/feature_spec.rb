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
end
