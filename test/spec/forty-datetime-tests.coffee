
ele = undefined
markup = undefined
scope = undefined
iScope = undefined
compile = undefined
rootScope = undefined

describe 'forty-date-picker: ', ->

  beforeEach module('fortyDate')

  beforeEach inject((
      $rootScope
      $compile
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

  describe 'acceptable attributes and defaults', ->
    it 'should have an option for formatting date in the viewValue', ->
    it 'should have ', ->

  describe 'its ability to set a caret position', ->
    it 'should require an el', ->




