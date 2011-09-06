require 'bundler/setup'

Bundler.require

def snapshot(tables, output_dir)
  Dir.mkdir(output_dir)
  tables.each do |table|
    File.open("#{output_dir}/#{table.to_s}.txt", 'w') do |file|
      table = DB[table].order(:id).each do |record|
        file.puts record
      end
    end
  end
end

DB = Sequel.connect(:adapter=>'postgres', :host=>'localhost', :database=>'db_name', :user=>'db_user', :password=>'db_pass')

tables = DB.tables - [:schema_migrations]

if Dir.exist?("after")
  FileUtils.rm_r("before")
  FileUtils.rm_r("after")
end

snapshot(tables, "after")  if     Dir.exist?("before")
snapshot(tables, "before") unless Dir.exist?("before")
