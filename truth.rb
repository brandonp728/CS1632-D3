require 'sinatra'
require 'sinatra/reloader'

get '/' do
  erb :index
end

get '/table' do
  true_symbol = params[:true_val]
  false_symbol = params[:false_val]
  table_size_str = params[:size]
  true_symbol = 'T' if true_symbol.empty?
  false_symbol = 'F' if false_symbol.empty?
  table_size_str = '3' if table_size_str.empty?
  table_size = table_size_str.to_i
  num_rows = 2**table_size
  num_cols = table_size + 3
  error = false
  error_msg = ''

  # Error Messages if:
  # => the true or false symbol are more than a symbol
  # => true == false
  # => table_size is < 2
  error = table_size_less_than_two? table_size
  error ||= true_eq_false? true_symbol, false_symbol
  error ||= true_or_false_gt_one? true_symbol, false_symbol
  error_msg = 'Invalid parameters' if error

  table = create_table num_rows, num_cols, true_symbol, false_symbol, table_size unless error
  table = nil if error

  erb :table, locals: {
    table: table,
    num_rows: num_rows,
    num_cols: num_cols,
    table_size: table_size,
    error: error,
    error_msg: error_msg
  }
end

not_found do
  status 404
  error_msg = 'Invalid Address'
  erb :error, locals: { status: status, error_msg: error_msg }
end

def create_table(num_rows, num_cols, true_symbol, false_symbol, table_size)
  table = Array.new(num_rows) { Array.new(num_cols) }
  (0...2**table_size).each do |i|
    set_row_value i, table, table_size
  end
  table.each.with_index do |row, row_index|
    row.each.with_index do |col, col_index|
      table[row_index][col_index] = (col == '1' ? true_symbol : false_symbol)
    end
  end
  table
end

def set_row_value(row, table, table_size)
  num = (row).to_s(2)
  num = pad_zeroes(num, table_size)
  table_size.times do |i|
    table[row][i] = num[i]
  end
  table[row][table_size] = '1'
  table[row][table_size] = '0' if num.include? '0'
  table[row][table_size + 1] = '0'
  table[row][table_size + 1] = '1' if num.include? '1'
  table[row][table_size + 2] = '0'
  table[row][table_size + 2] = '1' if check_num_ones? num
end

def check_num_ones?(num)
  num_ones = 0
  num.chars.each do |letter|
    num_ones += 1 unless letter != '1'
  end
  num_ones.odd?
end

def pad_zeroes(str, table_size)
  i = str.length
  str_two = ''
  while i < table_size
    str_two += '0'
    i += 1
  end
  str_two + str
end

def table_size_less_than_two?(table_size)
  table_size < 2
end

def true_eq_false?(true_symbol, false_symbol)
  true_symbol == false_symbol
end

def true_or_false_gt_one?(true_symbol, false_symbol)
  true_symbol.length > 1 || false_symbol.length > 1
end
