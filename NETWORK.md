# Network intent

Container bridgeは、hostが接続するLAN・学内網・overlay networkの経路を奪わない。
Docker既定の`172.16.0.0/12`は学内DNSと、`10.0.0.0/8`はZeroTierと衝突し得るため、
自動割当には使わない。


 - 使い終わったComposeはdocker compose stopではなくdocker compose downにして、不要なbridge経路を残さな
    い。

  - Compose側で固定ipam.subnetを乱用しない。指定するとdaemonのpool管理を外れて再び衝突し得る。Compose
    networks (https://docs.docker.com/reference/compose-file/networks/)
