require 'data_mapper'
require 'dm-migrations'
require 'dm-sqlite-adapter'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.sqlite3")

class User
	include DataMapper::Resource

	property :id, Serial
	property :username, String
	property :auth_image_ids, String
	property :alt_image_ids, String
	property :created_at, DateTime
	property :updated_at, DateTime

end

class Image
	include DataMapper::Resource

	property :id, Serial
	property :url, String

end

class Track
	include DataMapper::Resource

	property :id, Serial
	property :user_id, String
	property :user_attempt, String
	property :correct_login, String
	property :successful_login, String

end

DataMapper.finalize.auto_upgrade!

# User.create(username: 'jmiramant')
# User.create(username: 'jriz')
#
# ['8031659.thl.jpg','8048786.thl.jpg','8052266.thl.jpg','8054039.thl.jpg','8055181.thl.jpg','8055554.thl.jpg','8056402.thl.jpg','8057434.thl.jpg','8058011.thl.jpg','8059226.thl.jpg','8060342.thl.jpg','8061236.thl.jpg','8063317.thl.jpg','8065674.thl.jpg','8068401.thl.jpg','8074514.thl.jpg','8076304.thl.jpg','8077486.thl.jpg','8078142.thl.jpg','8079080.thl.jpg'].each do |url|
# 	Image.create(url: url);
# end
