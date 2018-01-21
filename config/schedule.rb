ENV['RAILS_ENV'] = "#{@pre_set_variables[:environment]}"

env :PATH, ENV['PATH']
require File.expand_path(File.dirname(__FILE__) + "/environment")

set :output, "log/cron_log_#{ENV['RAILS_ENV']}.log"

every 1.day, at: '12am' do
   rake "#{ENV['RAILS_ENV']}:fetch_blogs_from_rss_feed"
end
