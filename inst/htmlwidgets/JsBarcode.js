HTMLWidgets.widget({

  name: 'JsBarcode',

  type: 'output',

  factory: function(el, width, height) {

    return {

      renderValue: function(x) {
        el.innerHTML = '';

        var svg = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
        svg.style.maxWidth = '100%';
        svg.style.height = 'auto';
        el.appendChild(svg);

        try {
          JsBarcode(svg, x.value, x.options);
        } catch (e) {
          el.innerHTML = '';
          var msg = document.createElement('div');
          msg.className = 'jsbarcode-error';
          msg.style.color = '#b00020';
          msg.style.fontFamily = 'monospace';
          // The library's own message names minified classes, so build ours.
          msg.textContent = 'JsBarcode: "' + x.value + '" is not a valid ' +
            x.options.format + ' value';
          if (window.console) console.warn('JsBarcode:', e);
          el.appendChild(msg);
        }
      },

      resize: function(width, height) {
        // The SVG scales down via max-width; nothing to recompute.
      }
    };
  }
});
