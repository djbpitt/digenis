"use strict";
/*
 * Word-level annotations at bottom are controlled by js
 * Popup in-place annotations and fly-out menu overlay are pure css
 */
window.addEventListener('DOMContentLoaded', function () {
  const ws = document.getElementsByClassName('w');
  for (var i = 0, len = ws.length; i < len; i++) {
    ws[i].addEventListener('mouseover', grammar, false);
  }
},
false)
function grammar(event) {
  hide_grammars();
  document.getElementById('grammar-' + this.firstElementChild.innerText).style.display = 'block';
}
function hide_grammars() {
  Array. from (document.getElementsByClassName('grammar')).forEach((element) => {
    element.style.display = 'none';
  });
}