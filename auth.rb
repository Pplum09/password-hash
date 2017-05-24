require 'digest/md5'
require 'sqlite3'
require 'io/console'

def init

  @columns = ['username', 'password']
  @db_file = 'auth.db'
  @table_name = 'users'

  constructMenu()

end

def authenticate

  creds = getCredentials()

  username = creds[:username]
  password = creds[:password]

  # insert into db
  begin

    # connect to db
    db = SQLite3::Database.open @db_file

    # construct query
    query = 'SELECT * FROM ' + @table_name + ' WHERE USERNAME = "' + username + '";'

    # execute query
    res = db.execute query

    if res.empty?
      return false

    # veryify password
    elsif password == res.first[2]

      return true
    end

  ensure
    db.close if db
  end

  return false

end

def addUser

  creds = getCredentials true

  username = creds[:username]
  password = creds[:password]
  confirm = creds[:confirm]

  if password == confirm

    insert = [username, password]

    # insert into db
    begin

      # connect to db
      db = SQLite3::Database.open @db_file

      # construct query
      query = 'INSERT INTO ' + @table_name + '(username, password) VALUES("' + username + '","' + password + '");'

      # execute query
      db.execute query

    # used rescue non - unique / other constraints
    rescue SQLite3::ConstraintException

      raise ArgumentError, 'username, ' + username + ', is already taken!'

    ensure
      db.close if db
    end

    return true
  else
    return false
  end
end

def constructMenu

  options = []
  options.push({:type => 'login', :display => 'Login'})
  options.push({:type => 'new_account', :display => 'New Account'})
  options.push({:type => 'exit', :display => 'Exit'})
  return options
end

def printMenu
  options = constructMenu()
  (0...options.length).each do |i|
    puts (i + 1).to_s + '. ' + options[i][:display]
  end
end

def getCredentials confirm=false

  ret = {}

  print 'username: '
  ret[:username] = gets.chomp.downcase
  print 'password: '
  ret[:password] = Digest::MD5.hexdigest STDIN.noecho(&:gets).chomp

  puts '' # used for line break after entering in hidden pwd
  if confirm
    print 'confirm password: '
    ret[:confirm] = Digest::MD5.hexdigest STDIN.noecho(&:gets).chomp
    puts ''
  end

  return ret

end

leave = false
init()

#TODO think of some other way to get user input. Using numbers to get
# menu choice is not easily scalable in case new options are added
while !leave

  printMenu
  print 'Selection: '
  case gets.chomp.downcase.to_i

  when 1
    if !authenticate()
      puts 'username and / or password is incorrect'
    else
      puts 'user successfully authenticated!'
    end
  when 2

    begin

      if !addUser
        puts 'passwords do not match'
        next
      end

        puts 'user created!'

    rescue ArgumentError => exception
      puts exception
    end

  when 3
    leave = true
  else
    puts 'invalid choice!'
  end
end