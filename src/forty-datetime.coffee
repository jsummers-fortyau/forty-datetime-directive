angular.module('fortyDate', [])
.directive("fortyDatePicker", ($filter, $window)->
  {
  require: "ngModel"
  restrict: "E"
  replace: true
  scope:
    date:'=ngModel'
    disabled: '='
  template: '<div class="input-group"><input type="text" class="form-control" datepicker-popup="{{format}}" ng-model="date" is-open="opened" ng-disabled="disabled" /><span class="input-group-btn"><button type="button" ng-disabled="disabled" class="btn btn-default" ng-click="open($event)"><i class="glyphicon glyphicon-calendar"></i></button></span></div>'
  link: (scope, elem, attrs, ngModel)->
    allowed_key_codes = [96,97,98,99,100,101,102,103,104,105]
    scope.opened = false
    scope.format = 'MM/dd/yyyy'
    delimiter = '/'
    mask = scope.format.toLowerCase().replace(/\w/g, '_')
    ngModelCtrl = angular.element(elem.find('input')).data('$ngModelController')

    ###*
      * Initialize the
      *
      * @return {Boolean} true if success
      ###
    init = ()->
      if !_.isDate scope.date
        ngModelCtrl.$setViewValue(mask)
      return true


    ###*
      * Set the caret position in the text input. This method is X-browser using createTextRange or the more lovable
      * selectionStart
      *
      * @param {Element} the input element to manipulate the cursor
      * @param {Integer} the position in the element to place the cursor
      ###
    setCaretPosition = (el, caretPos) ->
      return unless el

      el.value = el.value                   # Fix for some older Chrome browsers!!
      if el.createTextRange
        range = el.createTextRange()
        range.move 'character', caretPos
        range.select()
        return true
      else
        if el.selectionStart or el.selectionStart == 0
          el.focus()
          el.setSelectionRange caretPos, caretPos
          return true
        else
          el.focus()
          return false
      return

    applyMaskToArray = (arr)->
      cnt = 0
      mask_arr = _.map scope.format.split(''), (c)->
        if c is delimiter
          return delimiter
        ret = arr[cnt]
        if arr[cnt] is undefined
          ret = '_'
        cnt++
        return ret
      return mask_arr


    getDelimiterCountAtIndex = (index=undefined)->
      return 0 unless index
      elem.find('input')[0].value.substr(0,index).replace(/\w/g, '').length


    deleteInMask = (el, direction=0)->
      # backspace key at beginning of field
      return if el.selectionStart is 0 and
        direction is 0 and
        el.selectionStart == el.selectionEnd
      # delete key at end of field
      return if el.selectionStart is scope.format.length && direction is 1

      char_array = el.value.split('')
      char_raw = el.value.replace(/\W/g, '').split('')

      pos = el.selectionStart
      if el.selectionEnd is el.selectionStart
        pos = pos - 1
      console.log el.selectionStart
      delimiter_cnt = getDelimiterCountAtIndex(pos+direction)
      delimiter_cnt_start = getDelimiterCountAtIndex(el.selectionStart)
      delimiter_cnt_end = getDelimiterCountAtIndex(el.selectionEnd)

      char_count = ((el.selectionEnd - delimiter_cnt_end) - (el.selectionStart - delimiter_cnt_start))
      char_count = if char_count is 0 then 1 else char_count
      char_raw.splice(pos-delimiter_cnt+direction,char_count)

      ngModelCtrl.$setViewValue(applyMaskToArray(char_raw).join(''))
      ngModelCtrl.$render()

      caret_pos = pos+direction
      setCaretPosition(elem.find('input')[0],caret_pos)
      return


    updateMask = (el, char)->
      char_array = el.value.split('')
      pos = el.selectionStart
      delimiter_cnt = el.value.substr(0,pos).replace(/\w/g, '').length
      char_raw = el.value.replace(/\W/g, '').split('')

      insert_pos = pos-delimiter_cnt
      if char_raw.indexOf('_') < insert_pos
        insert_pos = char_raw.indexOf('_')

      # If we want to completely replace we pass null
      unless char is null
        char_raw.splice(insert_pos, 0, char)

      new_value = applyMaskToArray(char_raw).join('')

      ngModelCtrl.$setViewValue(new_value)
      ngModelCtrl.$render()

      caret_pos = if char_array[insert_pos+1] is delimiter then 2 else 1
      caret_pos = caret_pos + delimiter_cnt
      setCaretPosition(elem.find('input')[0],insert_pos+caret_pos)

      return new_value
    elem.find('input').on 'paste', (event)->
      event.preventDefault()
      this.value = event.clipboardData.getData("text/plain")
      updateMask this, null

    elem.find('input').on 'keydown', (event)->
      key = event.keyCode || event.which
      if key is 8 || key is 46
        deleteInMask(this, if key is 8 then 0 else 1)
        event.preventDefault()
        return false


    elem.find('input').on 'keypress', (event)->
      key = event.keyCode || event.which
      return if key is 9

      event.preventDefault()

      if this.value.replace(/\_/g, '').length is scope.format.length
        return false

      if isNaN(parseInt(String.fromCharCode(key)))
        return false

      el = elem.find('input')[0]
      if el.value is mask
        setCaretPosition(el,0)

      updateMask el,String.fromCharCode(event.keyCode)
      return

    elem.find('input').on 'blur', ()->
      return if ngModelCtrl.$viewValue is mask
      if $filter('date')(scope.date, scope.format) is undefined
        elem.addClass('has-error')
      else
        elem.removeClass('has-error')


    scope.open = ($event)->
      $event.preventDefault();
      $event.stopPropagation();
      scope.opened = !scope.opened;

    ngModelCtrl.$parsers.unshift (data)->
      #View -> Model
      return data

    ngModelCtrl.$formatters.unshift (data)->
      #Model -> View
      console.log ngModelCtrl

      #if scope.date is null
      #ngModelCtrl.$setViewValue(mask)
      #console.log ngModelCtrl
      #ngModelCtrl.$setViewValue($filter('date')(data, scope.format))
      return data

    init()
  }
)

