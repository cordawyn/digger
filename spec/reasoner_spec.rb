require File.join(File.dirname(__FILE__), "spec_helper")
require 'ostruct'

# Specifications are in accordance with
# 'The DIG Description Logic Interface: DIG/1.1' book
# dated February 7, 2003
describe Digger::Reasoner do

  before :all do
    # Initializing DIG engine with settings for Pellet
    @reasoner = Digger::Reasoner.new('localhost', 8081)
    @fixture = YAML.parse_file(File.join('spec', 'fixtures', 'reasoner.yml')).transform
    @httpok = Net::HTTPOK.new('1.1', '200', 'OK')
  end

  it "must output DIG reasoner capabilities" do
    output = OpenStruct.new(:response => @httpok, :body => @fixture['identification'])
    Net::HTTP.should_receive(:start).and_return(output)

    capabilities = @reasoner.info
    @reasoner.response.class.should be(Net::HTTPOK)
    capabilities.should be_an_instance_of(Hash)
    capabilities.keys.should include(:name, :message, :version)
  end

  describe "knowledge bases" do

    after :each do
      remove_knowledge_bases
    end

    it "must output UUID for a new knowledge base" do
      kb = create_new_kb
      @reasoner.response.class.should be(Net::HTTPOK)
      kb.should be_an_instance_of(String)
      kb.should_not be_empty
    end

    it "must return kb_uuid when a knowledge base is released" do
      kb_uuid = nil
      lambda { kb_uuid = create_new_kb }.should change(@reasoner.knowledge_bases, :size).by(1)

      output = OpenStruct.new(:response => @httpok, :body => @fixture['ok'])
      Net::HTTP.should_receive(:start).and_return(output)

      @reasoner.release_knowledge_base(kb_uuid).should eql(kb_uuid)
      @reasoner.response.class.should be(Net::HTTPOK)
    end

  end

  describe "query" do

    before :each do
      output = OpenStruct.new(:response => @httpok, :body => @fixture['query'])
      Net::HTTP.should_receive(:start).and_return(output)
      @kb = "some_kb_uuid"
    end

    it "should query the knowledge base" do
      @reasoner.ask(@kb, "<allConceptNames/>").should eql("equipment" => ["http://www.appliedlinguisticsgroup.com/owl/tc_equipment.owl#solenoid"])
    end

    it "should return a list of concepts" do
      @reasoner.all_concept_names(@kb).should eql(["http://www.appliedlinguisticsgroup.com/owl/tc_equipment.owl#solenoid"])
    end

  end


  private

  def create_new_kb
    output = OpenStruct.new(:response => @httpok, :body => @fixture['new_knowledge_base'])
    Net::HTTP.should_receive(:start).and_return(output)

    @reasoner.new_knowledge_base
  end

  def remove_knowledge_bases
    output = OpenStruct.new(:response => @httpok, :body => @fixture['ok'])
    Net::HTTP.stub(:start).and_return(output)

    @reasoner.knowledge_bases.each do |kb_uuid|
      @reasoner.release_knowledge_base(kb_uuid)
    end
    @reasoner.knowledge_bases.should be_empty
  end

end
