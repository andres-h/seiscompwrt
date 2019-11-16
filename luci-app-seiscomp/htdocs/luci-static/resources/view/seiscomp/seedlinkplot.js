// (C) 2019 Andres Heinloo, Helmholtz-Zentrum Potsdam - Deutsches GeoForschungsZentrum GFZ

function SeedlinkPlot(live, duration, pollInterval) {
	var margin = {top: 20, right: 20, bottom: 50, left: 60}
	var wp = seisplotjs_waveformplot
	var timeWindow = wp.calcStartEndDates(null, null, duration)
	var svgparent = wp.d3.select("#slplot")
	var traces = new Map()
	var seq = null

	function Trace(name, descr, unit, conversion) {
		var svgdiv = svgparent.append("div").attr("class", "sltrace")
		var cf = eval("(function(counts){return(" + conversion + ")})")
		var sg = null

		this.plot = function(segments) {
			if (!sg) {
				wp.d3.select("#waitingdata").remove()
				sg = new wp.Seismograph(svgdiv, segments, timeWindow.start, timeWindow.end)

				if (live) {
					sg.disableWheelZoom()
				}

				sg.redoDisplayYScale = function() {
					this.yScaleRmean.domain(this.yScale.domain().map(cf))
					this.rescaleYAxis()
				}

				sg.setAmplitudeFormatter(function(x) { return x.toString() })
				sg.setTitle(descr)
				sg.setYLabel("")
				sg.setYSublabel(unit)
				sg.setMargin(margin)
				sg.redoDisplayYScale()
				sg.draw()

			} else {
				sg.trim(timeWindow)
				sg.append(segments)
			}
		}

		this.setPlotStartEnd = function(s, e) {
			if (sg) {
				sg.setPlotStartEnd(s, e)
			}
		}
	}

	function done(arraybuf) {
		var bycode = new Map()

		for (var i = 0; i < arraybuf.byteLength; i += 520) {
			if (arraybuf.byteLength - i < 520) {
				console.error("record too small")
				return
			}

			var slHeader = String.fromCharCode.apply(null, new Uint8Array(arraybuf, i, 8))

			if (slHeader.slice(0, 2) != "SL") {
				console.error("bad seedlink signature")
				return
			}

			seq = parseInt(slHeader.slice(2, 8), 16)

			if (seq == NaN) {
				console.error("bad sequence")
				return
			}

			var slData = new DataView(arraybuf, i+8, 512)
			var rec = wp.miniseed.parseSingleDataRecord(slData)
			var code = rec.header.locCode + rec.header.chanCode
			var reclist = bycode.get(code)

			if (reclist) {
				reclist.push(rec)
			} else {
				bycode.set(code, [rec])
			}
		}

		if (bycode.size > 0) {
			bycode.forEach(function(reclist, code) {
				var p = traces.get(code)
				if (p) {
					p.plot(wp.miniseed.merge(reclist))
				} else {
					console.error("unexpected channel " + code + " received")
				}
			})

			next()

		} else if (live || seq == null) {
			window.setTimeout(next, pollInterval * 1000)
		}
	}

	function handler() {
		if (this.readyState == this.DONE) {
			if (this.status == 200) {
				if (this.getResponseHeader("Content-Type") == "text/plain") {
					alert(String.fromCharCode.apply(null, new Uint8Array(this.response.slice(0, 100))))
				} else {
					done(this.response)
				}
			} else {
				console.error(this)
			}
		}
	}

	function next() {
		var xhr = new XMLHttpRequest()
		var url = "/cgi-bin/luci/admin/services/seedlink/fetch?stream="
		var streams = Array.from(traces.keys()).join(",")

		if (streams.length == 0) {
			alert("no streams configured")
			return
		}

		if (seq == null) {
			var start = timeWindow.start.format("YYYY,MM,DD,HH,mm,ss")
			xhr.open("GET", url + streams + "&start=" + start)

		} else {
			xhr.open("GET", url + streams + "&seq=" + ((seq+1) & 0xffffff).toString(16))
		}

		xhr.onreadystatechange = handler
		xhr.responseType = "arraybuffer"
		xhr.send()
	}

	this.run = function() {
		if (live) {
			var timerInterval = (timeWindow.end.valueOf()-timeWindow.start.valueOf())/
				(parseInt(svgparent.style("width"))-margin.left-margin.right)

			wp.d3.interval(function(elapsed) {
				timeWindow = wp.calcStartEndDates(null, null, duration)
				traces.forEach(function(p) {
					p.setPlotStartEnd(timeWindow.start, timeWindow.end)
				})
			}, timerInterval)
		}

		next()
	}

	this.add = function(name, descr, unit, conversion) {
		traces.set(name, new Trace(name, descr, unit, conversion))
	}
}

