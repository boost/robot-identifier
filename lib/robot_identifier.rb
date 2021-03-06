class RobotIdentifier
  def find(all_or_first, key = nil, value = nil)
    if all_or_first == :all
      find_all(key, value)
    elsif all_or_first == :first
      find_first(key, value)
    else
      if all_or_first.is_a?(Regexp)
        find_first('useragent', all_or_first)
      else      
        ROBOTS[USER_AGENTS[all_or_first]]
      end
    end
  end
  
  def exists?(user_agent)
    !!(user_agent.is_a?(Regexp) ? USER_AGENTS.keys.detect{|key| key =~ user_agent} : USER_AGENTS.has_key?(user_agent))
  end
  
  def method_missing(symbol, *args)
    if symbol.to_s =~ /find_by_(.*)/
      find(:first, $1, *args)
    elsif symbol.to_s =~ /find_all_by_(.*)/
      find(:all, $1, *args)
    else
      super
    end
  end
  
  def identify(useragent)
    useragent = useragent.to_s.dup
    
    unless useragent.nil? || useragent == ''
      useragent.gsub!(/[^\w\d\s\/:.]/, '.*')
      useragent.gsub!(/\//, '\/')    
      useragent.gsub!(/[\dX]+(.[\dX]+)?/, '[\dX]+(.[\dX]+)?')
      useragent.gsub!(/\s+/, '\s+')
    
      find(:first, 'useragent', /#{useragent}/i)
    end
  end
  
  private
  
  def find_first(key, value)
    ROBOTS.values.detect do |robot|
      if value.is_a?(Regexp)
        robot[key] =~ value
      else
        robot[key] == value
      end
    end
  end
  
  def find_all(key, value)
    ROBOTS.values.select do |robot|
      if value.is_a?(Regexp)
        robot[key] =~ value
      else
        robot[key] == value
      end
    end
  end
end

begin
  require File.join(File.dirname(__FILE__), 'robot-identifier', 'database.rb')
rescue LoadError
  puts "Robot identifier cannot be used until it has been updated. Run sudo robot-identifier-update"
end