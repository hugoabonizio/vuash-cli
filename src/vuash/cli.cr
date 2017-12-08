require "option_parser"
require "io/console"

module Vuash
  module CLI
    extend self

    def run(args)
      return banner if args.size == 0
      action = args[0]
      return banner unless {"read", "write"}.includes? action
      case action
      when "read"
        if args.size == 2
          uuid = args[1]
          print "Encryption key: "
          password = STDIN.noecho &.gets.try &.chomp
          puts
        elsif args.size == 3
          uuid = args[1]
          password = args[2]
        else
          return banner
        end
        read(uuid, password)
      when "write"
        return banner unless args.size == 2
        message = args[1]
        write(message)
      end
    end

    private def read(uuid, password)
      raise InvalidPassword.new unless password
      result = Reader.run(uuid, password)
      puts "Message: #{result}"
    rescue ex : ServerException
      puts "Error: #{ex}"
    end

    private def write(message)
      result = Writer.run(message)
      puts "UUID: #{result[:id]}"
      puts "Secret: #{result[:secret]}"
    end

    private def banner
      puts %(Usage:
  vuash read UUID [SECRET]
  vuash write MESSAGE)
    end
  end
end
