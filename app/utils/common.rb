class Common
  def self.sort_by_date(data)
    sorted = data.sort_by{|entry| entry[:date].to_datetime}
    sorted.reverse
  end
end
