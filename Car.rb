class Car
  attr_accessor :name, :mileage, :fuel_type, :gearbox, :year, :price

  def initialize(args)
    @name, @mileage, @fuel_type, @gearbox, @year, @price = args
   end

  def to_s
    "#{@name}, #{@mileage}, #{@fuel_type}, #{@gearbox}, #{@year}, #{@price}"
  end
end
