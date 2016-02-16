class CreatePeriods < ActiveRecord::Migration
  def change
    create_table :periods, &:timestamps
  end
end
