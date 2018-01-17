require 'rake'
require "#{Rails.root}/app/helpers/task_helper"
include TaskHelper

namespace :development do
  desc "generate blogs"
  task fetch_blogs_from_rss_feed: :environment do
    rss_feeds = RssParser.parse('http://omswami.com/feed')
    TaskHelper.create_new_blogs_from_feed(rss_feeds)
  end
end
