require 'active_record'

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :dbfile  => ":memory:",
  :database => "wimdu"
)

ActiveRecord::Schema.define do
  create_table :properties do |table|
    table.column :title, :string
    table.column :property_type, :string
    table.column :address, :string
    table.column :nightly_rate, :float
    table.column :max_guests, :integer
    table.column :email, :string
    table.column :phone, :string
    table.column :status, :string
  end unless ActiveRecord::Base.connection.table_exists?(:properties)
end 