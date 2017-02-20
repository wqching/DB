# Detach (i.e. potentially terminate) all AUTs at the end of a scenario
OnScenarioEnd {context} {
    foreach ctx [applicationContextList] {
        applicationContext $ctx detach
    }
}

