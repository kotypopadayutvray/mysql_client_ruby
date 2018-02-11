# encoding: utf-8

require 'mysql2'

# This is MySQL client
class MysqlClient
  def initialize(options)
    @host = options[:host].to_s
    @username = options[:username].to_s
    @password = options[:password].to_s
    @database = options[:database].to_s
    @connection = Mysql2::Client.new(
      host: @host,
      username: @username,
      password: @password,
      database: @database
    )
  end

  # Use this method for SQL SELECT statement
  def select_query(options = {})
    query = "SELECT #{options[:columns]} FROM #{options[:table]}"
    query += " WHERE #{options[:conditions]}" if options[:conditions]
    query += " GROUP BY #{options[:grouping]}" if options[:grouping]
    @connection.query(query)
  end

  # Use this method for SQL UPDATE statement
  def update_query(options)
    query = "UPDATE #{options[:table]} SET #{options[:values]}"
    query += " WHERE #{options[:conditions]}" if options[:conditions]
    @connection.query(query)
  end

  # Use this method for SQL INSERT statement
  def insert_query(options)
    query = "INSERT INTO #{options[:table]} (#{options[:columns]}) VALUES (#{options[:values]})"
    @connection.query(query)
  end

  def close
    @connection.close
  end
end
