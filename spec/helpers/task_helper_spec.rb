require 'rails_helper'

RSpec.describe TaskHelper do
  describe "create_new_blogs_from_feed" do
    it "returns new blogs if it is newly present in rss feed" do
      rss_feed = [
        {
          title: 'blog 1',
          link: 'http://blog1.html',
          published_date: 'Tue, 19 Oct 2004 11:09:03 -0400'
        },
        {
          title: 'blog 2',
          link: 'http://blog2.html',
          published_date: 'Tue, 18 Oct 2004 11:09:03 -0400'
        }
      ]
      blog = Blog.create!(title: 'blog 2', link: 'http://blog2.html', published_date: 'Tue, 18 Oct 2004 11:09:03 -0400')
      expect(Blog.count).to eq(1)
      expect(Blog.all.map(&:title)).to eq(['blog 2'])
      TaskHelper.create_new_blogs_from_feed(rss_feed)
      expect(Blog.count).to eq(2)
      expect(Blog.all.map(&:title)).to eq(['blog 2', 'blog 1'])
    end

    it "returns all new blogs after the last blogs published date of the db" do
      rss_feeds = [
        {
          title: 'blog 1',
          link: 'http://blog1.html',
          published_date: 'Tue, 19 Oct 2004 11:09:03 -0400'
        },
        {
          title: 'blog 2',
          link: 'http://blog2.html',
          published_date: 'Tue, 18 Oct 2004 11:09:03 -0400'
        },
        {
          title: 'blog 3',
          link: 'http://blog3.html',
          published_date: 'Tue, 17 Oct 2004 11:09:03 -0400'
        }
      ]
      blog = Blog.create!(title: 'blog 3', link: 'http://blog3.html', published_date: 'Tue, 17 Oct 2004 11:09:03 -0400')
      expect(Blog.count).to eq(1)
      expect(Blog.all.map(&:title)).to eq(['blog 3'])
      TaskHelper.create_new_blogs_from_feed(rss_feeds)
      expect(Blog.count).to eq(3)
      expect(Blog.all.map(&:title)).to eq(['blog 3', 'blog 1', 'blog 2'])
    end

    it "doesnt create new blogs if there are no new feeds" do
      rss_feeds = [
        {
          title: 'blog 3',
          link: 'http://blog3.html',
          published_date: 'Tue, 17 Oct 2004 11:09:03 -0400'
        }
      ]
      blog = Blog.create!(title: 'blog 3', link: 'http://blog3.html', published_date: 'Tue, 17 Oct 2004 11:09:03 -0400')
      expect(Blog.count).to eq(1)
      expect(Blog.all.map(&:title)).to eq(['blog 3'])
      TaskHelper.create_new_blogs_from_feed(rss_feeds)
      expect(Blog.count).to eq(1)
      expect(Blog.all.map(&:title)).to eq(['blog 3'])
    end

    it "creates all blogs from feed when blog is empty" do
      rss_feeds = [
        {
          title: 'blog 3',
          link: 'http://blog3.html',
          published_date: 'Tue, 17 Oct 2004 11:09:03 -0400'
        }
      ]
      expect(Blog.count).to eq(0)
      TaskHelper.create_new_blogs_from_feed(rss_feeds)
      expect(Blog.count).to eq(1)
      expect(Blog.all.map(&:title)).to eq(['blog 3'])
    end

    it "doesnt create any blog if the feed is empty" do
      rss_feeds = []
      blog = Blog.create!(title: 'blog 3', link: 'http://blog3.html', published_date: 'Tue, 17 Oct 2004 11:09:03 -0400')
      expect(Blog.count).to eq(1)
      expect(Blog.all.map(&:title)).to eq(['blog 3'])
      TaskHelper.create_new_blogs_from_feed(rss_feeds)
      expect(Blog.count).to eq(1)
      expect(Blog.all.map(&:title)).to eq(['blog 3'])
    end

    it "doesnt create any blog if the feed is invalid" do
      rss_feeds = [
        {
          link: 'http://blog3.html',
          published_date: 'Tue, 17 Oct 2004 11:09:03 -0400'
        }
      ]
      expect(Blog.count).to eq(0)
      TaskHelper.create_new_blogs_from_feed(rss_feeds)
      expect(Blog.count).to eq(0)
    end

    it "returns new blogs based on latest blog published date" do
      rss_feed = [
        {
          title: 'blog 1',
          link: 'http://blog1.html',
          published_date: 'Tue, 19 Oct 2004 11:09:03 -0400'
        },
        {
          title: 'blog 4',
          link: 'http://blog4.html',
          published_date: 'Tue, 19 Oct 2004 11:09:03 -0400'
        },
        {
          title: 'blog 2',
          link: 'http://blog2.html',
          published_date: 'Tue, 18 Oct 2004 12:09:03 -0400'
        },
        {
          title: 'blog 3',
          link: 'http://blog3.html',
          published_date: 'Tue, 18 Oct 2004 11:09:03 -0400'
        }
      ]
      blog = Blog.create!(title: 'blog 2', link: 'http://blog2.html', published_date: 'Tue, 18 Oct 2004 12:09:03 -0400')
      blog = Blog.create!(title: 'blog 3', link: 'http://blog3.html', published_date: 'Tue, 18 Oct 2004 11:09:03 -0400')
      expect(Blog.count).to eq(2)
      expect(Blog.all.map(&:title)).to eq(['blog 2', 'blog 3'])
      TaskHelper.create_new_blogs_from_feed(rss_feed)
      expect(Blog.count).to eq(4)
      expect(Blog.all.map(&:title)).to eq(['blog 2', 'blog 3', 'blog 1', 'blog 4'])
    end
  end
end
