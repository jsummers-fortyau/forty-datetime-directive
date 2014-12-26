#class Fortydatetime
#  constructor: ->
#
#root = exports ? window
#root.Fortydatetime = Fortydatetime

angular.module('fortyDate')
  .directive "timeWithFormat", ($window, utils) ->
    # Formatter for birthdays and dates
    require: "ngModel"
    restrict: "A"
    link: (scope, elem, attrs, ngModel) ->

      moment = $window.moment

      # date_regex = /(\d{2})\/?(\d{2})\/?(\d{4})/g
      date_format = 'MM/DD/YYYY'
      maxDate = if attrs.maxDate then moment(attrs.maxDate.replace(/"/g, '')) else moment().add(1, 'year')
      minDate = if attrs.minDate then moment(attrs.minDate.replace(/"/g, '')) else moment().subtract(150, 'year')

      validDateFormat = (date_obj, date)->
        if maxDate.toDate() > date_obj && minDate.toDate() < date_obj
          return date.format(date_format)
        else
          if date_obj > maxDate.toDate()
            elem.val(maxDate.format(date_format)) if moment(elem.val(), date_format, true).isValid()
            return maxDate.format(date_format)
          if date_obj < minDate.toDate()
            elem.val(minDate.format(date_format)) if moment(elem.val(), date_format, true).isValid()
            return minDate.format(date_format)

      maxValue = (val, max)->
        if parseInt(val) > max
          return max
        else
          return val


      ngModel.$formatters.push (val)->
        return val if val is undefined || val==''

        date = moment(val)
        date_obj = date.toDate()
        return validDateFormat(date_obj, date)


      # Update the
      ngModel.$parsers.push (val)->
        return val if val is undefined || val==''

        mask = '__/__/____'
        date_pieces = []              # Empty array
        transformed_input = val

        # Find if there are slashes and iterate and update appropriately
        # The foreach below will loop through the first 2 values (day and time)
        # and determine if they are single days/months and format appropriately
        # This allows us to have single digit dates delimited by the '/'
        if (transformed_input.match(/\//g) || []).length <= 2 && transformed_input.substr(transformed_input.length - 1) == '/'
          date_pieces = transformed_input.split '/'
          _.forEach date_pieces, (v, i)->
            if v.length == 1 && (i == 0 || i == 1)
              date_pieces[i] = '0' + date_pieces[i]
            return
          transformed_input = date_pieces.join '/'

        stripped_input = transformed_input.replace(/\D/g, '').slice(0,8)

        date_pieces = []              # Reset array
        # Some simple validation as we type, basically just making sure
        # that the month and day are in range
        # Year/the entire date will be validated once we hit the final value
        if stripped_input.length >= 1
          date_pieces.push maxValue(stripped_input.slice(0,2), 12)
        if stripped_input.length >= 3
          date_pieces.push maxValue(stripped_input.slice(2,4), 31)
        if stripped_input.length >= 4
          date_pieces.push stripped_input.slice(4,8)

        transformed_input = _.compact(date_pieces).join '/'

        date = moment(transformed_input)
        date_obj = date.toDate()

        # If the value is different then we will update
        # i.e., 02/29/2013 === 03/01/2013
        if transformed_input.length is 10
          transformed_input = validDateFormat(date_obj, date)

        # TODO Update the mask
        # transformed_input = transformed_input + mask.substr(transformed_input.length)

        unless transformed_input is val
          ngModel.$setViewValue transformed_input
          ngModel.$render()

        return validDateFormat(date_obj, date)
