class_name SiegeDirector
extends RefCounted
## Cerco do Gilman House (sys_pursuit / SiegeDirector), docs/08 §5.
## Lógica pura: recebe progresso do jogador e tempo; devolve pedidos de apresentação e falhas.
## Não avança quando não é chamado (pausa, documentos, Diário).

enum Phase { IDLE, S0_SILENCE, S1_KNOCK, S2_CONTINUOUS, S3_BLOWS, S4_PASSKEYS, S5_N2, S6_LATERAL, S7_RAM, ESCAPED, FAILED }

const T1_BASE := 45.0
const T1_BUREAU := 20.0
const T2 := 6.0
const T2_ASSIST := 12.0
const T3 := 5.0
const T3_ASSIST := 10.0
const S1_MIN := 20.0
const S1_MAX := 180.0
const S2_AFTER := 8.0
const S3_AUTO := 60.0
const S5_DELAY := 3.0
const S6_PASSKEY_N3 := 6.0
const S7_AUTO := 25.0
const S7_ENTRY_GRACE := 2.5
const S8_BASE := 40.0
const S8_PER_BARRICADE := 15.0
const S8_MAX := 70.0

var phase: Phase = Phase.IDLE
var failure: String = ""
var assisted: bool = false
var fail_counts: Dictionary = {}

var _t: float = 0.0
var _bureau: bool = false
var _prep_min: bool = false
var _n2_north_bolted: bool = false
var _barricades: int = 0
var _passkey_n3_sent: bool = false
var _ram_hits_sent: int = 0
var _s3_announced: bool = false
var _n3_entered: bool = false


func configure(is_assisted: bool, counts: Dictionary) -> void:
	assisted = is_assisted
	fail_counts = counts


func _scale(test: String, base: float, assist_value: float = -1.0) -> float:
	var v := base
	if assisted:
		v = assist_value if assist_value > 0.0 else base * 1.5
	if int(fail_counts.get(test, 0)) >= 2:
		v *= 1.25
	return v


func t1_limit() -> float:
	return _scale("T1", T1_BASE + (T1_BUREAU if _bureau else 0.0))


func t2_limit() -> float:
	return _scale("T2", T2, T2_ASSIST)


func t3_limit() -> float:
	return _scale("T3", T3, T3_ASSIST)


func s8_limit() -> float:
	return _scale("T4", minf(S8_BASE + S8_PER_BARRICADE * _barricades, S8_MAX))


func phase_time() -> float:
	return _t


func start(at_phase: Phase = Phase.S0_SILENCE) -> Array[String]:
	failure = ""
	_enter(at_phase)
	var out: Array[String] = []
	match at_phase:
		Phase.S1_KNOCK:
			out.append("knock_first")
		Phase.S7_RAM:
			_n3_entered = true
			_n2_north_bolted = true
			out.append("ram_start")
	return out


func _enter(p: Phase) -> void:
	phase = p
	_t = 0.0


func notify(event: String) -> Array[String]:
	var out: Array[String] = []
	match event:
		"prep_min":
			_prep_min = true
		"bureau_hall":
			_bureau = true
		"north_hit":
			if phase == Phase.S1_KNOCK or phase == Phase.S2_CONTINUOUS:
				_enter(Phase.S3_BLOWS)
				out.append("hall_blows")
		"north_forced":
			if phase in [Phase.S1_KNOCK, Phase.S2_CONTINUOUS, Phase.S3_BLOWS]:
				_enter(Phase.S4_PASSKEYS)
				out.append("battering")
				out.append("passkeys_neighbors")
		"n1_bolted":
			if phase == Phase.S4_PASSKEYS:
				_enter(Phase.S5_N2)
		"n2_bolted":
			if phase == Phase.S5_N2:
				_enter(Phase.S6_LATERAL)
				out.append("battering_abates")
				out.append("lateral_attack")
		"n2_north_bolted":
			_n2_north_bolted = true
		"barricade":
			_barricades = mini(_barricades + 1, 3)
			# O aríete só começa cedo se a porta norte já estiver fechada: barricar na
			# ordem "errada" nunca encurta o prazo do jogador.
			if phase == Phase.S6_LATERAL and _n2_north_bolted:
				out.append_array(_begin_ram())
		"descent_started":
			if phase != Phase.FAILED:
				_enter(Phase.ESCAPED)
	return out


func _begin_ram() -> Array[String]:
	_enter(Phase.S7_RAM)
	_n3_entered = true
	return ["scurry_north", "ram_start"]


func _fail(code: String, test: String) -> Array[String]:
	phase = Phase.FAILED
	failure = code
	fail_counts[test] = int(fail_counts.get(test, 0)) + 1
	return ["fail:" + code]


func advance(delta: float) -> Array[String]:
	var out: Array[String] = []
	if phase == Phase.IDLE or phase == Phase.ESCAPED or phase == Phase.FAILED:
		return out
	_t += delta
	match phase:
		Phase.S0_SILENCE:
			if (_prep_min and _t >= S1_MIN) or _t >= S1_MAX:
				_enter(Phase.S1_KNOCK)
				out.append("knock_first")
		Phase.S1_KNOCK:
			if _t >= S2_AFTER:
				_enter(Phase.S2_CONTINUOUS)
				out.append("knock_continuous")
		Phase.S2_CONTINUOUS:
			if _t >= S3_AUTO:
				_enter(Phase.S3_BLOWS)
				out.append("hall_blows")
		Phase.S3_BLOWS:
			if not _s3_announced and _t >= t1_limit() * 0.6:
				_s3_announced = true
				out.append("hall_door_splinter")
			if _t >= t1_limit():
				out.append_array(_fail("F1", "T1"))
		Phase.S4_PASSKEYS:
			if _t >= t2_limit():
				out.append_array(_fail("F2", "T2"))
		Phase.S5_N2:
			if _t >= S5_DELAY and _t - delta < S5_DELAY:
				out.append("passkey_n2")
			if _t >= S5_DELAY + t3_limit():
				out.append_array(_fail("F3", "T3"))
		Phase.S6_LATERAL:
			if not _passkey_n3_sent and _t >= S6_PASSKEY_N3:
				_passkey_n3_sent = true
				out.append("passkey_n3")
			if _t >= S7_AUTO:
				out.append_array(_begin_ram())
		Phase.S7_RAM:
			if _t >= S7_ENTRY_GRACE and not _n2_north_bolted:
				return _fail("F4", "T4")
			var hits := int(_t / 2.2)
			if hits > _ram_hits_sent:
				_ram_hits_sent = hits
				out.append("ram_hit")
				var limit := s8_limit()
				if _t >= limit * 0.5 and _t - 2.2 < limit * 0.5:
					out.append("panel_crack_1")
				if _t >= limit * 0.8 and _t - 2.2 < limit * 0.8:
					out.append("panel_crack_2")
			if _t >= s8_limit():
				out.append_array(_fail("F4", "T4"))
	return out


func is_active() -> bool:
	return phase != Phase.IDLE and phase != Phase.ESCAPED and phase != Phase.FAILED


func requires_hall_n2_push() -> bool:
	return phase == Phase.S5_N2 and _t >= S5_DELAY
