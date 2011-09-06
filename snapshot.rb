require 'bundler/setup'

Bundler.require

require 'yaml'

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

config = YAML.load_file("database.yml")

database = Sequel.connect(
  :adapter  => 'postgres',
  :host     => config['db_host'],
  :database => config['db_name'],
  :user     => config['db_user'],
  :password => config['db_pass']
)

tables = database.tables - [:schema_migrations]

snapshot(database, tables, "after")  if     Dir.exist?("before")
snapshot(database, tables, "before") unless Dir.exist?("before")

