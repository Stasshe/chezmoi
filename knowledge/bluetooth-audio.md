# WH-1000XM5 Bluetooth通話障害

## Scope

Arch Hyprland環境でWH-1000XM5のA2DP/HFP transport、PipeWire routing、Noctalia/Discord再接続が同時に壊れた事例。AIはBluetooth接続、node存在、RTC接続を音声正常の証拠にしない。Active Profile、codec、実stream link、transport log、実聴を別々に確認する。

## 確認済み環境

| 項目 | 値 |
| --- | --- |
| OS | Arch Linux rolling / Hyprland / Wayland |
| Kernel | `7.1.3-arch2-2` |
| BlueZ | `5.87-2` |
| PipeWire | `1.6.8-1` |
| WirePlumber | `0.5.15-1` |
| Headset | Sony WH-1000XM5、MAC `58:18:62:07:75:BD` |
| Controller | MediaTek MT7921系、USB `0489:e0cd`、hci0 `3C:EF:A5:99:83:86` |
| sysfs | 当該bootでは `/sys/bus/usb/devices/1-5`。bootごとに変わり得る |

WirePlumber設定元: `dot_config/wireplumber/wireplumber.conf.d/bluetooth.conf`。

## 要求状態

- Discord受信音声とYouTubeをXM5から再生。
- Discord入力にXM5マイクを使用。
- Bluetooth Classicの同時入出力なのでHFP必須。A2DP/LDACとXM5マイクは同時利用不可。
- CVSDは8kHzで劣悪。mSBC 16kHzを正常系とする。

## 状態の読み方

| 観測 | 意味 |
| --- | --- |
| `bluetoothctl info`: `Connected: yes` | ACL接続のみ。音声transport正常を保証しない |
| `wpctl status`にXM5 device/node | graph objectのみ。profile/transport/streamは別確認 |
| Active Profile `a2dp-sink` | 高音質出力。XM5マイク利用不能 |
| A2DP中の`bluez_input.*` | WirePlumber loopback/filter残留の場合あり。実HFPマイクの証拠ではない |
| HFP sink 8kHz | CVSD。通話可能でも音質要件外 |
| HFP sink 16kHz、codec mSBC | 期待状態 |
| Noctalia `No output/input device selected` | PipeWire/WirePlumber再起動後のstale connectionを疑う |
| Discord RTC CONNECTED、PipeWire streamなし | 空/古いdevice ID。ネットワーク接続とローカル音声は別 |

## 観測したerror

WirePlumber/PipeWire:

```text
spa.bluez5: Acquire ... returned error: org.bluez.Error.Failed
pw.node: (...) running -> error (Received error event)
spa.bluez5: Failure in Bluetooth audio transport .../fd40
s-device: Could not find valid non-headset profile, not switching
spa.bluez5.device: failed to switch codec (-5)
```

BlueZ:

```text
Start: Connection timed out (110)
Suspend: Connection timed out (110)
Abort: Connection timed out (110)
Unable to get io data for Hands-Free Voice gateway: Transport endpoint is not connected (107)
```

Kernel:

```text
Bluetooth: hci0: HCI Enhanced Setup Synchronous Connection command is advertised, but not supported.
```

kernel message単独では原因確定しない。controllerは`btmgmt info`で`wide-band-speech`をsupported/currentに出していた。今回の決定的差分はUSB autosuspend停止後のmSBC安定化。

Discord故障時:

```text
audioInputDeviceName="Default: "
audioOutputDeviceName="Default: "
```

RTCはCONNECTEDでも上記ならPipeWireに`playStream`/`recStream`を生成しない。

## 原因と確度

Bluetooth USBでautosuspendが有効だった。

```text
power/control=auto
power/autosuspend=2
power/autosuspend_delay_ms=2000
```

2秒のautosuspend後、A2DP/HFPの開始・停止・再取得がtimeoutし、mSBC SCO transportが約35秒周期でerrorへ遷移。`power/control=on`変更後、mSBC入出力とDiscord streamsをactiveにしたまま45秒超監視しtransport error 0件。autosuspend停止を本事例の確認済み運用修正とする。

HCI packet captureは`btmon`が`Operation not permitted`で採取不能。controller firmwareとbtusb/btmtkのどちらがautosuspend復帰を誤処理したかは未確定。btusb `force_scofix`は存在確認のみで未適用。根拠なく有効化しない。

## 診断

### 1. 接続とprofile

```sh
bluetoothctl info 58:18:62:07:75:BD
systemctl --user --no-pager --full status pipewire pipewire-pulse wireplumber
wpctl status
pactl list short cards
pactl list cards
pactl list short sinks
pactl list short sources
```

`pactl list cards`のXM5 `Active Profile`を必読。`wpctl`数値IDは再接続ごとに変わる。操作にはstable nameを使う。

```text
bluez_card.58_18_62_07_75_BD
bluez_output.58_18_62_07_75_BD.1
bluez_input.58:18:62:07:75:BD
```

### 2. transport

```sh
journalctl -b --no-pager -u bluetooth.service --since '15 minutes ago'
journalctl --user -b --no-pager -u wireplumber.service --since '15 minutes ago'
journalctl -k -b --no-pager | rg -i 'bluetooth|btusb|firmware|sco|hci0'
```

### 3. controllerとautosuspend

```sh
readlink -f /sys/class/bluetooth/hci0/device
udevadm info -q property -p "$(readlink -f /sys/class/bluetooth/hci0/device)"
btmgmt info
dirname "$(readlink -f /sys/class/bluetooth/hci0/device)"
```

最後の出力が当該bootのUSB device directory。そこで`idVendor`、`idProduct`、`power/control`、`power/autosuspend_delay_ms`を読む。`1-5`を他bootへ流用しない。

### 4. application stream

```sh
pactl list sink-inputs | rg '^Sink Input|^\s+Sink:|application.name|application.process.binary|media.name'
pactl list source-outputs | rg '^Source Output|^\s+Source:|application.name|application.process.binary|media.name'
```

Discord正常時は`WEBRTC VoiceEngine/playStream`がXM5 sink、`WEBRTC VoiceEngine/recStream`がXM5 sourceへ接続。RTC logだけで正常判定しない。

## 復旧

### 1. autosuspend停止

確認したUSB pathへ書く。当該bootでは`1-5`。

```sh
pkexec sh -c 'printf on > /sys/bus/usb/devices/1-5/power/control'
cat /sys/bus/usb/devices/1-5/power/control
```

期待値`on`。runtime変更なのでreboot後に失われる。

### 2. mSBC有効化

```ini
monitor.bluez.properties = {
  bluez5.enable-msbc = true
}
```

```sh
chezmoi apply ~/.config/wireplumber
```

`false`ではprofile名`headset-head-unit`がCVSDを指し、sinkは8kHz。音が出ても解決扱いしない。

### 3. XM5とWirePlumberのみ再初期化

PipeWire本体再起動は全clientを切りNoctalia/Discordの二次障害を作るため初手で行わない。

```sh
bluetoothctl disconnect 58:18:62:07:75:BD
systemctl --user restart wireplumber
```

WirePlumberのBlueZ endpoint登録後に接続する。早すぎると`a2dp-sink profile connect failed: Protocol not available`となりaudio cardが生成されなかった。

```sh
bluetoothctl connect 58:18:62:07:75:BD
pactl set-card-profile bluez_card.58_18_62_07_75_BD headset-head-unit
```

`bluez5.enable-msbc=true`時、`headset-head-unit`はmSBC、`headset-head-unit-cvsd`はCVSD。

### 4. application再列挙

順序はHFP確立、Noctalia再接続、Discord再起動。Discord先行では空device IDを保持し得る。

- `wpctl status`のClientsに`noctalia`がなければNoctaliaを再起動。
- Noctalia logで`pipewire connected`、`mixer-api ready`、`default-nodes-api ready`を確認。
- Discord streamsがなければDiscordを完全終了して起動。AudioService子processだけのkillでは復旧しなかった。
- Discordは完全再起動後に元の通話へ自動再接続した実績あり。常時保証はしない。

## 完了条件

以下を同時に満たすまで完了報告しない。

1. USB `power/control=on`。
2. XM5 Active Profile `headset-head-unit`、codec mSBC。
3. XM5 sink mono 16000Hz / RUNNING。
4. XM5 source存在 / RUNNING。
5. Discord `playStream` → XM5 playback / active。
6. Discord `recStream` ← XM5 capture / active。
7. Noctaliaに入出力device表示。
8. 35秒超監視してtransport error増加なし。
9. 利用者が通話音声、マイク、改善後音質を実聴確認。

録音経路だけなら次で検証可能。本事例では約12秒のWAVに非ゼロ音量を検出した。ただし録音成功だけではDiscord streamと通話受信を保証しない。

```sh
pw-record --target 'bluez_input.58:18:62:07:75:BD' <output.wav>
```

## 失敗した対応

- default sink/source変更のみ: 壊れたtransportは直らない。
- node存在だけで正常判断: error nodeや残留filterを誤認。
- A2DPのままマイク確認: XM5マイク利用不能。
- mSBC無効化: CVSDで一時通話可能だが音質要件外。
- PipeWire/Pulse/WirePlumber同時再起動: NoctaliaとDiscordがstale connection化。
- WirePlumber再起動直後の即接続: endpoint登録前でaudio card生成失敗。
- default変更後も既存stream維持と仮定: WirePlumberがChrome/Discord streamsも追従移動。
- Discord AudioService子processだけkill: 復旧せず。Discord本体完全再起動で復旧。
- `force_scofix`: 未適用。今回の確認済み修正ではない。

## 残件

`power/control=on`はruntimeのみ。reboot後に再発し得る。永続化はUSB pathでなく`0489:e0cd`をmatchするudev ruleが必要。ただし本セッションでは未実装・未検証。chezmoi管理外の`/etc`を直接編集せず、既存のsystem設定適用方式を確認して追加する。
