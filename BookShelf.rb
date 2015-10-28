require "open-uri"
require "nokogiri"

class BookShelf
	def initialize
		@booklist_path = "./store/booklist.txt"
		puts "BookList > BoolListHandler READY!"
	end

	def add isbn
		isbn = calc_isbn10(isbn) if isbn.length == 13
		uri = "http://www.amazon.co.jp/dp/#{isbn}/"

		bookpage = fetch_amazon(uri)
		book_title = bookpage.xpath('//span[@id="productTitle"]').text
		
		write_list(book_title,uri)
		book_title
	end

	def fetch_amazon uri
		user_agent = "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0)"
		page = open(uri,"User-Agent" => user_agent)
		
		charset = page.charset
		body = page.read

		Nokogiri::HTML.parse(body, nil, charset)
	end

	def write_list title,uri
		puts "BookList > WRITE #{title}, #{uri}"
		f = File::open(@booklist_path,"a")
			entry = title + ";" + uri + ";\n"
		f.write(entry)
		f.close
	end

	# ISBN13をISBN10に変換する
	def calc_isbn10(isbn13)
		isbn13 = isbn13.to_s
		isbn10 = isbn13[3..11]
		check_digit = 0
		sbn10.split(//).each_with_index do |chr, idx|
			check_digit += chr.to_i * (10 - idx)
		end
		check_digit = 11 - (check_digit % 11)

		#計算結果が 10 になった場合、10 の代わりに X（アルファベットの大文字）を用いる。
		#また、11 になった場合は、0 となる。
		case check_digit
			when 10 then
				check_digit = "X"
			when 11 then
				check_digit = 0
		end
	return "#{isbn10}#{check_digit}".to_i
	end
end