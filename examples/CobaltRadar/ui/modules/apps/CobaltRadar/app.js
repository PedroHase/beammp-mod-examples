angular.module('beamng.apps')
.directive('cobaltRadar', ['CanvasShortcuts', function (CanvasShortcuts) {
	return {
		template: '<canvas></canvas>',
		replace: true,
		restrict: 'EA',
		link: function (scope, element, attrs) {
		var streamsList = ['CobaltRadar'];
		StreamsManager.add(streamsList);
	scope.$on('$destroy', function () {
		StreamsManager.remove(streamsList);
	});
	var c = element[0], ctx = c.getContext('2d')
	scope.$on('streamsUpdate', function (event, streams) {
		var w = c.width/2
		var h = c.height/2


		//ORIENTATE VIEW
		var CobaltRadar = streams.CobaltRadar
		element[0].style.transform = "rotate(" + CobaltRadar.myRot * -1 +"rad)"; //COMMENT OUT FOR ORIENTATION DEBUG

		ctx.setTransform(1, 0, 0, 1, 0, 0);
		ctx.clearRect(0, 0, c.width, c.height);

		//DEBUG GUIDE LINES
		//ctx.setTransform(1, 0, 0, 1, w, h);
		//ctx.lineWidth = 1;
		//ctx.moveTo(-w,0);
		//ctx.lineTo(w,0);
		//ctx.moveTo(0,-h);
		//ctx.lineTo(0,h);
		//ctx.stroke();


		//OTHER CARS ON RADAR
		Object.values(CobaltRadar.cars).map(function(value,index,array){
			//Canvas Prep
			ctx.setTransform(1, 0, 0, 1, w-value.y, h-value.x);
			ctx.rotate(CobaltRadar.myRot)
			//ctx.translate(value.left, value.back);
			//ctx.translate(CobaltRadar.w - CobaltRadar.left,CobaltRadar.h - CobaltRadar.back);//MOVES RELATIVE TO STATIC ELEMENTS
			//ctx.translate(CobaltRadar.l + CobaltRadar.left , -CobaltRadar.l + CobaltRadar.w);//MOVES RELATIVE TO STATIC ELEMENTS
			//ctx.translate(-CobaltRadar.back,CobaltRadar.left);
			//ctx.translate(RIGHT,BACK)
			ctx.translate(-CobaltRadar.left,CobaltRadar.back);//CORRECT WAY?
			//ctx.translate(CobaltRadar.w * CobaltRadar.left, CobaltRadar.l + CobaltRadar.back);//OLD
			//ctx.translate(-CobaltRadar.l + CobaltRadar.back, CobaltRadar.w - CobaltRadar.left);//REVERSED?
			ctx.rotate(value.rot - CobaltRadar.myRot);
			
			ctx.fillStyle = 'rgba(255,255,255,'+ value.opacity +')';
			ctx.strokeStyle = 'rgba(0,0,0,' + CobaltRadar.opacity + ')';
			ctx.lineWidth = 2
			ctx.beginPath();
			//ctx.translate(50,50);
			//ctx.translate(CobaltRadar.left , CobaltRadar.back);
			//ctx.translate(CobaltRadar.left , 0);
			ctx.rect(-value.w/2 + value.left, -value.l/2 - value.back, value.w, value.l);
			//ctx.rect(value.left - value.w,value.back - value.l, -value.w, value.l);
			//ctx.rect(value.w - value.left,value.back - value.l, -value.w, -value.l);
			//ctx.rect(value.w - value.left,0, -value.w, -value.l);
			//ctx.rect(value.w/2 - value.back, value.l/2 - value.left, value.w, value.l);
			//ctx.stroke();
			//ctx.lineWidth = 2
			//ctx.strokeStyle = 'rgba(' + value.color[1]*255 + ',' + value.color[2]*255 + ',' + value.color[3]*255 + ',' + value.opacity + ')';
			ctx.stroke();
			ctx.fill()
			ctx.strokeStyle = 'rgba(' + (value.color[0]*255) + ',' + (value.color[1]*255) + ',' + (value.color[2]*255) + ',' + value.opacity + ')';
			//ctx.lineCap = 'round';
			ctx.lineWidth = 5
			ctx.beginPath();
			ctx.moveTo(value.left,-value.w/2 - value.back);
			ctx.lineTo(value.left,value.w/2 - value.back);
			ctx.stroke();

		});

		//MY CAR AND STATIC ELEMENTS
		//Prepare line for static parts of the UI (bits that don't move, my car and the guides)
		ctx.beginPath();
		ctx.strokeStyle = 'rgba(0,0,0,' + CobaltRadar.opacity + ')';

		ctx.setTransform(1, 0, 0, 1, w, h);
		ctx.rotate(CobaltRadar.myRot)
		//ctx.translate(-CobaltRadar.left , CobaltRadar.back);
		//ctx.translate(CobaltRadar.left, -CobaltRadar.back);
		
		//guide-lines
		ctx.lineWidth = 1;
		ctx.moveTo(-w,0);
		ctx.lineTo(w,0);
		ctx.moveTo(0,-h);
		ctx.lineTo(0,h);
		ctx.stroke();

		//Draw my car
		ctx.fillStyle = 'rgba(0,255,0,' + CobaltRadar.opacity + ')';
		ctx.beginPath();
		ctx.strokeStyle = 'rgba(0,0,0,' + CobaltRadar.opacity + ')';
		ctx.lineWidth = 2
		ctx.rect(-CobaltRadar.w/2, -CobaltRadar.l/2, CobaltRadar.w, CobaltRadar.l);
		//ctx.rect(0, 0, -CobaltRadar.w, -CobaltRadar.l);
		//ctx.rect(0,0, CobaltRadar.w, CobaltRadar.l);
		//ctx.rect(-CobaltRadar.w, -CobaltRadar.l, CobaltRadar.w, CobaltRadar.l);

		//ctx.arc(0, 0, 20, 0, Math.PI * 2);
		ctx.stroke();
		ctx.fill();

		//ctx.beginPath();
		//ctx.moveTo(w + CobaltRadar.p1[0], h - CobaltRadar.p1[1]);
		//ctx.lineTo(w + CobaltRadar.p2[0], h - CobaltRadar.p2[1]);
		//ctx.lineTo(w + CobaltRadar.p3[0], h - CobaltRadar.p3[1]);
		//ctx.lineTo(w + CobaltRadar.p4[0], h - CobaltRadar.p4[1]);
		//ctx.closePath();
		//ctx.fill();

	});
	
	scope.$on('VehicleChange', function (event, data) {
	});

	scope.$on('app:resized', function (event, data) {
		c.width = data.width;
		c.height = data.height;
	});
	}
  };
}]);