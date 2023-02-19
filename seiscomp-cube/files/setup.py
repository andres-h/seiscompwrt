import os

"""
Plugin handler for the DATA-CUBE plugin.
"""
class SeedlinkPluginHandler:
    def __init__(self):
        self.instances = {}

    def push(self, seedlink):
        comport = "/dev/data"
        try: comport = seedlink.param("sources.cube.comport")
        except: seedlink.setParam("sources.cube.comport", comport)

        try: seedlink.param("sources.cube.baudrate")
        except: seedlink.setParam("sources.cube.baudrate", 19200)

        try: seedlink.param("sources.cube.gps_min_satellites")
        except: seedlink.setParam("sources.cube.gps_min_satellites", "3")

        try: seedlink.param("sources.cube.gps_dump_interval")
        except: seedlink.setParam("sources.cube.gps_dump_interval", "1")

        try: seedlink.param("sources.cube.gps_init_timestamps")
        except: seedlink.setParam("sources.cube.gps_init_timestamps", "3")

        try: seedlink.param("sources.cube.max_jitter")
        except: seedlink.setParam("sources.cube.max_jitter", "-1")

        try: seedlink.param("sources.cube.location")
        except: seedlink.setParam("sources.cube.location", "")

        try: seedlink.param("sources.cube.stream")
        except: seedlink.setParam("sources.cube.stream", "HH")

        channels = "Z,N,E"
        try: channels = seedlink.param("sources.cube.channels")
        except: seedlink.setParam("sources.cube.channels", channels)

        seedlink.setParam("sources.cube.nchan", len(channels.split(",")))

        try: seedlink.param("sources.cube.sample_rate")
        except: seedlink.setParam("sources.cube.sample_rate", 100)

        try: seedlink.param("sources.cube.filter_delay")
        except: seedlink.setParam("sources.cube.filter_delay", 31)

        try:
            if seedlink.param("sources.cube.ntp").lower() in ("yes", "true", "1"):
                seedlink.setParam("sources.cube.ntpFlag", " -w -n")
            else:
                seedlink.setParam("sources.cube.ntpFlag", "")
        except:
            seedlink.setParam("sources.cube.ntpFlag", "")

        try:
            n = self.instances[comport]

        except KeyError:
            n = len(self.instances)
            self.instances[comport] = n

        cubeconfig = os.path.join(seedlink.config_dir, "cube%d.config" % n)
        seedlink.setParam("sources.cube.config", cubeconfig)

        with open(cubeconfig, "w") as f:
            f.write(seedlink._process_template("cubeconfig.tpl", "cube"))

        proc = "auto"
        try: proc = seedlink.param("sources.cube.proc")
        except: pass

        if proc == "auto":
            seedlink.setParam("sources.cube.proc", "auto:cube%s" % n)

        return comport

    def flush(self, seedlink):
        pass

