require 'test_helper'

class NodeUnitTest < Test::Unit::TestCase
  
  context "A Node" do
    
    setup do
      @node = Node.new(11011).instance_variable_get(:@app)
    end
    
    should "instantiate correctly" do
      assert @node.server.to_s == "http://localhost:9173"
      assert @node.port == 11011
      assert @node.host == Socket.gethostname
      assert @node.enabled_actions.length > 2
      assert @node.asset_store.is_a? AssetStore::FilesystemStore
    end
    
    should "trap signals and launch a server at start" do
      Signal.expects(:trap).times(3)
      Thin::Server.expects(:start)
      @node.expects(:check_in)
      @node.start
    end
    
    should "be able to determine if the node is overloaded" do
      assert !@node.overloaded?
      @node.instance_variable_set :@max_load, 0.01
      assert @node.overloaded?
      @node.instance_variable_set :@max_load, nil
      assert !@node.overloaded?
      @node.instance_variable_set :@min_memory, 8000
      assert @node.overloaded?
    end
      
  end
  
end