var labelType, useGradients, nativeTextSupport, animate;

(function() {
  var ua = navigator.userAgent,
      iStuff = ua.match(/iPhone/i) || ua.match(/iPad/i),
      typeOfCanvas = typeof HTMLCanvasElement,
      nativeCanvasSupport = (typeOfCanvas == 'object' || typeOfCanvas == 'function'),
      textSupport = nativeCanvasSupport
        && (typeof document.createElement('canvas').getContext('2d').fillText == 'function');
  labelType = (!nativeCanvasSupport || (textSupport && !iStuff))? 'Native' : 'HTML';
  nativeTextSupport = labelType == 'Native';
  useGradients = nativeCanvasSupport;
  animate = !(iStuff || !nativeCanvasSupport);
})();

var Log = {
  elem: false,
  write: function(text){
    if (!this.elem)
      this.elem = document.getElementById('log');
    this.elem.innerHTML = text;
    this.elem.style.left = (500 - this.elem.offsetWidth / 2) + 'px';
  }
};


function init(){
    $.ajax({
      url: 'elements.json',
      success: function(data) {
        fillGraph(data);
      }
    });
}

function fillGraph(data) {
  var infovis = document.getElementById('infovis');
  var w = infovis.offsetWidth - 50, h = infovis.offsetHeight - 50;

  var ht = new $jit.Hypertree({
    injectInto: 'infovis',
    width: w,
    height: h,
    Node: {
      dim: 9,
      color: "#f00"
    },
    Edge: {
      lineWidth: 2,
      color: "#088"
    },
    onBeforeCompute: function(node){
      Log.write("centering");
    },
    onCreateLabel: function(domElement, node){
      domElement.innerHTML = node.name;
      $jit.util.addEvent(domElement, 'click', function () {
        ht.onClick(node.id, {
          onComplete: function() {
            ht.controller.onComplete();
          }
        });
      });
    },
    onPlaceLabel: function(domElement, node){
      var style = domElement.style;
      style.display = '';
      style.cursor = 'pointer';
      if (node._depth <= 1) {
        style.fontSize = "0.8em";
        style.color = "#ddd";

      } else if(node._depth == 2){
        style.fontSize = "0.7em";
        style.color = "#555";

      } else {
        style.display = 'none';
      }

      var left = parseInt(style.left);
      var w = domElement.offsetWidth;
      style.left = (left - w / 2) + 'px';
    },

    onComplete: function(){
      Log.write("done");

      var node = ht.graph.getClosestNodeToOrigin("current");
      var html = "<h4>" + node.name + "</h4><b>Connections:</b>";
      html += "<ul>";
      node.eachSubnode(function(child){
        if (child.data) {
          var rel = (child.data.band == node.name) ? child.data.relation : node.data.relation;
          html += "<li>" + child.name + "</li>";
        }
      });
      html += "</ul>";
      $jit.id('inner-details').innerHTML = html;
    }
  });
  ht.loadJSON(data);
  ht.refresh();
  ht.controller.onComplete();
}

$(document).ready(function() {
  init();
});
