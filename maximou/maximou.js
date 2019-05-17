window.addEventListener('DOMContentLoaded', init, false);
function init() {
    // configuration menu responds to mouseover
    const control = document.getElementById('controls');
    control.addEventListener('mouseover', controlToggle, true);
    control.addEventListener('mouseout', controlToggle, true);
    // radio buttons toggle texts and plectogram
    const radios = document.getElementById('radios');
    radios.addEventListener('change', plectogramToggle, false);
    // plectogram text elements respond to click
    const texts = document.querySelectorAll('g > text');
    let i = 0;
    const length = texts.length;
    for (; i < length; i++) {
        texts[i].addEventListener('click', itemToggle, false);
    }
}
function controlToggle() {
    // Show/hide for configuration menu
    const controls = document.querySelector('#controls > div');
    if (controls.style.display !== 'block') {
        controls.style.display = 'block';
    } else {
        controls.style.display = 'none';
    }
}
function plectogramToggle() {
    // Swap ae ~ gc plectogram and texts; value will be "ae" (Slavic) or "gc" (Greek)
    // First plectograms
    const radio = document.querySelector('input[name="plect_choice"]:checked').value;
    const plectograms = document.querySelectorAll('#plectogram > div');
    for (let i = 0, length = plectograms.length; i < length; i++) {
        plectograms[i].style.display = 'none';
    }
    document.getElementById(radio).style.display = 'block';
    // Then texts
    const slavic_texts = document.getElementsByClassName('slavic');
    // ae
    const greek_texts = document.getElementsByClassName('greek');
    // gc
    if (radio === 'ae') {
        // show Slavic (a, e) and hide Greek (c, g)
        for (let i = 0, length = greek_texts.length; i < length; i++) {
            greek_texts[i].style.display = 'none';
        }
        for (let i = 0, length = slavic_texts.length; i < length; i++) {
            slavic_texts[i].style.display = 'block';
        }
    } else {
        // show Greek (c, g) and hide Slavic (a, e)
        for (let i = 0, length = slavic_texts.length; i < length; i++) {
            slavic_texts[i].style.display = 'none';
        }
        for (let i = 0, length = greek_texts.length; i < length; i++) {
            greek_texts[i].style.display = 'block';
        }
    }
}
function itemToggle() {
    // grey out all text and line elements in plectogram
    const texts = document.querySelectorAll('g > text[id]');
    for (let i = 0, length = texts.length; i < length; i++) {
        texts[i].setAttribute('opacity', '.3');
        texts[i].setAttribute('fill', 'black');
        texts[i].setAttribute('stroke', 'black');
    }
    const lines = document.querySelectorAll('g > line');
    for (let i = 0, length = lines.length; i < length; i++) {
        lines[i].setAttribute('opacity', '.3');
        lines[i].setAttribute('fill', 'black');
        lines[i].setAttribute('stroke', 'black');
    }
    // highlight inside plectogram
    const activePlectogram = this.closest('div[id]');
    console.log('Clicked on a node in ' + activePlectogram.id);
    const classes = this.getAttribute('class').split(' ');
    for (let i = 0, length = classes.length; i < length; i++) {
        const highlights = activePlectogram.getElementsByClassName(classes[i]);
        for (let j = 0, length = highlights.length; j < length; j++) {
            highlights[j].setAttribute('opacity', '1');
            highlights[j].setAttribute('fill', '#A00000');
            highlights[j].setAttribute('stroke', '#A00000');
        }
    }
    // highlight inside texts
    console.log(this.id);
    console.log(this.getAttribute('class'));
}


/*function process_harmony() {
// https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest/responseXML
// Load harmony.xml to assign event listeners and behaviors
var xhr = new XMLHttpRequest();
xhr.open('GET', '../harmony.xml', true);

// If specified, responseType must be empty string or "document"
xhr.responseType = 'document';

// overrideMimeType() can be used to force the response to be parsed as XML
xhr.overrideMimeType('text/xml');

xhr.onload = function () {
if (xhr.readyState === xhr.DONE) {
if (xhr.status === 200) {
// console.log(xhr.responseXML);
}
}
};

xhr.send(null);
}*/