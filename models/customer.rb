require_relative  '../db/SqlRunner'

class Customer

  attr_accessor :name, :id

  def initialize(options)
    @id = options['id'].to_i() if options['id']
    @name = options['name']
  end

  def self.all()
    sql =  "SELECT * FROM customers;"
    customers = SqlRunner.run(sql)
    return customers.map { |options| Customer.new(options)}
  end


  def save()

    sql = "INSERT INTO customers (name) VALUES ('#{@name}') returning * ;"
    result = SqlRunner.run(sql)
    @id = result[0]['id'].to_i()
  end

  def self.delete_all()
    sql = "DELETE FORM customers;"
    SqlRunner.run(sql)
  end

  def orders()
    sql = "SELECT * FROM pizza_orders WHERE customer_id = #{@id}"
    result = SqlRunner.run(sql)
    orders = result.map { |order| PizzaOrder.new(order)}
    return orders
  end

  def self.find( id )
    sql = "SELECT * FROM customers WHERE id=#{id};"
    pizza = SqlRunner.run( sql )
    result = Customer.new( pizza.first )
    return result
  end

  def update(params)
    sql = "UPDATE customers SET name = '#{params[:name]}' WHERE id = #{params[:id]};"
    SqlRunner.run(sql)
  end

  def delete()
    sql = "DELETE FROM customers WHERE id = #{@id};"
    SqlRunner.run(sql)
  end
end