use warnings;
use strict;
use Squish::BDD;

setupHooks("../shared/scripts/bdd_hooks.pl");
collectStepDefinitions("./steps", "../shared/steps");

sub main {
    testSettings->throwOnFailure(1);
    runFeatureFile("test.feature");
}
