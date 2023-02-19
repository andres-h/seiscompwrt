  <proc name="$sources.cube.proc">
    <tree>
      <input name="${sources.cube.stream}Z" channel="Z" location="$sources.cube.location" rate="$sources.cube.sample_rate"/>
      <input name="${sources.cube.stream}N" channel="N" location="$sources.cube.location" rate="$sources.cube.sample_rate"/>
      <input name="${sources.cube.stream}E" channel="E" location="$sources.cube.location" rate="$sources.cube.sample_rate"/>
      <node stream="$sources.cube.stream"/>
    </tree>
  </proc>
