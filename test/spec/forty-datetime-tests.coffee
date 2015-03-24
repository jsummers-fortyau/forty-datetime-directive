
ele = undefined
markup = undefined
scope = undefined
iScope = undefined
compile = undefined
rootScope = undefined
httpBackend = undefined
defaultMask = undefined

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

    defaultMask = ()->
      '__/__/____'

    compile = $compile
    scope = $rootScope.$new()

    scope.test = 'placeholder'
    scope.name = 'duaneinput'
    scope.is_disabled = false

    markup = '<forty-date-picker' +
                    ' ng-model="date"' +
                    ' placeholder="test"' +
                    ' name="name"' +
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

    it 'should have a placehodler', ->
      expect(iScope.placeholder).toBeDefined()

    it 'should have a name', ->
      expect(iScope.name).toBeDefined()


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

    it 'should have a disabled attribute on the scope', ->
      compile(ele)(scope)
      scope.$digest()
      expect(iScope.disabled).toBeDefined()


  describe 'should have some elements on the rendered directive', ->
    it 'should have an input field', ->
      expect(ele.find('input').length).toBeGreaterThan(0)

    it 'should have a button to open the datepicker', ->
      expect(ele.find('button').length).toBeGreaterThan(0)

  describe 'its ability to mask the input', ->
    it 'should have a default value of the mask if no date is set', ->
      compile(ele)(scope)
      scope.$digest()
      $input = $('input', ele)
      # TODO hardcoded format for the sake of time
      expect($input[0].value).toBe(defaultMask())

    it 'should have a date if one is provided', ->

    it 'should not allow letters into the date', ->
      compile(ele)(scope)
      scope.$digest()
      $input = $('input', ele)

      $input.focus().trigger(jQuery.Event( {
        type: 'keypress'
        keyCode: 65 # A
        which: 65
        charCode: 65
      } ))

      scope.$digest()
      expect($input[0].value).toBe(defaultMask())

    it 'should not allow letters into the date', ->
      compile(ele)(scope)
      scope.$digest()
      $input = $('input', ele)

      $input.focus().trigger(jQuery.Event( {
        type: 'keypress'
        keyCode: 65 # A
        which: 65
        charCode: 65
      } ))

      scope.$digest()
      expect($input[0].value).toBe(defaultMask())




