require 'spec_helper'

describe SmallBuildJob do
  it_behaves_like "a retryable job"
  it_behaves_like "a buildable job"
end
