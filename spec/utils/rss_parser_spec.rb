require 'rails_helper'
require 'pathname';

RSpec.describe RssParser do
  describe ".parse" do
    it "returns rss feed data as array of hashes" do
      rss_results = RssParser.parse('http://www.feedforall.com/sample.xml')
      first_feed = rss_results[0]
      expect(first_feed[:title]).to eq('RSS Solutions for Restaurants')
      expect(first_feed).to include(:link, :description, :content, :published_date)
    end
  end
end
