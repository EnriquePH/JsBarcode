HTMLWidgets.widget({

  name: 'JsBarcode',

  type: 'output',

  factory: function(el, width, height) {

    function showError(text) {
      el.innerHTML = '';
      var msg = document.createElement('div');
      msg.className = 'jsbarcode-error';
      msg.style.color = '#b00020';
      msg.style.fontFamily = 'monospace';
      msg.textContent = text;
      el.appendChild(msg);
    }

    return {

      renderValue: function(x) {
        el.innerHTML = '';

        var svg = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
        svg.style.maxWidth = '100%';
        svg.style.height = 'auto';
        el.appendChild(svg);

        // With a `valid` callback, JsBarcode reports invalid input through it
        // instead of throwing, so any exception below is a different failure.
        var isValid = true;
        var options = Object.assign({}, x.options, {
          valid: function(valid) { isValid = valid; }
        });

        try {
          JsBarcode(svg, x.value, options);
        } catch (e) {
          if (window.console) console.error('JsBarcode:', e);
          showError('JsBarcode error: ' + (e && e.message ? e.message : e));
          return;
        }

        if (!isValid) {
          // The library's own message names minified classes, so build ours.
          showError('JsBarcode: "' + x.value + '" is not a valid ' +
            x.options.format + ' value');
        }
      },

      resize: function(width, height) {
        // The SVG scales down via max-width; nothing to recompute.
      }
    };
  }
});
