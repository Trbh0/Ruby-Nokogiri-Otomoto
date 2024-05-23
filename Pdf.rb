module Pdf
  def prawn(arr, num_of_items, doc)
    img_arr_pre = doc.xpath('//div/article/section/div[1]//img').map { |i| i['src'] }
    img_arr = []
    put, ind_put = 0, 0
    while put < num_of_items
      img_arr << img_arr_pre[ind_put] && put += 1 if img_arr_pre[ind_put][0..1] != "//"
      ind_put += 4 if img_arr_pre[ind_put][-7..-1] == "644x461"
      ind_put += 1
    end

    Prawn::Fonts::AFM.hide_m17n_warning = true
    pdf = Prawn::Document.new

    max_cur = pdf.cursor-10
    arr.each_with_index do |i, n|
      loc = pdf.cursor-10
      pdf.image(URI.open(img_arr[n]), height: 100, width: 150)
      i.each_with_index do |j, m|
        loc = max_cur if loc < 100
        pdf.draw_text(j, at: [170, loc])
        loc -= 17
      end
      pdf.move_down 25
    end

    pdf.render_file('plik_pdf.pdf')
  end
end
