require 'nokogiri'
require 'open-uri'
require 'csv'
require 'prawn'

class Car
  attr_accessor :name, :mileage, :fuelType, :gearbox, :year, :price

  def initialize(args)
    @name, @mileage, @fuelType, @gearbox, @year, @price = args
   end

  def to_s
    "#{@name}, #{@mileage}, #{@fuelType}, #{@gearbox}, #{@year}, #{@price}"
  end
end

doc = Nokogiri::HTML(URI.open("https://www.otomoto.pl/osobowe"))

NumOfItems = 5
nameArr = doc.search('.e1i3khom9.ooa-1ed90th.er34gjf0').map(&:text).first(NumOfItems)

priceArr = doc.search('.e1i3khom16.ooa-1n2paoq.er34gjf0').map(&:text).first(NumOfItems)
currencyArr = doc.search('.e1i3khom17.ooa-8vn6i7.er34gjf0').map(&:text).first(NumOfItems)
priceArr.each_with_index { |e, i| priceArr[i] = e << " " << currencyArr[i] }

arr = []
arr2 = []
nameInd = -1
doc.search('.ooa-1omlbtp.e1i3khom13').each_with_index do |e, i|
  e = e.text.strip
  if i%4 == 0
    arr2.unshift nameArr[nameInd]
    arr2 << priceArr[nameInd]
    nameInd += 1
    arr << arr2
    arr2 = []
  end
  arr2 << e
  break if i == 4*NumOfItems
end
arr.shift

cars = []
arr.each { |i| cars << Car.new(i) }

File.write("plik_csv.csv", arr.map(&:to_csv).join)

imgArrPre = doc.search('.e17vhtca4.ooa-2zzg2s').map { |i| i['src'] }
imgArr = []
put, indPut = 0, 0
while put < NumOfItems
  imgArr << imgArrPre[indPut] && put += 1 if imgArrPre[indPut][0..1] != "//"
  indPut += 4 if imgArrPre[indPut][-7..-1] == "644x461"
  indPut += 1
end

Prawn::Fonts::AFM.hide_m17n_warning = true
pdf = Prawn::Document.new

maxCur = pdf.cursor-10
arr.each_with_index do |i, n|
  loc = pdf.cursor-10
  pdf.image(URI.open(imgArr[n]), height: 100, width: 150)
  i.each_with_index do |j, m|
    loc = maxCur if loc < 100
    pdf.draw_text(j, at: [170, loc])
    loc -= 17
  end
  pdf.move_down 25
end

pdf.render_file('plik_pdf.pdf')
