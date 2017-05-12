require 'data_mapper'
require 'dm-migrations'
require 'dm-sqlite-adapter'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.sqlite3")

class User
	include DataMapper::Resource

	property :id, Serial
	property :type, String
	property :username, String
	property :auth_image_ids, String
	property :filler_image_ids, String
	property :filler_image_ids_2, String
	property :created_at, DateTime
	property :updated_at, DateTime

end

class Image
	include DataMapper::Resource

	property :id, Serial
	property :url, String

end

class NumberImage
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
	property :version, Integer
	property :num_attempts, Integer

end

DataMapper.finalize.auto_upgrade!

i = Image.all()
i.destroy
# Telling the application which object to put within a dataset 
['8021410.thl.jpg','8026084.thl.jpg','8081398.thl.jpg','8253370.thl.jpg','10049507.thl.jpg',
'8031659.thl.jpg','8048786.thl.jpg','8052266.thl.jpg','8054039.thl.jpg','8055181.thl.jpg','8055554.thl.jpg','8056402.thl.jpg','8057434.thl.jpg','8058011.thl.jpg','8059226.thl.jpg','8060342.thl.jpg','8061236.thl.jpg','8063317.thl.jpg','8065674.thl.jpg','8068401.thl.jpg','8074514.thl.jpg','8076304.thl.jpg','8077486.thl.jpg','8078142.thl.jpg','8079080.thl.jpg'].each do |url|
	Image.create(url: url);
end

# Telling the application which number to put within a dataset 

ni = NumberImage.all()
ni.destroy
['numbers/10.jpg','numbers/13.jpg','numbers/17.jpg','numbers/21.jpg','numbers/24.jpg','numbers/27.jpg','numbers/32.jpg','numbers/36.jpg','numbers/39.jpg','numbers/43.jpg','numbers/44.jpg','numbers/47.jpg','numbers/53.jpg','numbers/56.jpg','numbers/58.jpg','numbers/61.jpg','numbers/64.jpg','numbers/69.jpg','numbers/70.jpg','numbers/72.jpg','numbers/76.jpg','numbers/84.jpg','numbers/87.jpg','numbers/93.jpg','numbers/99.jpg'].each do |url|
	NumberImage.create(url: url);
end
