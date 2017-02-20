OnScenarioEnd(function(context) {
    applicationContextList().forEach(function(ctx) { ctx.detach(); });
});
