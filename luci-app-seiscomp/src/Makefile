# (C) 2019 Andres Heinloo, Helmholtz-Zentrum Potsdam - Deutsches GeoForschungsZentrum GFZ

compile:
	git clone https://github.com/crotwell/seisplotjs-waveformplot.git
	cd seisplotjs-waveformplot && git checkout 4e643fa5 && npm install browserify && npm run standalone

install:
	mkdir -p $(DESTDIR)/www/luci-static/resources/view/seiscomp
	cp seisplotjs-waveformplot/*.js $(DESTDIR)/www/luci-static/resources/view/seiscomp/seisplotjs_waveformplot.js

clean:
	rm -rf seisplotjs-waveformplot

