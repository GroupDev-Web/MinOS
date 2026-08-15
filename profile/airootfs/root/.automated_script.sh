#!/usr/bin/env bash
systemctl start systemd-networkd.service systemd-resolved.service iwd.service
exec /bin/bash -l

