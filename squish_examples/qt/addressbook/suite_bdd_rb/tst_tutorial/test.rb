# encoding: UTF-8
require 'squish'
require 'squish/bdd'

include Squish::BDD
setupHooks "../shared/scripts/bdd_hooks.rb"
collectStepDefinitions "./steps", "../shared/steps"

def main
    Squish::TestSettings.throwOnFailure = true
    Squish::runFeatureFile "test.feature"
end
