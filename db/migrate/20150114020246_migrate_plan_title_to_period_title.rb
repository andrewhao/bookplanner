class MigratePlanTitleToPeriodTitle < ActiveRecord::Migration
  def up
    Plan.find_each do |p|
      period = p.period
      period.update_attributes(name: p.name)
    end
  end

  def down
    Period.update_all(name: nil)
  end
end
