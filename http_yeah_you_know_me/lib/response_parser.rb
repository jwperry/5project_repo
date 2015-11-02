require 'pry'
class ResponseParser

  def initialize
  end

  def get_verb(string)
    string[0].split(" ")[0]
  end

  def get_path(string)
    string[0].split(" ")[1]
  end

  def get_protocol(string)
    string[0].split(" ")[2]
  end

  def get_host(string)
    string[1].split(":")[1].strip
  end

  def get_port(string)
    string[1].split(":")[2]
  end

  def get_origin(string)
    string[1].split(":")[1].strip
  end

  def get_accept(string)
    string[4].split(" ")[1]
  end

  def formatter(request_lines)
    response = []
    response << "Verb: #{get_verb(request_lines)}"
    response << "Path: #{get_path(request_lines)}"
    response << "Protocol: #{get_protocol(request_lines)}"
    response << "Host: #{get_host(request_lines)}"
    response << "Port: #{get_port(request_lines)}"
    response << "Origin: #{get_origin(request_lines)}"
    response << "Accept: #{get_accept(request_lines)}"
  end

end
