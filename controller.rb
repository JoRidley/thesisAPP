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
	filtered_img = Image.all.reject { |i| params['imageIds'].include? i.id.to_s }
	alt = filtered_img.sample(5)
	altIds = alt.map { |e| e.id }.join(',')
	@user = User.create(username: params['username'], auth_image_ids: params['imageIds'].join(","), alt_image_ids: altIds)
	status 200
end

get '/signin/username' do
	erb :signin
end

post '/signin/images' do
	@user = User.first(username: params['username'])
	selectedIds = @user.auth_image_ids.split(',')

	altIds = @user.alt_image_ids.split(',')
	allId = selectedIds.concat(altIds)

 	@image_urls = allId.map do |i|
		Image.get(i)
	end

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
