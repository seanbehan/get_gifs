require "sinatra"
require "base64"
require "open-uri"
require "nokogiri"

get "/" do
  "
  <form action='/gifs' method='post'>
    <input type='text' name='url'>
  </form>
  "
end

post "/gifs" do
  url = Base64.encode64(params[:url])
  redirect "/gifs/#{url}"
end

get "/gifs/:base64" do
  url = Base64.decode64(params[:base64])
  txt = open(url).read
  doc = Nokogiri::HTML(txt)
  @gifs = doc.xpath('//img/@src').select { |src| src =~ /\.gif/i }

  erb :gifs
end
