require 'metric_fu'

MetricFu::Configuration.run do |config|
  config.rcov[:test_files] = ['spec/**/*_spec.rb']
  config.rcov[:rcov_opts] << "-Ispec --comments" # Needed to new spec_helper
end