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
  end
end
