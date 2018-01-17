module TaskHelper
  def self.create_new_blogs_from_feed(rss_feeds)
    last_blog = Blog.last
    last_blog_published_date = last_blog && last_blog.published_date
    feeds_with_new_dates = last_blog_published_date ?
      rss_feeds.select{|feed| feed[:published_date] > last_blog_published_date} :
      rss_feeds
    Blog.create(feeds_with_new_dates)
  end
end
