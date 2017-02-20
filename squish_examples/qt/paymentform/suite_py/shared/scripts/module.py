#import sys
import test
from squish import *

class Run:
    def clickRadioButton(self, radioButtonName):
        radioButton = waitForObject("{text='%s' type='QRadioButton' visible='1'"
                                    "window=':Make Payment_MainWindow'}" % radioButtonName)
        if not radioButton.checked:
            clickButton(radioButton)
        test.verify(radioButton.checked)
#        test.log(sys.modules.keys())
#        test.log(dir(sys.modules["squish"]))
