require 'socket'

class Client
	include Color

	@client

	def initialize(ip,puerto)
		@client = TCPSocket.new(ip,puerto)
	end
	
	def run
		thread1 = Thread.new{thread_recv}
		thread2 = Thread.new{thread_send}

		thread1.join
		thread2.join
	end
	
	# Hilo de envio de mensajes
	def thread_send
			begin	
			while not STDIN.eof?
				lineOut = STDIN.gets.chomp
				if lineOut == "QUIT" || lineOut == "quit"
					exit
				else
					sendM(lineOut)
				end
			end
		end
	end

	# Hilo de recivo de mensajes
	def thread_recv

		begin
			while not @client.eof?
				lineIn = getM()
				puts lineIn		
				temp  = lineIn.split(' ')
					if (temp[0].eql? "cd")
						cd(temp[1])	
					elsif (temp[0].eql? "ls")
						ls(temp[1])
					elsif (temp[0].eql? "cp")
						cp(temp[1])					
					elsif (temp[0].eql? "create")
						create(temp[1])
					elsif (temp[0].eql? 'quit')
						exit
					end		
			end
		end
	end

	#envia mensaje por socket
	def sendM(message)
		@client.puts(message)	
	end

	#revive mensaje del socket
	def getM()
		@client.gets.chomp
	end	

	#emula comando cd
	def cd (route)
		Dir.chdir(route)
		#puts Dir.pwd
		a = Dir.pwd
		sendM(a)
	end

	#emula el comando ls
	def ls(route)
		begin
			a = Dir.entries(route)
			exp = /^[a-zA-Z|0-9]/
			a.each do | file |
				if (exp.match(file))
					sendM(file)
				end
			end
		rescue
			sendM("Error: verifica tu sintaxis")
		end
	end 

	#emula comando cp
	def cp(route)
		begin
			dir = File.split(route)
			puts dir[0]
			Dir.chdir(dir[0])
			if(File.exists?(dir[1]))
				puts "exist"
				puts Dir.pwd
				puts dir[1]
				ext = File.extname(dir[1])
				sendM("create #{dir[1]} ")
				file = File.open(dir[1])
				file.each do |line|
					sendM(line)			
						
				end	
				file.close
				sendM("eof")		
		
			else
				sendM("error el archivo no existe")
			end
		rescue
			sendM("Error: verifica tu sintaxis")
		end	
	end
 
	# Crea un archivo 
	def create(name)
		f = File.new(name, "a")
		message = ""
		while (message != "eof")
			message = getM()
			if(message != "eof")		
				f.write(message+"\n")
				puts message
			end
		end
	
		f.close
	end

	

	


	

end

if ARGV.size != 2
  puts "Modo correcto de uso: ruby #{__FILE__} [ipServer] [puerto]"
else
	client = Client.new(ARGV[0], ARGV[1].to_i)
  client.run
end
