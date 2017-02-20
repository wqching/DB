package main;

OnScenarioEnd(sub {
    foreach (applicationContextList()) {
        $_->detach();
    }
});
