get '/' do
	# flash[:info] = 'This is a flash message'
	erb :index
end

get '/auth/init' do
	erb :username
end

post '/auth/images' do
	# @user = User.findById(params['username'])
	# @image_url = Picture.generateLoginPictures(@user.auth_image_ids);
	@user =  123
	@image_url = []

	9.times do |i|
		@image_url.push('/cube.png')
	end

	erb :authImage
end

post '/image_check' do
	# @user = User.findById(params['userId'])
	# if @user.auth_image_ids == params['authSelections']
	if true
		status 200
	else
		flash[:info] = 'This was the wrong combo of images'
		status 404
	end
end

get '/success' do
	erb :success
end
