source [findFile "scripts" "tcl/bdd.tcl"]

Squish::BDD::setupHooks "../shared/scripts/bdd_hooks.tcl"
Squish::BDD::collectStepDefinitions "./steps" "../shared/steps"

proc main {} {
    testSettings set throwOnFailure true
    runFeatureFile "test.feature"
}
