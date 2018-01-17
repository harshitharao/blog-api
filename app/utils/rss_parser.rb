require 'rss'
require 'open-uri'

class RssParser
  def self.parse(rss_feed)
    rss_results = []
    rss = RSS::Parser.parse(open(rss_feed).read, false).items[0..1]

    rss.each do |result|
      result = {
        title: result.title,
        published_date: result.pubDate,
        link: result.link,
        description: result.description,
        content: result.content_encoded
      }
      rss_results.push(result)
    end

    rss_results
  end
end
