var Feature, Page, Selector, clickLogin, label;

Selector = require('testcafe').Selector;

label = Selector('label');

Feature = (function() {
  function Feature(text) {
    this.label = label.withText(text);
    this.checkbox = label.find('input[type=checkbox]');
  }

  return Feature;

})();

Page = (function() {
  function Page() {
    this.nameInput = Selector('#developer-name');
    this.triedTestCafeCheckbox = Selector('#tried-test-cafe');
    this.populateButton = Selector('#populate');
    this.submitButton = Selector('#submit-button');
    this.results = Selector('.result-content');
    this.macOSRadioButton = Selector('input[type=radio][value=MacOS]');
    this.commentsTextArea = Selector('#comments');
    this.featureList = [new Feature('Support for testing on remote devices'), new Feature('Re-using existing JavaScript code for testing'), new Feature('Easy embedding into a Continuous integration system')];
    this.slider = {
      handle: Selector('.ui-slider-handle'),
      tick: Selector('.slider-value')
    };
    this.interfaceSelect = Selector('#preferred-interface');
    this.interfaceSelectOption = this.interfaceSelect.find('option');
  }

  return Page;

})();

fixture("Using vanessador in browser").page("https://zzxgmagb.p6.weaved.com");

clickLogin = function(t) {};

test('Click login', clickLogin);
