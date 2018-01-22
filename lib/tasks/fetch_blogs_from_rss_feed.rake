require 'rake'
require "#{Rails.root}/app/helpers/task_helper"
include TaskHelper

FEED_URL = 'http://omswami.com/feed'

namespace :development do
  desc "generate blogs"
  task fetch_blogs_from_rss_feed: :environment do
    rss_feeds = RssParser.parse(FEED_URL)
    latest_10_feeds = Common.sort_by_date(rss_feeds, :published_date)[0..9]
    TaskHelper.create_new_blogs_from_feed(latest_10_feeds)
  end
end
