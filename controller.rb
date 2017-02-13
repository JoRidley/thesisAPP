get '/' do
	# flash[:info] = 'This is a flash message'
	erb :index
end

get '/hello' do

	@image_url = []

	9.times do |i|
		@image_url.push('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcShOG9aVYjWRfmHFhuckZa1uZgWYNBQw2lQSCqLlssvbUiocbHFIzv9qMgQ')
	end

	erb :hello
end

post '/accept' do
	@params['authSelections']
	status 200
  body ''
end
