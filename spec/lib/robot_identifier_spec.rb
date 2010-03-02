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
        @instance.find(:first, 'useragent', 'MyRobot')['id'].should == 'my-robot'
      end
      
      it 'should return nil if :first is specified and no robots match' do
        @instance.find(:first, 'useragent', /muggins/).should be_nil
      end
    end

    describe 'when called with a useragent' do
      it 'should return any robot matching useragent if passed just the user agent' do
        @instance.find('iRobot').should be_a(Hash)
        @instance.find('iRobot')['id'].should == 'i-robot'
      end
      
      it 'should return nil if a useragent is specified and no robots match' do
        @instance.find('muggins').should be_nil
      end
    end
  end
end