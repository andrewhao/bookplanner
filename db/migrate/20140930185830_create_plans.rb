class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :title
      t.references :classroom, index: true

      t.timestamps
    end
  end
end
