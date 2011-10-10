require 'socket'

@client = TCPSocket.new('127.0.0.1','2000')

@n = 0
messageIn = {}
command = {}

#emula comando cd
def cd (route)
	Dir.chdir(route)
	#puts Dir.pwd
	a = Dir.pwd
	send_mess(a)
end

#emula el comando ls
def ls(route)
	a = Dir.entries(route)
	exp = /^[a-zA-Z|0-9]/
	a.each do | file |
		if (exp.match(file))
			puts file
			send_mess(file)
		end
	end
end 

#envia mensaje por socket
def send_mess(mess)
	#puts mess
	@client.puts(mess)	
end

#revive mensaje del socket
def recv_mess()
	menssage = @client.gets.chomp
	return (menssage)
end

#hilo de envio de mensajes
Thread.new do 
	loop do
		messageOut = gets
		send_mess(messageOut)
	end

end

#hilo de recivo de mensajes
Thread.new do
	loop do
		messageIn = recv_mess()
		puts messageIn		
		temp  = messageIn.split(' ')
		command [0] = temp[0]
		command [1] = temp[1]
	
			if (temp[0].eql? "cd")
				cd(temp[1])	
			elsif (temp[0].eql? "ls")
				ls(temp[1])
			elsif (temp[0].eql? 'quit')
				@n = 1
			end
		
	end

end

while (@n.eql? 0 )

end


