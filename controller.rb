get '/' do
	# flash[:info] = 'This is a flash message'
	erb :index
end

get '/signup' do
	images = Image.all
	@images = images.sample(10)
	erb :signup
end

post '/user/create' do
	@user = User.create(username: params['username'], auth_image_ids: params['imageIds'].join(","))
	puts @user
	status 200
end

get '/signin/username' do
	erb :signin
end

post '/signin/images' do
	@user = User.first(username: params['username'])
	selectedIds = @user.auth_image_ids.split(',')
	image = Image.all

	selectedObj = selectedIds.map do |i|
		image.find { |im| im.id.to_s == i.to_s}
	end

	filtered_img = image.reject { |i| selectedIds.include? i.id.to_s }

	@image_urls = filtered_img.sample(5).concat(selectedObj)
	@image_urls = @image_urls.shuffle

	erb :authImage
end

post '/image_check' do
	@user = User.first(id: params['userId'])
	if @user.auth_image_ids == params['authSelections'].join(',')
		redirect to('/success'), 303
	else
		status 404
	end
end

get '/success' do
	erb :success
end
