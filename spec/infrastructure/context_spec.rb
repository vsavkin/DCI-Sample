require 'unit_spec_helper'

describe Context do
  class TestContext
    include Context

    def run_in_context
      in_context do
        yield
      end
    end
  end

  class TestRole
    include ContextAccessor
  end

  context "#in_context" do
    let(:ctx){TestContext.new}
    let(:nested_ctx){TestContext.new}
    let(:role){TestRole.new}

    it "should pass on returned value" do
      return_value = ctx.run_in_context{"RETURNED VALUE"}
      return_value.should == "RETURNED VALUE"
    end

    it "should maintain stack of contexts" do
      actual_context = ctx.run_in_context do
        nested_ctx.run_in_context{}
        role.context
      end
      actual_context.should == ctx
    end

    it "should maintain stack of contexts (nested case)" do
      ctx.run_in_context do
        actual_nested_ctx = nested_ctx.run_in_context do
          role.context
        end
        actual_nested_ctx.should == nested_ctx
      end
    end
  end
end
