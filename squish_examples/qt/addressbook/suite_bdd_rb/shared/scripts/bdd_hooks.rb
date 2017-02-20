require 'squish'

include Squish

# Detach (i.e. potentially terminate) all AUTs at the end of a scenario
OnScenarioEnd do |context|
    applicationContextList().each { |ctx| ctx.detach() }
end

