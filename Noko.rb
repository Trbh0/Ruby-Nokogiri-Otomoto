module Noko
  def noko(num_of_items, doc)
    name_arr = doc.xpath('//div/article/section/div/h1/a').map(&:text).first(num_of_items)

    price_arr = doc.xpath('//div/article/section/div[4]/div/div/h3').map(&:text).first(num_of_items)
    currency_arr = doc.search('//div/article/section/div[4]/div/div/p').map(&:text).first(num_of_items)
    price_arr.each_with_index { |e, i| price_arr[i] = e << " " << currency_arr[i] }

    arr = []
    arr2 = []
    name_ind = -1
    doc.search('//div/article/section/div/dl[1]/dd').each_with_index do |e, i|
      e = e.text.strip
      if i%4 == 0
        arr2.unshift name_arr[name_ind]
        arr2 << price_arr[name_ind]
        name_ind += 1
        arr << arr2
        arr2 = []
      end
      arr2 << e
    break if i == 4*num_of_items
    end
    arr.shift
    arr
  end
end
