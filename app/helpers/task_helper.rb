module TaskHelper
  def self.create_new_blogs_from_feed(rss_feeds)
    blog_dates = Blog.all.map(&:published_date)
    feeds_with_new_dates = rss_feeds.select{|feed| !blog_dates.include?(feed[:published_date])}
    Blog.create(feeds_with_new_dates)
  end
end
