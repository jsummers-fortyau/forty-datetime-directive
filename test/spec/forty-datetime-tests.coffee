
ele = undefined
markup = undefined
scope = undefined
iScope = undefined
compile = undefined
rootScope = undefined
httpBackend = undefined

# Standardize
dateFix = {
  valid_format_future: '02/27/1984'
  valid_format_past: '02/27/2016'
  invalid_format_a: '2016--02--27'
  invalid_characters: '20ab38js-dd'
}

describe 'forty-date-picker: ', ->

  beforeEach module('fortyDate')

  beforeEach inject((
      $rootScope
      $compile
      $httpBackend
    ) ->

    compile = $compile
    scope = $rootScope.$new()

    markup = '<forty-date-picker' +
                    ' ng-model="date"' +
                    ' disabled="is_disabled"> ' +
            '</forty-date-picker>'

    ele = compile(markup)(scope)
    scope.$digest()
    iScope = ele.isolateScope()

  )

  it 'should expect something!', ->
    expect(true).toBe(true)

  describe 'methods and variables that should be exposed on the scope', ->
    it 'should have a place to store the format', ->
      expect(iScope.format).toBeDefined()

    it 'should have a switch to open the datepicker', ->
      expect(iScope.opened).toBeDefined()

    it 'should have a method to toggle open the datepicker', ->
      expect(iScope.open).toBeDefined()


  describe 'acceptable attributes and defaults', ->
    it 'should have the datepicker closed by default', ->
      expect(iScope.opened).toBe(false)

    it 'should toggle the opened flag when clicked', ->
      event = scope.$emit("click")
      opened = iScope.opened
      iScope.open(event)
      expect(opened).not.toBe(iScope.opened)

    it 'should have a default for the date format that is a string', ->
      expect(typeof iScope.format).toBe('string')

    it 'should have a default for the date format', ->
      expect(iScope.format).toBe('MM/dd/yyyy')

  describe 'should have some elements on the rendered directive', ->
    it 'should have an input field', ->
      expect(ele.find('input').length).toBeGreaterThan(0)

    it 'should have a button to open the datepicker', ->
      expect(ele.find('button').length).toBeGreaterThan(0)

  describe 'its ability to mask the input', ->
    it 'should have a default value of the mask if no date is set', ->
      compile(ele)(scope)
      scope.$digest()

    it 'should', ->
      $input = $('input', ele)
      console.log $input[0].value
      console.log $input.val()
      $input.focus().trigger(jQuery.Event( {
        type: 'keypress'
        keyCode: 111
        which: 111
        charCode: 111
      } ))
      console.log $('input', ele).val()




