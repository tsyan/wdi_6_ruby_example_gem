require 'spec_helper'

describe GaExampleGem::Client do
	before do
    @client = GaExampleGem::Client.new
    @client.configure do |config|
      config.api_key = "its a secret to everybody"
    end
  end

  describe '#get_xkcd' do
  	before do
      # Intercept an HTTP request that looks like this,
      # and return a specific JSON file instead for the body
      stub_request(:get, 'http://xkcd-unofficial-api.herokuapp.com/xkcd?num=1').
        to_return(body: fixture('single_xkcd.json'))
    end

    it "fetches a single xkcd webcomic" do
      # Make the request
      comic = @client.get_xkcd(1)

      # Expect that you made a request
      expect(a_request(:get, 'http://xkcd-unofficial-api.herokuapp.com/xkcd?num=1')).to have_been_made

      # Check the results of the JSON file/body of HTTP request that we intercepted
      expect(comic.first["title"]).to eq "Barrel - Part 1"
    end
  end

  describe '#get_xkcd_from_year' do
    before do
      stub_request(:get, 'http://xkcd-unofficial-api.herokuapp.com/xkcd?year=2008').to_return(body:fixture('xkcds_from_year.json'))
    end

    it 'fetches multiple xkcd webcomics' do
      comics = @client.get_xkcd_from_year(2008)

      expect(a_request(:get,'http://xkcd-unofficial-api.herokuapp.com/xkcd?year=2008').to have_been_made

      expect(comics.first["title"]).to eq "The Sea"
    end


  end

end
