require 'sinatra'
require 'sinatra/reloader'

html = ""

get '/' do
	error_msg = ''
  erb :index, locals: { error_msg: error_msg }
end

post '/table/:true/:false/:size' do
	  true_symbol 		= "#{params['true'].to_s}"
	  false_symbol 		= "#{params['false'].to_s}"
	  table_size_str	= "#{params['size'].to_s}"

		#If the button is clicked with no input, input is set
	  if table_size_str.empty? && true_symbol.empty? && false_symbol.empty?
	    true_symbol = 'T'
	    false_symbol = 'F'
	    table_size = 3
	    erb :table, locals: { true_symbol: true_symbol, false_symbol: false_symbol, table_size: table_size, html: html }
	  end
		table_size = table_size_str.to_i

		#Error Messages if:
		# => the true or false symbol are more than a symbol
		# => true == false
		# => table_size is < 2
	  if true_symbol.length > 1 || false_symbol.length > 1
	    error_msg = 'True and False must be single characters'
	    erb :index, locals: { error_msg: error_msg }
		end
	  if true_symbol == false_symbol
	    error_msg = 'True cannot equal false'
	    erb :index, locals: { error_msg: error_msg }
		end
	  if table_size < 2
	    error_msg = 'Size must be >= 2'
	    erb :index, locals: { error_msg: error_msg }
	  end

		erb :table, locals: { true_symbol: true_symbol, false_symbol: false_symbol, table_size: table_size, html: html }
end

not_found do
  status 404
  erb :error, locals: { status: status }
end

get '/table' do
	  true_symbol 		= "#{params['true'].to_s}"
	  false_symbol 		= "#{params['false'].to_s}"
	  table_size_str	= "#{params['size'].to_s}"
	#2^x for number of combinations and then add 1 for the header row
  num_rows = (2**table_size) + 1
	#Add 3 for the And, Or, Xor columns
	num_cols = table_size + 3
	true_false_int_array = Array.new(num_cols) { 0 }
	saved_combinations = Array.new(num_rows)
	html = "<table \"width:100%\">"

  table = Array.new(num_rows) { Array.new(num_cols) }

	#Adds column headers starting with table_size-1..0
	i = 0
	j = (table_size-1)
	html += "<tr>"
	while i < table_size do
		html += "<th>"
		html += j.to_s
		html += "</th>"
		i = i + 1
		j = j - 1
	end
	#Add final headrs for And, Or, and XOR
	html += "<th>AND</th>"
	html += "<th>OR</th>"
	html += "<th>XOR</th>"
	html += '</tr>'


	i = 0
	j = 0
	while i < num_rows do
		html += "<tr>"
		while j < num_cols do
			html += "<td>"
			html += true_symbol
			html += "</td>"
			j = j+1
		end
		html += "</tr>"
		i = i+1
	end

	html += "</table>"
	erb :table, locals: { html: html }
end

def find_string_and_fill_array array
	k = 0
	k
end
