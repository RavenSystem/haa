# OTA update test server without HTTPS
Useful to perform very fast OTA updates; or update devices with very old firmware, from v2.5.3.
- Server: haa.ravensystem.es
- Port: 80
- HTTPS: Unchecked

## Update from very old versions
It is possible to update using OTA from v2.0.0. However, if current version is between v2.0.0 and v2.5.2, an intermediate step is needed:
- Server: haa.ravensystem.es/migrate_old
- Port: 80
- HTTPS: Unchecked

When device is updated to v6.0.7, remove `/migrate_old` part from Server and update again.
