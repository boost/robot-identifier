require 'lib/robot_identifier'

class RobotIdentifier
  ROBOTS = {
    'my-robot' => {'id' => 'my-robot', 'useragent' => 'MyRobot/2.X (+html http://myrobot.com)'},
    'i-robot' => {'id' => 'i-robot', 'useragent' => 'iRobot 1.0a'},
    'spider' => {'id' => 'spider', 'useragent' => 'Mozilla/5.0 (compatible; spider)'}
  }
  USER_AGENTS = {'MyRobot/2.X (+html http://myrobot.com)' => 'my-robot', 'iRobot 1.0a' => 'i-robot', 'Mozilla/5.0 (compatible; spider)' => 'spider'}
end