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
	altIdsArray = alt.map { |e| e.id }
	altIds = altIdsArray.join(',')
	alt2 = filtered_img.reject { |i| altIdsArray.include? i.id.to_s }.sample(5)
	altIdsArray2 = alt2.map { |e| e.id }
	altIds2 = altIdsArray2.join(',')

	@user = User.create(
		username: params['username'],
		auth_image_ids: params['imageIds'].join(","),
		filler_image_ids: altIds,
		filler_image_ids_2: altIds2
	)

	status 200
end

get '/signin/username' do
	erb :signin
end

post '/signin/images' do
	@user = User.first(username: params['username'])
	selectedIds = @user.auth_image_ids.split(',')

	altIds = @user.filler_image_ids.split(',')
	if rand(2) == 1
		altIds = @user.filler_image_ids_2.split(',')
	end

	@version = 1
	allId = selectedIds.concat(altIds)
 	@image_urls = allId.map do |i|
		@version = 2
		Image.get(i)
	end

	@image_urls = @image_urls.shuffle

	erb :authImage
end

post '/image_check' do
	@user = User.first(id: params['userId'])

	Track.create(
		user_id: @user.id,
		user_attempt: params['authSelections'],
		correct_login: @user.auth_image_ids.split(','),
		successful_login: @user.auth_image_ids == params['authSelections'].join(','),
		version: params['version'].to_i,
	)

	if @user.auth_image_ids == params['authSelections'].join(',')
		redirect to('/success'), 303
	else
		status 404
	end

end

get '/success' do
	erb :success
end
