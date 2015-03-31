
console.log('Happy happing ;)');

var LIFE = 10000;
var GRID_SIZE = 16;
var MIN_DISTANCE = 32;
var TOP_DISTANCE = 32;
var RADIUS = 24;
var SHAKE = 4;
var last_died = 0;
var alive_cnt = 0;
var max_alive_cnt = 0;

var canvas, ctx;
var width = window.innerWidth;
var height = window.innerHeight;

var happies = [];

function add_happie() {
	var x, y;
	while (true) {
		x = ~~(Math.random() * (width - 2 * MIN_DISTANCE) + MIN_DISTANCE);
		y = ~~(Math.random() * (height - 2 * MIN_DISTANCE - TOP_DISTANCE) +
		    MIN_DISTANCE + TOP_DISTANCE);
		var hit = false;
		for (var i = 0; i < happies.length; i++) {
			if (happies[i].life == 0) {
				continue;
			}
			var dx = happies[i].x - x;
			var dy = happies[i].y - y;
			if (dx * dx + dy * dy <= MIN_DISTANCE * MIN_DISTANCE * 4) {
				hit = true;
				break;
			}
		}
		if (!hit) {
			break;
		}
	}
	happies.push({
		x: x,
		y: y,
		life: Math.random() * LIFE / 2 + LIFE / 2
	});
}

function draw_background() {
	ctx.save();
	ctx.clearRect(0, 0, width, height);
	ctx.fillStyle = '#fff'
	ctx.fillRect(0, 0, width, height);
	ctx.beginPath();

	for (var x = 0; x < width; x += GRID_SIZE) {
		ctx.moveTo(x, 0);
		ctx.lineTo(x, height);
	}
	for (var y = 0; y < height; y += GRID_SIZE) {
		ctx.moveTo(0, y, 0);
		ctx.lineTo(width, y);
	}
	ctx.strokeStyle = '#7986CB';
	ctx.stroke();
	ctx.restore();
}

function draw_happie(happie) {
	ctx.save();
	ctx.beginPath();
	var dx = 0, dy = 0;
	if (happie.life < 3000 && happie.life > 0) {
		dx = (Math.random() - 0.5) * SHAKE * (1 - happie.life / 3000);
		dy = (Math.random() - 0.5) * SHAKE * (1 - happie.life / 3000);
	}
	ctx.translate(dx, dy);
	ctx.translate(happie.x, happie.y);
	if (happie.life > LIFE) {
		ctx.scale(1.1, 1.1);
	}
	ctx.arc(0, 0, RADIUS, 0, 2 * Math.PI, false);
	c = happie.life / LIFE;
	if (happie.life == 0) {
		ctx.fillStyle = 'rgba(0, 0, 0, 0.5)';
	} else {
		ctx.fillStyle = 'rgb(' + ~~(255*(1 - c)) + ', ' + ~~(255*c) + ', 0)';
	}
	ctx.fill();

	ctx.beginPath();
	if (happie.life == 0) {
		ctx.beginPath();
		var r = RADIUS/5;
		ctx.moveTo(-RADIUS/3 - r, -RADIUS/3 - r);
		ctx.lineTo(-RADIUS/3 + r, -RADIUS/3 + r);
		ctx.moveTo(-RADIUS/3 - r, -RADIUS/3 + r);
		ctx.lineTo(-RADIUS/3 + r, -RADIUS/3 - r);
		ctx.moveTo(+RADIUS/3 - r, -RADIUS/3 - r);
		ctx.lineTo(+RADIUS/3 + r, -RADIUS/3 + r);
		ctx.moveTo(+RADIUS/3 - r, -RADIUS/3 + r);
		ctx.lineTo(+RADIUS/3 + r, -RADIUS/3 - r);
		ctx.lineWidth = r;
		ctx.lineCap = 'round';
		ctx.strokeStyle = '#fff';
		ctx.stroke();
	} else {
		var r = RADIUS/4;
		ctx.arc(-RADIUS/3, -RADIUS/3, r, 0, 2 * Math.PI, false);
		ctx.arc(+RADIUS/3, -RADIUS/3, r, 0, 2 * Math.PI, false);
		ctx.fillStyle = '#fff';
		ctx.fill();
	}


	ctx.beginPath();
	if (happie.life == 0) {
		ctx.moveTo(-RADIUS/3, RADIUS/2 - RADIUS/10);
		ctx.lineTo(+RADIUS/3, RADIUS/2 + RADIUS/10);
	} else {
		ctx.moveTo(-RADIUS/3, RADIUS/2);
		ctx.quadraticCurveTo(
				0, RADIUS/2 + RADIUS / 2 * (happie.life / LIFE - 0.5),
				+RADIUS/3, RADIUS/2);
	}
	// var dead_dr = (happie.life == 0) ? 1.2 : 1;
	ctx.lineWidth = RADIUS/4;
	ctx.lineCap="round";
	ctx.strokeStyle = '#fff';
	ctx.stroke();
	ctx.restore();
}

function draw_alive_count() {
	ctx.save();
	ctx.lineWidth = 4;
	ctx.lineCap="round";
	ctx.beginPath();
	for (var i = 0; i < alive_cnt; i++) {
		if ((i + 1) % 5 != 0) {
			ctx.moveTo(24 + i * 8 + 4, 8);
			ctx.lineTo(24 + i * 8 - 4, 40);
		} else {
			ctx.moveTo(24 + i * 8 + 4 - 8, 24 + 4);
			ctx.lineTo(24 + i * 8 - 4 - 32, 24 - 4);
		}
	}
	ctx.strokeStyle = '#2F2'
	ctx.stroke();

	ctx.beginPath();
	for (var i = 0; i < max_alive_cnt; i++) {
		if ((i + 1) % 5 != 0) {
			ctx.moveTo(width - (24 + i * 8 + 4), 8);
			ctx.lineTo(width - (24 + i * 8 - 4), 40);
		} else {
			ctx.moveTo(width - (24 + i * 8 + 4 - 8), 24 + 4);
			ctx.lineTo(width - (24 + i * 8 - 4 - 32), 24 - 4);
		}
	}
	ctx.strokeStyle = '#22F'
	ctx.stroke();
	// ctx.font = 'bold 32px Calibri';
	// ctx.fillText("#" + alive_cnt, TOP_DISTANCE, TOP_DISTANCE);
	ctx.restore();
}

function draw() {
	ctx.save();
	ctx.scale(devicePixelRatio, devicePixelRatio);
	draw_background();
	draw_alive_count();
	for (var i = 0; i <  happies.length; i++) {
		draw_happie(happies[i]);
	}
	ctx.restore();
}

function click(x, y) {
	for (var i = 0; i < happies.length; i++) {
		var dx = happies[i].x - x;
		var dy = happies[i].y - y;
		if (happies[i].life > 0 &&
			  happies[i].life <= LIFE && dx * dx + dy * dy <= RADIUS * RADIUS) {
			happies[i].life = LIFE + 1000;
			return;
		}
	}
}

function update(dt, time) {
	alive_cnt = 0;
	for (var i = 0; i <  happies.length; i++) {
		var happie = happies[i];
		var was_alive = happie.life > 0;
		happie.life = Math.max(happie.life - dt, 0);
		var is_dead = happie.life == 0;
		if (was_alive && is_dead) {
			last_died = time;
		}
		if (!is_dead) {
			alive_cnt += 1;
		}
	}
	if (alive_cnt == 0 || time - last_died > LIFE / 2) {
		last_died = time;
		add_happie();
	}
	max_alive_cnt = Math.max(max_alive_cnt, alive_cnt);
}

function tick(dt, time) {
	update(dt, time);
	draw();
}

canvas = document.getElementById('canvas');
canvas.width = width * devicePixelRatio;
canvas.height = height * devicePixelRatio;
canvas.style.width = width + "px";
canvas.style.height = height + "px";
ctx = canvas.getContext('2d');

canvas.addEventListener('mousemove', function (event) {
	event.preventDefault();
	event.stopPropagation();
	click(event.offsetX, event.offsetY);
}, false);
canvas.addEventListener('touchstart', function(event) {
	event.preventDefault();
	event.stopPropagation();
  var touch = event.targetTouches[0];
	click(touch.pageX, touch.pageY);
}, false);

var prev_time = 0;
requestAnimationFrame(function loop(time) {
	tick(time - prev_time, time);
	prev_time = time;
	requestAnimationFrame(loop);
})

for (var i = 0; i < 3; i++) {
	add_happie();
}
