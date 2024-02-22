key='/project/repositories/repository'
# key='/project/repositories/repository'
# key='//project'
xml="../../sandbox/voltha-onos/dependencies.xml"

xmlstarlet sel -t \
  --match "$key" \
  --value-of '.' \
  --nl \
  "$xml"

# project/repositories/repository/id

