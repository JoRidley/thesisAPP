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
	@user = User.findById(params['user'])
	if @user.auth_image_ids == params['authSelections']
		# redirect to auth
		status 200
	else
		# redirect to back to images with notice no auth
		status 200
	end
end
