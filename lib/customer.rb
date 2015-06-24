require './lib/send-sms'

class Customer

  attr_accessor :order, :total_quantity
  attr_reader :summary

  def initialize # consider passing in the menu to Customer, then you wouldn't have to pass it into every method that needs it
    # @menu = menu
    @order = {}
    @total_quantity = 0
    # @summary = [["Item","Quantity","Price"]]
  end

  def check_menu(menu)
    menu.view_menu
  end

  def add_to_order(menu,food,quantity)
    self.order.has_key?(food.to_sym) ? self.order[food.to_sym][0] += quantity : order[food.to_sym] = [quantity, menu.items[food.to_sym]] # consider refactoring out to another method that describes whats going on here
    self.calculate_total_quantity
  end

  def total_price # in this situation we prefer a functional solution to the problem of knowing the total price. Ask Spike why!
    total_price = 0 # try using inject to shorten this method
    order.each {|k,v| total_price += v[0]*v[1] }
    total_price
  end

  def calculate_total_quantity
    self.total_quantity = 0 # same as above.
    order.each {|k,v| self.total_quantity += v[0] }
  end

  def view_order
    puts "Item".ljust(20) + "Quantity".center(20) + "Price".rjust(20) # Don't use puts. Puts couples your program to STDOUT.
    order.each do |k,v|
      puts "#{k}".ljust(20) + "#{v[0]}".center(20) + "#{v[0]*v[1]}GBP".rjust(20)
    end
    puts "Total".ljust(20) + "#{total_quantity}".center(20) + "#{total_price}GBP".rjust(20)
  end

  def place_order(text_sender)
    fail "Total price miscalculation" unless total_price == order.values.inject(0) {|result,element| result + (element[0] * element[1])}
    text_sender.send_message
  end

end

# There are 3 methods ending 'order', as well as an instance variable. Often this means we can break these methods out into another Class. In this case, 'Order'

