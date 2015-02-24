
ele = undefined
scope = undefined
compile = undefined
rootScope = undefined

describe 'forty-date-picker:', ->

  beforeEach module('fortyDate')

  beforeEach inject((
      $rootScope
      $compile
    ) ->


    compile = $compile
    rootScope = $rootScope.$new()

    ele = '<></>'

  )

  it 'should do expect something!', ->
    expect(true).toBe(true)

#  describe 'acceptable attributes and defaults', ->
#    it 'should have an option for formatting date in the viewValue', ->
#    it 'should have '
