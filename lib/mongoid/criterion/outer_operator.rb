# encoding: utf-8
module Mongoid #:nodoc:
  module Criterion #:nodoc:
    # Complex criterion are used when performing operations on symbols to get
    # get a shorthand syntax for where clauses.
    #
    # Example:
    
    # {:outer_operator => 'within', :operator => 'center' }
    # { :location => { "$within" => { "$center" => [ [ 50, -40 ], 1 ] } } }
    class OuterOperators < TwinOperators
      # Create the new complex criterion.
      def initialize(opts = {})
        super
      end

      # this is called by CriteriaHelpers#expand_complex_criteria in order to generate
      # the command hash sent to the mongo DB to be executed
      # depending on whether the operator is some kind of box or center command, the
      # operator will point to a different type of array  
      def make_hash v                               
        points = circle? ? circle(v) : box(v)        
        {"$#{outer_op}" => {"$#{operator}" => points.to_a } }
      end

      def hash
        [@op_a, [@op_b, @key]].hash
      end
      
      protected

      def circle?
        operator =~ /center/
      end

      def box?
        operator =~ /box/
      end

      def circle(v)
        Mongoid::Geo::Shapes::Circle.new(v)
      end

      def box(v)
        Mongoid::Geo::Shapes::Box.new(v)
      end
    end
  end
end
