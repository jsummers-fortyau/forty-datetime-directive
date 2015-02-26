(function() {
  angular.module('fortyDate', []).directive("fortyDatePicker", function($filter, $window) {
    return {
      require: "ngModel",
      restrict: "E",
      replace: true,
      scope: {
        date: '=ngModel',
        disabled: '='
      },
      template: '<div class="input-group"><input type="text" class="form-control" datepicker-popup="{{format}}" ng-model="date" is-open="opened" ng-disabled="disabled" /><span class="input-group-btn"><button type="button" ng-disabled="disabled" class="btn btn-default" ng-click="open($event)"><i class="glyphicon glyphicon-calendar"></i></button></span></div>',
      link: function(scope, elem, attrs, ngModel) {
        var allowed_key_codes, applyMaskToArray, deleteInMask, delimiter, getDelimiterCountAtIndex, init, mask, ngModelCtrl, setCaretPosition, updateMask;
        allowed_key_codes = void 0;
        delimiter = void 0;
        mask = void 0;
        ngModelCtrl = void 0;

        /**
          * Initialize the
          *
          * @return {Boolean} true if success
         */
        init = function() {
          allowed_key_codes = [96, 97, 98, 99, 100, 101, 102, 103, 104, 105];
          delimiter = '/';
          mask = scope.format.toLowerCase().replace(/\w/g, '_');
          ngModelCtrl = angular.element(elem.find('input')).data('$ngModelController');
          if (!_.isDate(scope.date)) {
            ngModelCtrl.$setViewValue(mask);
          }
          return true;
        };

        /**
          * Set the caret position in the text input. This method is X-browser using createTextRange or the more lovable
          * selectionStart
          *
          * @param {Element} the input element to manipulate the cursor
          * @param {Integer} the position in the element to place the cursor
         */
        setCaretPosition = function(el, caretPos) {
          var range;
          if (!el) {
            return;
          }
          el.value = el.value;
          if (el.createTextRange) {
            range = el.createTextRange();
            range.move('character', caretPos);
            range.select();
            return true;
          } else {
            if (el.selectionStart || el.selectionStart === 0) {
              el.focus();
              el.setSelectionRange(caretPos, caretPos);
              return true;
            } else {
              el.focus();
              return false;
            }
          }
        };
        applyMaskToArray = function(arr) {
          var cnt, mask_arr;
          cnt = 0;
          mask_arr = _.map(scope.format.split(''), function(c) {
            var ret;
            if (c === delimiter) {
              return delimiter;
            }
            ret = arr[cnt];
            if (arr[cnt] === void 0) {
              ret = '_';
            }
            cnt++;
            return ret;
          });
          return mask_arr;
        };
        getDelimiterCountAtIndex = function(index) {
          if (index == null) {
            index = void 0;
          }
          if (!index) {
            return 0;
          }
          return elem.find('input')[0].value.substr(0, index).replace(/\w/g, '').length;
        };

        /**
          * Handle deleting a value while retaining the mask
          *
          * @param {Element}
          * @param {Number} int representing which 'way' to delete the string
          * @return {Undefined}
         */
        deleteInMask = function(el, direction) {
          var caret_pos, char_count, char_raw, delimiter_cnt, delimiter_cnt_end, delimiter_cnt_start, pos;
          if (direction == null) {
            direction = 0;
          }
          if (el.selectionStart === 0 && direction === 0 && el.selectionStart === el.selectionEnd) {
            return;
          }
          if (el.selectionStart === scope.format.length && direction === 1) {
            return;
          }
          char_raw = el.value.replace(/\W/g, '').split('');
          pos = el.selectionStart;
          if (el.selectionEnd === el.selectionStart) {
            pos = pos - 1;
          }
          delimiter_cnt = getDelimiterCountAtIndex(pos + direction);
          delimiter_cnt_start = getDelimiterCountAtIndex(el.selectionStart);
          delimiter_cnt_end = getDelimiterCountAtIndex(el.selectionEnd);
          char_count = (el.selectionEnd - delimiter_cnt_end) - (el.selectionStart - delimiter_cnt_start);
          char_count = char_count === 0 ? 1 : char_count;
          char_raw.splice(pos - delimiter_cnt + direction, char_count);
          ngModelCtrl.$setViewValue(applyMaskToArray(char_raw).join(''));
          ngModelCtrl.$render();
          caret_pos = pos + direction;
          setCaretPosition(elem.find('input')[0], caret_pos);
        };

        /**
          * Update the string with the new value and reapply the mask to the input value
          *
          * @param {Element}
          * @param {String}
          * @return {String} a string of the new input value with the mask applied
         */
        updateMask = function(el, char) {
          var caret_pos, char_array, char_raw, delimiter_cnt, insert_pos, new_value, pos;
          char_array = el.value.split('');
          pos = el.selectionStart;
          delimiter_cnt = el.value.substr(0, pos).replace(/\w/g, '').length;
          char_raw = el.value.replace(/\W/g, '').split('');
          insert_pos = pos - delimiter_cnt;
          if (char_raw.indexOf('_') < insert_pos) {
            insert_pos = char_raw.indexOf('_');
          }
          if (char !== null) {
            char_raw.splice(insert_pos, 0, char);
          }
          new_value = applyMaskToArray(char_raw).join('');
          ngModelCtrl.$setViewValue(new_value);
          ngModelCtrl.$render();
          caret_pos = char_array[insert_pos + 1] === delimiter ? 2 : 1;
          caret_pos = caret_pos + delimiter_cnt;
          setCaretPosition(elem.find('input')[0], insert_pos + caret_pos);
          return new_value;
        };
        elem.find('input').on('paste', function(event) {
          event.preventDefault();
          this.value = event.clipboardData.getData("text/plain");
          return updateMask(this, null);
        });
        elem.find('input').on('keydown', function(event) {
          var key;
          key = event.keyCode || event.which;
          if (key === 8 || key === 46) {
            deleteInMask(this, key === 8 ? 0 : 1);
            event.preventDefault();
            return false;
          }
        });
        elem.find('input').on('keypress', function(event) {
          var el, key;
          key = event.keyCode || event.which;
          if (key === 9) {
            return;
          }
          event.preventDefault();
          if (this.value.replace(/\_/g, '').length === scope.format.length) {
            return false;
          }
          if (isNaN(parseInt(String.fromCharCode(key)))) {
            return false;
          }
          el = elem.find('input')[0];
          if (el.value === mask) {
            setCaretPosition(el, 0);
          }
          updateMask(el, String.fromCharCode(event.keyCode));
        });
        elem.find('input').on('blur', function() {
          if (ngModelCtrl.$viewValue === mask) {
            return;
          }
          if ($filter('date')(scope.date, scope.format) === void 0) {
            return elem.addClass('has-error');
          } else {
            return elem.removeClass('has-error');
          }
        });
        scope.opened = false;
        scope.format = 'MM/dd/yyyy';

        /**
          * Open the datepicker dropdown
          *
          * @param {Event} click event
          * @return {undefined}
         */
        scope.open = function($event) {
          $event.preventDefault();
          $event.stopPropagation();
          scope.opened = !scope.opened;
        };
        init();
        ngModelCtrl.$parsers.unshift(function(data) {
          return data;
        });
        return ngModelCtrl.$formatters.unshift(function(data) {
          console.log(ngModelCtrl);
          return data;
        });
      }
    };
  });

}).call(this);
