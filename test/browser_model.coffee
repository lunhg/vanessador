Selector = require('testcafe').Selector

label = Selector('label')

class Feature
    constructor: (text) ->
        @label    = label.withText(text)
        @checkbox = label.find('input[type=checkbox]')


class Page
        constructor: ->
                @nameInput             = Selector('#developer-name')
                @triedTestCafeCheckbox = Selector('#tried-test-cafe')
                @populateButton        = Selector('#populate')
                @submitButton          = Selector('#submit-button')
                @results               = Selector('.result-content')
                @macOSRadioButton      = Selector('input[type=radio][value=MacOS]')
                @commentsTextArea      = Selector('#comments')

                @featureList = [
                    new Feature('Support for testing on remote devices'),
                    new Feature('Re-using existing JavaScript code for testing'),
                    new Feature('Easy embedding into a Continuous integration system')
                ]
        
                @slider = {
                    handle: Selector('.ui-slider-handle'),
                    tick:   Selector('.slider-value')
                }

                @interfaceSelect       = Selector('#preferred-interface')
                @interfaceSelectOption = this.interfaceSelect.find('option')
