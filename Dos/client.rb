require 'socket'

@client
@out = 0

if ARGV.size != 2
  puts "Usage: ruby #{__FILE__} [host] [port]"
	exit
else
	@client = TCPSocket.new(ARGV[0], ARGV[1].to_i)
end

def search(route)
	begin
		dir = Dir.entries(route)
		exp = /^[a-zA-Z|0-9]/
		dir.each do | file |
			if (exp.match(file))
				@client.puts(file)
			end
		end
	rescue 
		@client.puts("Error")
	end
end 

def public(archivo)
	dir = File.split(route)
	Dir.chdir(dir[0])
	if(File.exists?(dir[1]))
		puts("dir #{dir[0]} archivo #{dir[1]}")
	else
		puts("error el archivo no existe")
	end	
end

def copy(route)
	dir = File.split(route)
	puts dir[0]
	Dir.chdir(dir[0])
	if(File.exists?(dir[1]))
		puts "Preparando copiado"
		ext = File.extname(dir[1])
		@client.puts("Copy #{dir[1]}")
		file = File.open(dir[1])
		file.each do |line|
			@client.puts(line)			
		end	
		file.close
		@client.puts("eof")		
		puts "Archivo copiado con exito"
	else
		@client.puts("error el archivo no existe")
	end
	
end

def copying(name)
	begin
		f = File.new(name, "w+")
		message = ""
		while (message != "eof")
			message = @client.gets.chomp
			if(message != "eof")		
				f.write(message+"\n")
			end
		end
		f.close
	rescue
		@client.puts("Error")
	end
end


def thread_send
	begin	
		while not STDIN.eof?
			out = STDIN.gets.chomp
			if out.eql? "help"
				help
			elsif out.eql? "quit"
				exit
			elsif out.split(" ").eql? "public"
				out = out.split(" ", 2)
				public(out[1])
			else
				@client.puts(out)
			end
		end
	end
end


def thread_read
	begin
		while not @client.eof?
			messageIn = @client.gets.chomp
			puts messageIn		
			temp  = messageIn.split(' ')
				if (temp[0].eql? "ls")
					search(temp[1])
				elsif (temp[0].eql? "cp")					
					copy(temp[1])
				elsif (temp[0].eql? "Copy")
					copying(temp[1])
				end		
		end
	end
end

def help
	puts "Ayuda"
	puts "Algo"
	puts "algo mas"
end


read = Thread.new{thread_read}
send = Thread.new{thread_send}

read.join
send.join




