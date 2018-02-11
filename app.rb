# encoding: utf-8

require './lib/mysql_client.rb'
require 'yaml'

def main(mysql_connection)
  loop do
    show_menu
    return unless process_answer(mysql_connection).nil?
  end
end

def show_menu
  puts 'You can use the following comands:'
  puts "\t1 - do the select query;"
  puts "\t2 - do the update query;"
  puts "\t3 - do the insert query;"
  puts "\t0 - exit from the program;"
  print "\nYour answer is: "
end

def process_answer(mysql_connection)
  asnwer = $stdin.readline.chomp.to_i
  case asnwer
  when 1
    select_query(mysql_connection)
  when 2
    update_query(mysql_connection)
  when 3
    insert_query(mysql_connection)
  when 0
    return false
  end
end

def select_query(mysql_connection)
  options = {}
  print 'Enter columns: '
  options[:columns] = $stdin.readline.chomp
  print 'Enter table: '
  options[:table] = $stdin.readline.chomp
  print 'Enter conditions: '
  options[:conditions] = $stdin.readline.chomp
  options[:conditions] = nil if options[:conditions].empty?
  print 'Enter grouping columns: '
  options[:grouping] = $stdin.readline.chomp
  options[:grouping] = nil if options[:grouping].empty?
  begin
    result = mysql_connection.select_query(options)

    result.each_with_index do |row, index|
      print "Row ##{index + 1}: "
      row.each do |key, value|
        print "#{key} = #{value}; "
      end
      puts ''
    end
    puts ''
  rescue Mysql2::Error => error
    puts error.errno
    puts error.error
  end
end

def update_query(mysql_connection)
  options = {}
  print 'Enter table: '
  options[:table] = $stdin.readline.chomp
  print 'Enter values: '
  options[:values] = $stdin.readline.chomp
  print 'Enter conditions: '
  options[:conditions] = $stdin.readline.chomp
  options[:conditions] = nil if options[:conditions].empty?
  begin
    result = mysql_connection.update_query(options)
    puts 'Record(s) was successfully updated!' if result.nil?
  rescue Mysql2::Error => error
    puts error.errno
    puts error.error
  end
end

def insert_query(mysql_connection)
  options = {}
  print 'Enter table: '
  options[:table] = $stdin.readline.chomp
  print 'Enter columns: '
  options[:columns] = $stdin.readline.chomp
  print 'Enter values: '
  options[:values] = $stdin.readline.chomp
  begin
    result = mysql_connection.insert_query(options)
    puts 'Record was successfully added!' if result.nil?
  rescue Mysql2::Error => error
    puts error.errno
    puts error.error
  end
end

puts 'No arguments! The first and only argument myst be is path to config file.' if ARGV.empty?

# Load config file
config = YAML.load_file(ARGV[0])
# Convert hash key from string to symbols
config = Hash[config.map { |k, v| [k.to_sym, v] }]
# Create a MySQL connection
mysql_connection = MysqlClient.new(config)
# Start main loop of program with user interaction
main mysql_connection
# Don't forget to close connection
mysql_connection.close
