window.addEventListener('DOMContentLoaded', init, false);

function init() {
    // radio buttons toggle language
    var radios = document.getElementById('radios');
    radios.addEventListener('change', ajax, false);
    // checkboxes toggle column visibility
    var checkboxes = document.querySelectorAll('#checkboxes input');
    for (var i = 0, length = checkboxes.length; i < length; i++) {
        checkboxes[i].addEventListener('click', columnToggle, false);
    }
    // configuration menu responds to mouseover
    var control = document.getElementById('controls');
    control.addEventListener('mouseover', controlToggle, true);
    control.addEventListener('mouseout', controlToggle, true);
    onAjax();
}
function onAjax() {
    // divs scroll other columns on click and highlight hits
    var divs = document.querySelectorAll('#texts > section > div > div');
    for (var i = 0, length = divs.length; i < length; i++) {
        divs[i].addEventListener('click', scrollTo, false);
    }
    // sigla in plectogram are also clickable
    var sigla = document.getElementsByTagName('text');
    for (var i = 0, length = sigla.length; i < length; i++) {
        sigla[i].addEventListener('click', scrollTo, false);
    }
}

function controlToggle() {
    // Show/hide for configuration menu
    var controls = document.querySelector('#controls > div');
    if (controls.style.display !== 'block') {
        controls.style.display = 'block';
    } else {
        controls.style.display = 'none';
    }
}

function columnToggle() {
    // Show/hide for columns and plectogram rows
    // this.checked will have the value after clicking
    var target = this.id.slice(3);
    var columns = document.querySelectorAll('#texts > section');
    if (this.checked == true) {
        document.getElementById(target).classList.remove('hide');
        document.getElementById('svg_' + target).classList.remove('hide');
        document.getElementById('svg_' + target + '_lines').classList.remove('hide');
    } else {
        document.getElementById(target).classList.add('hide');
        document.getElementById('svg_' + target).classList.add('hide');
        document.getElementById('svg_' + target + '_lines').classList.add('hide');
    }
    // adjust size and window for plectogram to fit visibility
    var xvii_state = document.getElementById('svg_xvii').classList.contains('hide');
    var core_state = document.getElementById('svg_core').classList.contains('hide');
    if (xvii_state & core_state) {
        // both hidden
        document.getElementsByTagName('svg')[0].setAttribute('height', '30px');
        document.getElementsByTagName('svg')[0].firstElementChild.setAttribute('transform', 'translate(0,-110)');
        for (var i = 0, length = columns.length; i < length; i++) {
            columns[i].classList.remove('medium', 'short');
            columns[i].classList.add('tall');
        }
    } else if (xvii_state) {
        // xvii hidden; core visible
        document.getElementsByTagName('svg')[0].setAttribute('height', '130px');
        document.getElementsByTagName('svg')[0].firstElementChild.setAttribute('transform', 'translate(0,-110)');
        for (var i = 0, length = columns.length; i < length; i++) {
            columns[i].classList.remove('tall', 'short');
            columns[i].classList.add('medium');
        }
    } else if (core_state) {
        // core hidden; xvii visible
        document.getElementsByTagName('svg')[0].setAttribute('height', '130px');
        document.getElementsByTagName('svg')[0].firstElementChild.setAttribute('transform', 'translate(0,-10)');
        for (var i = 0, length = columns.length; i < length; i++) {
            columns[i].classList.remove('tall', 'short');
            columns[i].classList.add('medium');
        }
    } else {
        // both visible
        document.getElementsByTagName('svg')[0].setAttribute('height', '230px');
        document.getElementsByTagName('svg')[0].firstElementChild.setAttribute('transform', 'translate(0,-10)');
        for (var i = 0, length = columns.length; i < length; i++) {
            columns[i].classList.remove('tall', 'medium');
            columns[i].classList.add('short');
        }
    }
}

function scrollTo() {
    // Scroll columns (except the one clicked) and highlight hits
    var idParts = this.id.split('_');
    var hitColumnId = idParts[0];
    var idTarget = idParts[1];
    
    // First remove highlighting of previously selected textual units ...
    var anchors = document.querySelectorAll('#texts > section > div > div');
    for (var i = 0, length = anchors.length; i < length; i++) {
        anchors[i].classList.remove('selected');
    }
    // ... and remove all highlighting in the plectogram
    var plectogram_components =[ 'text', 'line', 'circle'];
    for (var i = 0, length = plectogram_components.length; i < length; i++) {
        component_items = document.getElementsByTagName(plectogram_components[i]);
        for (var j = 0, component_length = component_items.length; j < component_length; j++) {
            component_items[j].setAttribute('fill', 'black');
            component_items[j].setAttribute('stroke', 'black');
            component_items[j].setAttribute('opacity', '.3');
        }
    }
    
    // Scroll each column and highlight the hits
    var columns = document.querySelectorAll('#texts > section');
    for (var i = 0, length = columns.length; i < length; i++) {
        currentColumnId = columns[i].id;
        // ... but don't scroll the one that was clicked
        if (currentColumnId !== hitColumnId) {
            // bis doesn't exist in the core, so remove it before matching for scrolling
            // where bis is possible, though, make the distinction for scrolling, but not highlighting
            if (currentColumnId == 'core') {
                idTarget = idTarget.replace(/bis.*/, '');
            }
            // remove any fragment identifier and add a new one to scroll each column
            window.location.replace(window.location.href.replace(/#.*/, '') + '#' + currentColumnId + '_' + idTarget);
        }
        // Highlight newly selected units, both adding and removing 'bis'
        // Must check for existence first to avoid fatal error
        if (document.getElementById(currentColumnId + '_' + idTarget) !== null) {
            document.getElementById(currentColumnId + '_' + idTarget).classList.add('selected');
        }
        if (document.getElementById(currentColumnId + '_' + idTarget + 'bis') !== null) {
            document.getElementById(currentColumnId + '_' + idTarget + 'bis').classList.add('selected');
        }
    }
    // highlight matching sigla with and without bis
    var sigla = document.getElementsByClassName(idTarget);
    for (var i = 0, length = sigla.length; i < length; i++) {
        sigla[i].setAttribute('fill', '#A00000')
        sigla[i].setAttribute('stroke', '#A00000')
        sigla[i].setAttribute('opacity', '1')
    }
    var siglabis = document.getElementsByClassName(idTarget + 'bis');
    for (var i = 0, length = siglabis.length; i < length; i++) {
        siglabis[i].setAttribute('fill', '#A00000')
        siglabis[i].setAttribute('stroke', '#A00000')
        siglabis[i].setAttribute('opacity', '1')
    }
}

function ajax() {
    // http://stackoverflow.com/questions/15839169/how-to-get-value-of-selected-radio-button
    var selected = document.querySelector('input[name="lg"]:checked').value;
    switch (selected) {
        case 'sl':
        suffix = '_slavic';
        break;
        default:
        suffix = '';
        break;
    }
    var columns =[ 'xvii', 'xiv'];
    var requests =[];
    var displayLocations =[];
    var urls =[];
    for (var i = 0, length = columns.length; i < length; i++) {
        if (selected == 'sl') {
            document.getElementById(columns[i]).classList.add('sl');
        } else {
            document.getElementById(columns[i]).classList.remove('sl');
        }
        displayLocations[i] = document.querySelector('#' + columns[i] + ' > div');
        urls[i] = columns[i] + suffix + '.inc';
        requests[i] = new XMLHttpRequest();
        requests[i].open('GET', urls[i], true);
        requests[i].send(null);
    }
    onRequestsComplete(requests, function (requests, unsuccessful) {
        if (unsuccessful) {
            return;
        }
        for (var i = 0, length = requests.length; i < length; i++) {
            displayLocations[i].innerHTML = requests[i].responseText;
        }
        onAjax();
    })
}

/*

Multiple request object code from:
http://stackoverflow.com/questions/34570205/without-jquery-how-can-javascript-check-that-multiple-ajax-calls-have-been-comp

Call with
onRequestsComplete([xmlhttp, xmlhttp2], function(requests, unsuccessful) {
if (unsuccessful) { return; } // Abort if some requests failed

document.getElementById("login_panel").innerHTML=requests[1].responseText;
document.getElementById("login_panel_settings").innerHTML=requests[0].responseText;
});
 */
function requestsAreComplete(requests) {
    return requests.every(function (request) {
        return request.readyState == 4;
    });
}

function unsuccessfulRequests(requests) {
    var unsuccessful = requests.filter(function (request) {
        return request.status != 200;
    });
    return unsuccessful.length ? unsuccessful: null;
}

function onRequestsComplete(requests, callback) {
    // Wrap callback into a function that checks for all requests completion
    function sharedCallback() {
        if (requestsAreComplete(requests)) {
            callback(requests, unsuccessfulRequests(requests));
        }
    }
    
    // Assign the shared callback to each request's `onreadystatechange`
    requests.forEach(function (request) {
        request.onreadystatechange = sharedCallback;
    });
}