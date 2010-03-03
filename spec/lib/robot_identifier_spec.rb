require 'spec_helper'

describe RobotIdentifier do
  before do
    @instance = RobotIdentifier.new
  end
  
  describe '#find' do
    describe 'when called with :all' do
      it 'should return all robots matching a useragent' do
        robots = @instance.find(:all, 'useragent', /robot/i)   
        robots.size.should == 2
        robots.should be_a(Array)
      end

      it 'should return any empty array if no robots match' do
        robots = @instance.find(:all, 'useragent', /muggins/)
        robots.should be_a(Array)
        robots.empty?.should be_true
      end
    end

    describe 'when called with :first' do
      it 'should return any robot matching useragent if the key is useragent' do
        robot = @instance.find(:first, 'useragent', /robot/i)
        robot.should be_a(Hash)
        robot['id'].should =~ /robot/
      end
      
      it 'should return the exact match if there is only one matching useragent' do
        @instance.find(:first, 'useragent', 'MyRobot/2.X (+html http://myrobot.com)')['id'].should == 'my-robot'
      end
      
      it 'should return nil if :first is specified and no robots match' do
        @instance.find(:first, 'useragent', /muggins/).should be_nil
      end
    end

    describe 'when called with a useragent' do
      it 'should return the first robot matching useragent if passed a regex' do
        robot = @instance.find(/robot/i)
        robot.should be_a(Hash)
        robot['id'].should =~ /robot/
      end
      
      it 'should return any robot matching useragent if passed just the user agent' do
        @instance.find('iRobot 1.0a').should be_a(Hash)
        @instance.find('iRobot 1.0a')['id'].should == 'i-robot'
      end
      
      it 'should return nil if a useragent is specified and no robots match' do
        @instance.find('muggins').should be_nil
      end
    end
  end
  
  describe '#exists?' do
    it 'should return true if there is a robot with that useragent' do
      @instance.exists?('iRobot 1.0a').should be_true
    end
    
    it 'should return true if there is a robot matching that useragent regexp' do
      @instance.exists?(/robot/i).should be_true
    end
    
    it 'should return false if there is no robot matching that useragent' do
      @instance.exists?('Muggins').should be_false
      @instance.exists?(/arobot/).should be_false
    end
  end
  
  describe '#identify' do
  end
end