require 'rails_helper'

RSpec.describe Common do
  describe ".sort_by_date" do
    it "returns data sorted by date" do
      data = [
        { title: 'blog1', date: 'Tue, 18 Oct 2004 11:09:03 -0400' },
        { title: 'blog2', date: 'Tue, 19 Oct 2004 11:09:03 -0400' },
        { title: 'blog3', date: 'Tue, 18 Oct 2004 12:09:03 -0400' },
        { title: 'blog4', date: 'Tue, 18 Oct 2004 12:09:02 -0400' },
      ]
      expected_data = [
        { title: 'blog2', date: 'Tue, 19 Oct 2004 11:09:03 -0400' },
        { title: 'blog3', date: 'Tue, 18 Oct 2004 12:09:03 -0400' },
        { title: 'blog4', date: 'Tue, 18 Oct 2004 12:09:02 -0400' },
        { title: 'blog1', date: 'Tue, 18 Oct 2004 11:09:03 -0400' },
      ]
      expect(Common.sort_by_date(data)).to eq(expected_data)
    end
  end
end
