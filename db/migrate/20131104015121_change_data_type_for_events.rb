class ChangeDataTypeForEvents < ActiveRecord::Migration
	def self.up
		change_table :events do |t|
			t.change :attending, :integer
		end
	end
	 
	def self.down
		change_table :events do |t|
			t.change :attending, :float
		end
	end
end
