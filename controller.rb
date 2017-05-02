get '/' do
	# flash[:info] = 'This is a flash message'
	erb :index
end

get '/consent' do
	erb :consent
end

get '/expinfo' do
	erb :expinfo
end

get '/survey' do
	erb :survey
end


get '/signup' do
	@type = ['img_seen', 'img_unseen', 'num_seen', 'num_unseen'][rand(0..3)]
	if (@type == 'img_seen') || (@type == 'img_unseen')
		images = Image.all
	else
		images = NumberImage.all
	end
	@images = images.sample(16)
	@imageIds = @images.map { |i| i.id }

	erb :signup
end

post '/user/create' do
	type = params['type']
	if type == 'img_seen' || type == 'num_seen'
		filtered_img = params['allIds'].reject { |i| params['imageIds'].include? i.id.to_s }
	elsif type == 'img_unseen'
		filtered_img = Image.all.reject { |i| params['imageIds'].include? i.id.to_s }
	else
		filtered_img = NumberImage.all.reject { |i| params['imageIds'].include? i.id.to_s }
	end
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
		filler_image_ids_2: altIds2,
		type: type
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
	if @user.type == 'img_seen' || @user.type == 'img_unseen'
	 	@image_urls = allId.map do |i|
			@version = 2
			Image.get(i)
		end
	else
	 	@image_urls = allId.map do |i|
			@version = 2
			NumberImage.get(i)
		end
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
