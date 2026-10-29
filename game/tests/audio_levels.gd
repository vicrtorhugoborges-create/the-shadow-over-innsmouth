extends SceneTree
## Mede pico e RMS (dBFS) de cada som provisório do SoundSynth (QA de áudio, docs/15).
## Não substitui escuta humana nem medição de loudness integrada (LUFS).


func _init() -> void:
	var s := SoundSynth.new()
	s.build()
	var ids: Array = s.bank.keys()
	ids.sort()
	var problems := 0
	print("%-16s %8s %8s %8s" % ["som", "pico", "RMS", "dur(s)"])
	for id: String in ids:
		var w := s.get_stream(id) as AudioStreamWAV
		var n := w.data.size() / 2
		var peak := 0.0
		var sum := 0.0
		for i in n:
			var v := absf(w.data.decode_s16(i * 2) / 32768.0)
			peak = maxf(peak, v)
			sum += v * v
		var rms := sqrt(sum / maxf(n, 1))
		var pk_db := linear_to_db(maxf(peak, 0.00001))
		var rms_db := linear_to_db(maxf(rms, 0.00001))
		var flag := ""
		if peak >= 0.97:
			flag = "  << satura"
			problems += 1
		elif pk_db < -24.0:
			flag = "  << baixo demais"
			problems += 1
		print("%-16s %8.1f %8.1f %8.2f%s" % [id, pk_db, rms_db, float(n) / w.mix_rate, flag])
	print("\n%d sons fora da faixa" % problems)
	quit(0)
