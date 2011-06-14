require "mongoid/spec_helper"

describe Mongoid::Extensions::Symbol::Inflections do  
  describe "#within_center" do  
    let(:criteria) do
      base.where(:location.within_center => [[ 72, -44 ], 5])
    end
  
    it "adds the $within and $center modifiers to the selector" do
      criteria.selector.should ==
        { :location => { "$within" => { "$center" => [[ 72, -44 ], 5]} }}
    end
  end  

  describe "#within_center hash circle" do  
    let(:center) { [ 72, -44 ] }
    let(:circle) do
      {:center => center, :radius => 5}
    end
    
    let(:criteria) do
      base.where(:location.within_center => circle)
    end
  
    it "adds the $within and $center modifiers to the selector" do
      criteria.selector.should ==
        { :location => { "$within" => { "$center" => [[ 72, -44 ], 5]} }}
    end
  end 
  
  describe "#within_center sphere" do  
    let(:criteria) do
      base.where(:location.within_center(:sphere) => [[ 72, -44 ], 5])
    end
  
    it "adds the $within and $center modifiers to the selector" do
      criteria.selector.should ==
        { :location => { "$within" => { "$centerSphere" => [[ 72, -44 ], 5]} }}
    end
  end    
end