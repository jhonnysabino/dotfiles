---
name: minimax-tts
description: Generate Portuguese speech audio using MiniMax T2A API.
triggers:
  - MiniMax TTS
  - MiniMax text to audio
  - Portuguese TTS
  - generate speech audio
---

# MiniMax TTS

Generate MP3 speech audio using MiniMax Text-to-Audio API.

## Output path rule (critical)

**Never use a fixed output path.** The caller must specify the output path.
Always accept the output path as a parameter and pass it explicitly.
This prevents stale files from being reused when generation fails silently.

## Endpoint

```http
POST https://api.minimax.io/v1/t2a_v2
````

## Required headers

```json
{
  "Authorization": "Bearer <API_KEY>",
  "Content-Type": "application/json"
}
```

## Correct request body

```json
{
  "model": "speech-2.8-hd",
  "text": "Texto em português aqui",
  "stream": false,
  "voice_setting": {
    "voice_id": "Portuguese_Solemn_Narrator_v1",
    "speed": 1,
    "vol": 1,
    "pitch": 0
  },
  "audio_setting": {
    "sample_rate": 32000,
    "bitrate": 128000,
    "format": "mp3",
    "channel": 1
  },
  "subtitle_enable": false
}
```

## Critical rules

* `voice_id` must be inside `voice_setting`.
* Do not put `voice_id` at the top level.
* Do not include `emotion`.
* Do not include `voice_modify`.
* Use `sample_rate: 32000`.
* Use `bitrate: 128000`.
* Use `format: "mp3"`.
* Use `channel: 1`.
* Use Portuguese text only when generating Portuguese audio.
* **Delete existing file** at the output path before making the API call.
* **Verify generation succeeded** — check `stat` that mtime is within last 10 seconds.
  ```bash
  # After generation:
  python3 -c "import os,time; p='/tmp/voice.mp3'; t=os.path.getmtime(p); assert time.time()-t<10, f'File too old: {time.time()-t:.0f}s'; print(f'Fresh: {os.path.getsize(p)}B')"
  ```
* If the file is stale or missing, abort — do NOT reuse old files.

## Recommended Portuguese voices

```txt
Portuguese_Solemn_Narrator_v1
jhonny_voice
```

## Voice selection rules

* For Jhonny/self chat: `Portuguese_Solemn_Narrator_v1`
* For other people: `jhonny_voice`
* If user explicitly asks for another voice, use the requested voice.

## Speed defaults (per voice)

* `jhonny_voice`: **speed 1.4** (calibrado via teste empírico — melhor custo-benefício entre naturalidade e velocidade)
* `Portuguese_Solemn_Narrator_v1`: speed 1.0
* Qualquer outra voz: speed 1.0
* Se usuário pedir speed específica, usar a solicitada.

## Python example

```python
import os, time, requests, binascii

api_key = "YOUR_API_KEY"
output_path = "/tmp/voice.mp3"  # caller must supply this

# 1. Delete stale file first
if os.path.exists(output_path):
    os.remove(output_path)

# 2. Generate
response = requests.post(
    "https://api.minimax.io/v1/t2a_v2",
    headers={
        "Authorization": f"Bearer {api_key}",
        "Content-Type": "application/json",
    },
    json={
        "model": "speech-2.8-hd",
        "text": "Texto em português aqui",
        "stream": False,
        "voice_setting": {
            "voice_id": "Portuguese_Solemn_Narrator_v1",
            "speed": 1,
            "vol": 1,
            "pitch": 0,
        },
        "audio_setting": {
            "sample_rate": 32000,
            "bitrate": 128000,
            "format": "mp3",
            "channel": 1,
        },
        "subtitle_enable": False,
    },
)

data = response.json()
audio_hex = data["data"]["audio"]
audio_bytes = binascii.unhexlify(audio_hex)

with open(output_path, "wb") as f:
    f.write(audio_bytes)

# 3. Verify freshness
age = time.time() - os.path.getmtime(output_path)
try:
    assert age < 10, f"Output file is {age:.0f}s old — not freshly generated"
    print(f"OK {os.path.getsize(output_path)} bytes, {age:.0f}s old")
except AssertionError as e:
    print(f"FAIL: {e}")
    sys.exit(1)
```

## Common errors

### `invalid params, empty field`

Usually means one of these:

* `voice_id` was placed outside `voice_setting`
* `voice_id` does not exist
* required field is empty

### `invalid api key`

Usually wrong API key or wrong endpoint.

Use:

```txt
https://api.minimax.io/v1/t2a_v2
```

### Audio settings rejected

MiniMax may reject unsupported values.

Use:

```json
{
  "sample_rate": 32000,
  "bitrate": 128000,
  "format": "mp3",
  "channel": 1
}
```