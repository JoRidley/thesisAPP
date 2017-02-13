require 'data_mapper'
require 'dm-migrations'
require 'dm-sqlite-adapter'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.sqlite3")

class User
	include DataMapper::Resource

	property :id, Serial
	property :first_name, String
	property :last_name, String
	property :email, String
	property :auth_image_ids, String

end

DataMapper.finalize.auto_upgrade!
