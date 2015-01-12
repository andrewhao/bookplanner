class ChangeBookBagsGlobalIdToIntegerType < ActiveRecord::Migration
  def up
    puts "#{BookBag.all.map(&:global_id).inspect}"
    query = <<-SQL
    ALTER TABLE book_bags alter column global_id type integer using global_id::integer
    SQL

    BookBag.connection.execute query
    puts "#{BookBag.all.map(&:global_id).inspect}"
  end

  def down
    puts "#{BookBag.all.map(&:global_id).inspect}"
    query = <<-SQL
    ALTER TABLE book_bags alter column global_id type varchar(255) using global_id::varchar(255)
    SQL

    BookBag.connection.execute query
    puts "#{BookBag.all.map(&:global_id).inspect}"
  end
end
