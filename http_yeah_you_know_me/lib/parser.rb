class Parser

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

  def get_word(path)
    word = path.split("=")[1]
  end

end
