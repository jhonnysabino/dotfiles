---
name: whatsapp-voice-note
description: Send WhatsApp native voice notes using wacli, MiniMax TTS, Opus OGG conversion, and strict user confirmation.
triggers:
  - WhatsApp voice note
  - send WhatsApp audio
  - send voice message
  - enviar áudio no WhatsApp
  - enviar mensagem de voz
---

# WhatsApp Voice Note

Send WhatsApp voice notes using MiniMax TTS, FFmpeg Opus conversion, and `wacli`.

## ⚠️ NON-NEGOTIABLE PERMISSION RULE

Always ask before sending any WhatsApp message:

[mensagem]
Posso enviar mensagem para [pessoa]?

Never send without explicit confirmation.

WhatsApp messages are irreversible.

## Required workflow

1. Identify the recipient.
2. Write the FULL message text in Portuguese.
3. Show the full text to the user.
4. Ask:

Posso enviar mensagem para [pessoa]?

5. Only after approval:
   - **Cleanup:** remove any stale temp files
     ```bash
     rm -f /tmp/voice.mp3 /tmp/voice.ogg
     ```
   - generate MP3 with MiniMax TTS (output: `/tmp/voice.mp3`)
   - **Verify MP3 freshness:** confirm file was just created (mtime < 10s ago)
     ```bash
     python3 -c "import os,time; p='/tmp/voice.mp3'; t=os.path.getmtime(p); assert time.time()-t<10, 'STALE MP3 — do not use'; print(f'Fresh: {os.path.getsize(p)}B')"
     ```
   - convert MP3 to OGG/Opus (mono 48kHz, `-application voip`)
   - send with `wacli send file --to <jid> --file /tmp/voice.ogg --ptt`

## Known contacts (via env vars)

Carregados do `~/.bashrc` — não hardcoded.

Jhonny (Eu): `$WA_SELF_JID`
Namorada (Cintia): `$WA_GIRLFRIEND_JID`
Mother (Ana): `$WA_MOTHER_JID`
Father (João): `$WA_FATHER_JID`

## Voice rules

- To Jhonny/self chat: `Portuguese_Solemn_Narrator_v1`
- To other people: `jhonny_voice`

## Speed defaults (per voice)

- `jhonny_voice`: **speed 1.4** (calibrado via teste empírico)
- `Portuguese_Solemn_Narrator_v1`: speed 1.0
- Se usuário pedir speed específica, usar a solicitada.

Consulte `minimax-tts` skill para detalhes completos.

## Step 1: Generate MP3

Use the `minimax-tts` skill.

Expected output:

/tmp/voice.mp3 (must be freshly created)

**Before calling:** delete any existing `/tmp/voice.mp3` to guarantee freshness.

**After calling:** verify mtime is within last 10 seconds. If stale, abort.

## Step 2: Convert MP3 → WhatsApp voice note (OGG/Opus)

Must use these exact params for native voice note compatibility:

```bash
ffmpeg -i /tmp/voice.mp3 \
  -ar 48000 \
  -ac 1 \
  -c:a libopus \
  -b:a 32k \
  -vbr on \
  -application voip \
  /tmp/voice.ogg -y
```

Rationale:
- `-ar 48000`: Opus native sample rate
- `-ac 1`: mono (WhatsApp voice notes are mono)
- `-application voip`: optimizes Opus for speech (not `audio`)

## Step 3: Send using wacli (with --ptt flag)

**Critical:** Use `--ptt` flag to send as native voice note with waveform.

```bash
wacli send file --to "<jid>" --file /tmp/voice.ogg --ptt
```

Example:

```bash
wacli send file --to "$WA_SELF_JID" --file /tmp/voice.ogg --ptt
```

The `--ptt` flag:
1. Sets `PTT: true` on the AudioMessage
2. Computes `Seconds` (duration) via ffprobe
3. Generates `Waveform` (64 bytes, 0-100 scale) matching Baileys algorithm

Without `--ptt`, the audio arrives as a file attachment (no waveform).

## Waveform generation details

The `--ptt` flag triggers internal waveform generation:

**Algorithm (Baileys-compatible):**
1. Decode OGG to PCM (mono, 16kHz, s16le) via ffmpeg
2. Split into 64 equal blocks
3. For each block: average of absolute sample values
4. Normalize: divide each block by global max
5. Scale to 0-100: `floor(normalized * 100)`
6. Set as `Waveform` bytes on AudioMessage
7. Set `Seconds = round(duration)` from ffprobe

**Expected protobuf structure:**

```
AudioMessage {
  url: "...",
  mimetype: "audio/ogg; codecs=opus",
  fileSha256: [...],
  fileLength: ...,
  seconds: <duration_seconds>,
  ptt: true,
  mediaKey: [...],
  fileEncSha256: [...],
  directPath: "...",
  waveform: <64_bytes_0_to_100>
}
```

## Known issue: wacli store lock

`wacli sync --follow` keeps the store locked. Kill it before sending:

```bash
pkill -f "wacli sync"
```

Or use `--lock-wait 120s` for waiting.

## Safety rules

Never:

* send unreviewed text
* send generated audio without approval
* send any WhatsApp message without explicit confirmation
* reuse old audio files from /tmp — always freshly generate and verify mtime
