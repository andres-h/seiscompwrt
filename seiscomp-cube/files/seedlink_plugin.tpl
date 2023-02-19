* template: $template
plugin $seedlink.source.id cmd="$seedlink.plugin_dir/cube_plugin$seedlink._daemon_opt -vvv$sources.cube.ntpFlag -i $seedlink.config_dir/plugins.ini -c $sources.cube.config -s $sources.cube.comport"
             timeout = 0
             start_retry = 60
             shutdown_wait = 10
             proc = "$sources.cube.proc"

