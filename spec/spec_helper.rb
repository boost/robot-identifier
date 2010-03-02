require 'lib/robot_identifier'

class RobotIdentifier
  ROBOTS = {'my-robot' => {'id' => 'my-robot', 'useragent' => 'MyRobot'},
            'i-robot' => {'id' => 'i-robot', 'useragent' => 'iRobot'}}
  USER_AGENTS = {'MyRobot' => 'my-robot', 'iRobot' => 'i-robot'}
end