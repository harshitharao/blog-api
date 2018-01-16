class Common
  def self.sort_by_date(data, date_key)
    sorted = data.sort_by{|entry| entry[date_key].to_datetime}
    sorted.reverse
  end
end
