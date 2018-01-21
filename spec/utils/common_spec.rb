require 'rails_helper'

RSpec.describe Common do
  describe ".sort_by_date" do
    it "returns data sorted by date" do
      blog1 = Blog.create!(title: 'blog1', published_date: 'Tue, 18 Oct 2004 11:09:03 -0400')
      blog2 = Blog.create!(title: 'blog2', published_date: 'Tue, 19 Oct 2004 11:09:03 -0400')
      blog3 = Blog.create!(title: 'blog3', published_date: 'Tue, 18 Oct 2004 12:09:03 -0400')
      blog4 = Blog.create!(title: 'blog4', published_date: 'Tue, 18 Oct 2004 12:09:02 -0400')
      data = [blog1, blog2, blog3, blog4]
      expected_data = [blog2, blog3, blog4, blog1]
      expect(Common.sort_by_date(data, :published_date)).to eq(expected_data)
    end
  end
end
