class Assignment < ActiveRecord::Base
  has_and_belongs_to_many :inventory_states
  belongs_to :inventory_state
end

class PopulateInventoryStateIdOnAssignments < ActiveRecord::Migration
  def up
    Assignment.find_each do |assn|
      iss = assn.inventory_states
      if iss.empty?
        puts "no inventory state here"
      elsif iss.length > 1
        raise "uh oh.. bad data here. multiple inventory states"
      else
        assn.inventory_state = iss.first
        assn.save
        puts "Assn #{assn.id} saved with is #{iss.first.id}"
      end
    end
  end

  def down
    Assignment.update_all(inventory_state_id: nil)
  end
end
