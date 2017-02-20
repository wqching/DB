# Detach (i.e. potentially terminate) all AUTs at the end of a scenario
@OnScenarioEnd
def hook(context):
    for ctx in applicationContextList():
        ctx.detach()
