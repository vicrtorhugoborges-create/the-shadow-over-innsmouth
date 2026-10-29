class_name SoundSynth
extends RefCounted
## Sons sintetizados em tempo de execução (autoria própria, D-021; inventário em docs/18 §11).
## Nenhum arquivo de áudio externo. Substituir por material licenciado antes de distribuir.

const RATE := 22050

var _rng := RandomNumberGenerator.new()
var bank: Dictionary = {}


func build() -> void:
	_rng.seed = 1927
	bank["sfx_knock"] = _knock(0.35, 70.0)
	bank["sfx_blow"] = _knock(0.5, 48.0, 1.0)
	bank["sfx_crash"] = _crash(1.1)
	bank["sfx_creak"] = _creak(0.9, 180.0, 120.0)
	bank["sfx_creak_long"] = _creak(1.6, 140.0, 95.0)
	bank["sfx_key"] = _clicks(0.7, 9)
	bank["sfx_bolt"] = _bolt()
	bank["sfx_scrape"] = _scrape(1.4)
	bank["sfx_step_wood"] = _step(0.18, 95.0)
	bank["sfx_step_stone"] = _step(0.12, 140.0)
	bank["sfx_croak"] = _croak(0.9, 62.0)
	bank["sfx_croak_low"] = _croak(1.3, 44.0)
	bank["sfx_breath"] = _breath(1.6)
	bank["sfx_switch"] = _clicks(0.08, 1)
	bank["sfx_cloth"] = _noise_env(0.8, 0.25, 3000.0)
	bank["sfx_thud"] = _knock(0.4, 55.0, 0.8)
	bank["sfx_slate"] = _clicks(0.5, 5, 0.6)
	bank["sfx_bell"] = _bell(4.0, 220.0)
	bank["sfx_heart"] = _heart()
	bank["amb_room"] = _loop_noise(4.0, 0.03, 300.0)
	bank["amb_wind"] = _loop_wind(6.0)
	bank["amb_sea"] = _loop_sea(8.0)
	bank["amb_falls"] = _loop_noise(4.0, 0.22, 900.0)
	bank["amb_drone"] = _loop_drone(8.0)
	bank["sfx_motor"] = _loop_motor(3.0)
	bank["sfx_flop"] = _loop_flop(6.0)
	bank["sfx_patter"] = _loop_patter(4.0)
	bank["sfx_bats"] = _bats(2.2)


func get_stream(id: String) -> AudioStream:
	return bank.get(id, null)


func _make(samples: PackedFloat32Array, loop: bool = false) -> AudioStreamWAV:
	# Normaliza o pico a −3 dBFS: sem saturação na conversão e níveis comparáveis entre sons
	# (o equilíbrio fica no volume de reprodução). Ver docs/qa/audio-niveis-v02.log.
	var peak := 0.0
	for x in samples:
		peak = maxf(peak, absf(x))
	var gain := 0.707 / peak if peak > 0.00001 else 1.0
	var data := PackedByteArray()
	data.resize(samples.size() * 2)
	for i in samples.size():
		var v := int(clampf(samples[i] * gain, -1.0, 1.0) * 32767.0)
		data.encode_s16(i * 2, v)
	var s := AudioStreamWAV.new()
	s.format = AudioStreamWAV.FORMAT_16_BITS
	s.mix_rate = RATE
	s.stereo = false
	s.data = data
	if loop:
		s.loop_mode = AudioStreamWAV.LOOP_FORWARD
		s.loop_begin = 0
		s.loop_end = samples.size()
	return s


func _buf(seconds: float) -> PackedFloat32Array:
	var a := PackedFloat32Array()
	a.resize(int(seconds * RATE))
	return a


func _knock(seconds: float, freq: float, gain: float = 0.9) -> AudioStreamWAV:
	var a := _buf(seconds)
	var lp := 0.0
	for i in a.size():
		var t := float(i) / RATE
		var env := exp(-t * 18.0)
		var body := sin(TAU * freq * t * (1.0 - t * 0.6)) * env
		var n := _rng.randf_range(-1.0, 1.0)
		lp += (n - lp) * 0.25
		a[i] = (body * 0.9 + lp * exp(-t * 60.0) * 0.8) * gain
	return _make(a)


func _crash(seconds: float) -> AudioStreamWAV:
	var a := _buf(seconds)
	var lp := 0.0
	for i in a.size():
		var t := float(i) / RATE
		var n := _rng.randf_range(-1.0, 1.0)
		lp += (n - lp) * 0.35
		var splinter := 0.0
		if _rng.randf() < 0.02 * exp(-t * 4.0):
			splinter = _rng.randf_range(-1.0, 1.0)
		a[i] = (lp * exp(-t * 5.0) + sin(TAU * 42.0 * t) * exp(-t * 9.0) + splinter) * 0.8
	return _make(a)


func _creak(seconds: float, f0: float, f1: float) -> AudioStreamWAV:
	var a := _buf(seconds)
	var phase := 0.0
	var lp := 0.0
	for i in a.size():
		var t := float(i) / RATE
		var k := t / seconds
		var f := lerpf(f0, f1, k) * (1.0 + 0.04 * sin(TAU * 7.0 * t))
		phase += f / RATE
		var saw := fposmod(phase, 1.0) * 2.0 - 1.0
		var pulse := 1.0 if fposmod(phase * 0.5, 1.0) < 0.15 else 0.2
		lp += (saw * pulse - lp) * 0.12
		var env := sin(PI * k)
		a[i] = lp * env * 0.7
	return _make(a)


func _clicks(seconds: float, count: int, gain: float = 0.8) -> AudioStreamWAV:
	var a := _buf(seconds)
	for c in count:
		var start := int(_rng.randf_range(0.0, seconds * 0.85) * RATE)
		var f := _rng.randf_range(1800.0, 3400.0)
		for j in 500:
			var idx := start + j
			if idx >= a.size():
				break
			var t := float(j) / RATE
			a[idx] += sin(TAU * f * t) * exp(-t * 300.0) * gain + _rng.randf_range(-0.2, 0.2) * exp(-t * 400.0)
	return _make(a)


func _bolt() -> AudioStreamWAV:
	var a := _buf(0.45)
	for i in a.size():
		var t := float(i) / RATE
		var scrape := _rng.randf_range(-1.0, 1.0) * 0.25 * (1.0 if t < 0.3 else 0.0)
		var clack := 0.0
		if t > 0.3:
			var u := t - 0.3
			clack = sin(TAU * 1300.0 * u) * exp(-u * 90.0)
		a[i] = scrape + clack * 0.8
	return _make(a)


func _scrape(seconds: float) -> AudioStreamWAV:
	var a := _buf(seconds)
	var lp := 0.0
	for i in a.size():
		var t := float(i) / RATE
		var n := _rng.randf_range(-1.0, 1.0)
		lp += (n - lp) * 0.05
		var chatter := 0.6 + 0.4 * sin(TAU * 11.0 * t)
		a[i] = lp * 3.0 * chatter * sin(PI * t / seconds) * 0.6
	return _make(a)


func _step(seconds: float, freq: float) -> AudioStreamWAV:
	var a := _buf(seconds)
	var lp := 0.0
	for i in a.size():
		var t := float(i) / RATE
		var n := _rng.randf_range(-1.0, 1.0)
		lp += (n - lp) * 0.2
		a[i] = (sin(TAU * freq * t) * exp(-t * 35.0) + lp * exp(-t * 50.0)) * 0.6
	return _make(a)


func _croak(seconds: float, freq: float) -> AudioStreamWAV:
	## Vocalização não humana provisória: pulsos graves irregulares com ruído úmido.
	var a := _buf(seconds)
	var phase := 0.0
	var lp := 0.0
	for i in a.size():
		var t := float(i) / RATE
		var k := t / seconds
		var f := freq * (1.0 + 0.25 * sin(TAU * 3.3 * t) + 0.1 * sin(TAU * 17.0 * t))
		phase += f / RATE
		var p := fposmod(phase, 1.0)
		var pulse := (1.0 - p) * (1.0 - p) * 2.0 - 0.5
		var gate := 1.0 if fposmod(t * 6.0, 1.0) < 0.7 else 0.3
		var n := _rng.randf_range(-1.0, 1.0)
		lp += (n - lp) * 0.08
		a[i] = (pulse * 0.6 + lp * 1.5) * gate * sin(PI * k) * 0.8
	return _make(a)


func _breath(seconds: float) -> AudioStreamWAV:
	var a := _buf(seconds)
	var lp := 0.0
	for i in a.size():
		var t := float(i) / RATE
		var n := _rng.randf_range(-1.0, 1.0)
		lp += (n - lp) * 0.06
		var env := pow(sin(PI * fposmod(t / (seconds * 0.5), 1.0)), 2.0)
		a[i] = lp * env * 1.4
	return _make(a)


func _noise_env(seconds: float, gain: float, _cut: float) -> AudioStreamWAV:
	var a := _buf(seconds)
	var lp := 0.0
	for i in a.size():
		var t := float(i) / RATE
		var n := _rng.randf_range(-1.0, 1.0)
		lp += (n - lp) * 0.3
		a[i] = lp * gain * 3.0 * sin(PI * t / seconds)
	return _make(a)


func _bell(seconds: float, freq: float) -> AudioStreamWAV:
	## Sino rachado: parciais inarmônicos com batimento.
	var a := _buf(seconds)
	var partials := [1.0, 2.13, 2.76, 4.07, 5.4]
	for i in a.size():
		var t := float(i) / RATE
		var v := 0.0
		for j in partials.size():
			v += sin(TAU * freq * partials[j] * t + j) * exp(-t * (0.9 + j * 0.7)) / (j + 1.0)
		v *= 1.0 + 0.3 * sin(TAU * 4.7 * t)
		a[i] = v * 0.5
	return _make(a)


func _heart() -> AudioStreamWAV:
	var a := _buf(0.9)
	for i in a.size():
		var t := float(i) / RATE
		var v := sin(TAU * 50.0 * t) * exp(-t * 30.0)
		if t > 0.25:
			var u := t - 0.25
			v += sin(TAU * 45.0 * u) * exp(-u * 30.0) * 0.7
		a[i] = v * 0.8
	return _make(a)


func _loop_noise(seconds: float, gain: float, smooth_hz: float) -> AudioStreamWAV:
	var a := _buf(seconds)
	var lp := 0.0
	var k := clampf(smooth_hz / RATE * 6.0, 0.001, 1.0)
	for i in a.size():
		var n := _rng.randf_range(-1.0, 1.0)
		lp += (n - lp) * k
		a[i] = lp * gain * 4.0
	_crossfade(a)
	return _make(a, true)


func _loop_wind(seconds: float) -> AudioStreamWAV:
	var a := _buf(seconds)
	var lp := 0.0
	for i in a.size():
		var t := float(i) / RATE
		var gust := 0.55 + 0.45 * sin(TAU * t / seconds * 2.0) * sin(TAU * t / seconds * 3.0 + 1.0)
		var n := _rng.randf_range(-1.0, 1.0)
		lp += (n - lp) * (0.01 + 0.02 * gust)
		a[i] = lp * 5.0 * gust * 0.5
	_crossfade(a)
	return _make(a, true)


func _loop_sea(seconds: float) -> AudioStreamWAV:
	var a := _buf(seconds)
	var lp := 0.0
	for i in a.size():
		var t := float(i) / RATE
		var swell := pow(0.5 + 0.5 * sin(TAU * t / seconds * 2.0 - PI / 2.0), 2.0)
		var n := _rng.randf_range(-1.0, 1.0)
		lp += (n - lp) * (0.02 + 0.08 * swell)
		a[i] = lp * (0.3 + swell) * 1.6
	_crossfade(a)
	return _make(a, true)


func _loop_drone(seconds: float) -> AudioStreamWAV:
	var a := _buf(seconds)
	var fs := [55.0, 55.0 * 1.498, 55.0 * 2.01, 41.2]
	for i in a.size():
		var t := float(i) / RATE
		var v := 0.0
		for j in fs.size():
			# Frequências arredondadas para ciclos inteiros no laço, evitando cliques.
			var f := roundf(fs[j] * seconds) / seconds
			v += sin(TAU * f * t + j) * (0.5 + 0.5 * sin(TAU * t / seconds * (j + 1)))
		a[i] = v * 0.12
	return _make(a, true)


func _loop_motor(seconds: float) -> AudioStreamWAV:
	## Motor de 1927 provisório: explosões graves regulares com chocalho.
	var a := _buf(seconds)
	var lp := 0.0
	var f := roundf(18.0 * seconds) / seconds
	for i in a.size():
		var t := float(i) / RATE
		var cyc := fposmod(t * f, 1.0)
		var pop := exp(-cyc * 9.0)
		var n := _rng.randf_range(-1.0, 1.0)
		lp += (n - lp) * 0.15
		a[i] = (pop * sin(TAU * 60.0 * t) * 0.8 + lp * pop * 1.5 + lp * 0.15) * 0.7
	return _make(a, true)


func _loop_flop(seconds: float) -> AudioStreamWAV:
	## "Colossal flopping or pattering": centenas de impactos úmidos sobrepostos.
	var a := _buf(seconds)
	for k in 260:
		var start := _rng.randi_range(0, a.size() - 1)
		var f := _rng.randf_range(70.0, 160.0)
		var gain := _rng.randf_range(0.15, 0.4)
		var lp := 0.0
		for j in 1400:
			var idx := (start + j) % a.size()
			var t := float(j) / RATE
			var n := _rng.randf_range(-1.0, 1.0)
			lp += (n - lp) * 0.3
			a[idx] += (sin(TAU * f * t) * 0.6 + lp) * exp(-t * 45.0) * gain
	for i in a.size():
		a[i] = clampf(a[i] * 0.5, -1.0, 1.0)
	return _make(a, true)


func _loop_patter(seconds: float) -> AudioStreamWAV:
	var a := _buf(seconds)
	for k in 34:
		var start := _rng.randi_range(0, a.size() - 1)
		var lp := 0.0
		for j in 900:
			var idx := (start + j) % a.size()
			var t := float(j) / RATE
			var n := _rng.randf_range(-1.0, 1.0)
			lp += (n - lp) * 0.25
			a[idx] += lp * exp(-t * 70.0) * 0.5
	return _make(a, true)


func _bats(seconds: float) -> AudioStreamWAV:
	var a := _buf(seconds)
	var lp := 0.0
	for i in a.size():
		var t := float(i) / RATE
		var flutter := 0.5 + 0.5 * sin(TAU * (28.0 + 9.0 * sin(t * 3.0)) * t)
		var n := _rng.randf_range(-1.0, 1.0)
		lp += (n - lp) * 0.4
		var env := minf(t * 8.0, 1.0) * exp(-maxf(t - 0.6, 0.0) * 2.2)
		a[i] = lp * flutter * env * 0.9
	return _make(a)


func _crossfade(a: PackedFloat32Array) -> void:
	var n := mini(int(0.3 * RATE), a.size() / 4)
	var size := a.size()
	for i in n:
		var w := float(i) / n
		var tail := a[size - n + i]
		a[i] = a[i] * w + tail * (1.0 - w)
	a.resize(size - n)
