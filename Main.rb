require 'nokogiri'
require 'open-uri'
require 'csv'
require 'prawn'
require_relative 'Car'
require_relative 'Noko'
require_relative 'Pdf'
include Noko
include Pdf

Num_of_items = 5

doc = Nokogiri::HTML(URI.open("https://www.otomoto.pl/osobowe"))

arr = Noko::noko(Num_of_items, doc)

cars = []
arr.each { |i| cars << Car.new(i) }

File.write("plik_csv.csv", arr.map(&:to_csv).join)

Pdf::prawn(arr, Num_of_items, doc)
