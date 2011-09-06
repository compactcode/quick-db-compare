require 'bundler/setup'

Bundler.require

DB = Sequel.connect(:adapter=>'postgres', :host=>'localhost', :database=>'db_name', :user=>'db_user', :password=>'db_pw')

tables = DB.tables

def snapshot(output_dir)
  tables.each do |table|
    File.open("#{output_dir}/#{table.to_s}.txt", 'w') do |file|
      table = DB[table].order(:id).each do |record|
        file.puts record
      end
    end
  end
end

snapshot("before")

