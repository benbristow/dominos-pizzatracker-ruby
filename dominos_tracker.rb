require 'open-uri'
require 'json'

class DominosPizza
  def initialize(id)
    @id = id
    refresh_info
  end

  def refresh_info
    begin
      @info = JSON.parse(open("https://www.dominos.co.uk/pizzaTracker/getOrderDetails?id=#{@id}").read)
    rescue
      @info = {"statusId" => -1}
    end
  end

  def get_customer_name
    @info["customerName"] || "Unknown"
  end

  def get_store_name
    @info["storeName"] || "Unknown"
  end

  def get_store_manager_name
    @info["storeManagerName"] || "Unknown"
  end

  def get_delivery_driver_name
    @info["driverName"] || "Unknown"
  end

  def get_pizza_status
    refresh_info
    case @info["statusId"]
      when -1
        "is having connection problems or is invalid :("
      when 1
        "has been cancelled"
      when 2
        "has been collected"
      when 3
        "has been delivered by #{get_delivery_driver_name}"
      when 4
        "cannot be found"
      when 5
        "is in the oven"
      when 6
        "is due order processing"
      when 7
        "is being prepared"
      when 8
        "is being checked for quality"
      when 9
        "is out for delivery and is being delivered by #{get_delivery_driver_name}"
      when 10
        "is ready for collection"
      else
        "has been lost somewhere"
    end
  end

end


pizza = DominosPizza.new(ARGV[0])
last_status = ""
puts "===================================================================================="
puts "Pizza ID: #{ARGV[0]}"
puts "Customer Name: #{pizza.get_customer_name}"
puts "Store: #{pizza.get_store_name}"
puts "Manager: #{pizza.get_store_manager_name}"
puts "===================================================================================="

while true
  status = pizza.get_pizza_status
  if (status != last_status)
    puts "Your pizza #{status}."
    last_status = status
  end
  sleep 30
end
