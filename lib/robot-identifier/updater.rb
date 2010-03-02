require 'rubygems'
require 'em-http'

class RobotIdentifierUpdater
  UPDATE_URL = "http://www.robotstxt.org/db/all.txt"
  DATABASE_FILE = File.join(File.dirname(__FILE__), 'robots.txt')
  DATABASE_SCRIPT = File.join(File.dirname(__FILE__), 'database.rb')
  
  def initialize
    @robots = {}
    @user_agents = {}
  end

  def download(force = false)
    if force || !File.exists?(DATABASE_FILE)
      puts "Downloading from #{UPDATE_URL}"
      
      # Clear the file
      File.open(DATABASE_FILE, 'w') do |file|
        file.write ''
      end
      
      EventMachine.run do
        http = EventMachine::HttpRequest.new(UPDATE_URL).get
        http.callback do
          File.open(DATABASE_FILE, 'w') do |file|
            file.write http.response
          end
          
          update
          EventMachine.stop
        end

        false
      end
    else
      true
    end
  end

  def update
    if download
      puts "Parsing"
      
      @robots = {}
      @user_agents = {}

      db = open(DATABASE_FILE, 'r')

      robot = nil
      while line = db.gets
        if line =~ /^robot-id/
          add_robot(robot) if robot          
          robot = {}
        end

        if robot && line =~ /^(?:robot-)?(.*?):\s*(.*?)\s*$/
          robot[$1] = $2
        end
      end
      
      write_database_script
    end
  end
  
  private 
  
  def add_robot(robot)
    if robot['id']
      @robots[robot['id']] = robot

      if robot['useragent']
        @user_agents[robot['useragent']] = robot['id']
      end
    end
  end
  
  def write_database_script
    File.open(DATABASE_SCRIPT, 'w') do |file|
      file.puts "class RobotIdentifier"
      file.write "ROBOTS = {"
      keys = @robots.keys
      keys.each do |name|
        value = @robots[name]
        file.write name.inspect + ' => ' + value.inspect
        file.write ',' unless name == keys.last
        file.write "\n"
      end
      file.puts "}"
      file.puts "USER_AGENTS = %s" % @user_agents.inspect
      file.puts "end"
    end
  end
end