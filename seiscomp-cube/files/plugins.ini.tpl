[$seedlink.source.id]
*#available modes [0 = FILE|1 = SEEDLINK|2 = CAPS]
mode=1
gps_min_satellites=$sources.cube.gps_min_satellites
gps_dump_interval=$sources.cube.gps_dump_interval
gps_init_timestamps=$sources.cube.gps_init_timestamps
max_jitter=$sources.cube.max_jitter
network="$seedlink.station.network"
station="$seedlink.station.code"
location="$sources.cube.location"
stream="$sources.cube.stream"
channels="$sources.cube.channels"

