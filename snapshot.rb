require 'bundler/setup'

Bundler.require

def snapshot(database, tables, output_dir)
  Dir.mkdir(output_dir)
  tables.each do |table|
    File.open("#{output_dir}/#{table.to_s}.txt", 'w') do |file|
      table = database[table].order(:id).each do |record|
        file.puts record
      end
    end
  end
end

if Dir.exist?("after")
  FileUtils.rm_r("before")
  FileUtils.rm_r("after")
end

database = Sequel.connect(:adapter=>'postgres', :host=>'localhost', :database=>'db_name', :user=>'db_user', :password=>'db_pass')
tables = database.tables - [:schema_migrations]

snapshot(database, tables, "after")  if     Dir.exist?("before")
snapshot(database, tables, "before") unless Dir.exist?("before")

