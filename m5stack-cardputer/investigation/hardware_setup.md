# M5Stack Cardputer v1.1 - Voice Assistant Configuration

## Hardware Specifications

### Audio Components
- **Microphone**: SPM1423 PDM MEMS microphone
  - DAT: GPIO46
  - CLK: GPIO43 (shared with I2S)
- **Speaker**: NS4168 mono amplifier
  - SDATA: GPIO42
  - BCLK: GPIO41
  - LRCLK: GPIO43 (shared with microphone CLK)

### Display
- **LCD**: ST7789V 1.14" 135x240 TFT
  - CS: GPIO37
  - DC: GPIO34  
  - RESET: GPIO33
  - CLK: GPIO36
  - MOSI: GPIO35
  - Backlight: GPIO38 (PWM controllable)

### Input
- **Button**: GPIO0 (boot button, pull-up)
- **Keyboard**: I2C matrix (not used in this config)

### Communication
- **WiFi**: ESP32-S3 built-in
- **I2C**: GPIO13 (SDA), GPIO15 (SCL) - for keyboard/expansion

## ESPHome Configuration Features

### Voice Assistant Pipeline
1. **Wake Word Detection**: `hey_jarvis` model (on-device)
2. **Speech-to-Text**: Via Home Assistant
3. **Intent Processing**: Home Assistant
4. **Text-to-Speech**: Via Home Assistant  
5. **Audio Output**: Local speaker

### Display States
- **Idle**: Black background, white "Esperando..." text
- **Listening**: Black background, green "Escuchando..." text
- **Thinking**: Black background, yellow "Procesando..." text
- **Replying**: Black background, blue "Respondiendo..." text
- **Error**: Red background, white "Error" text
- **Muted**: Black background, red "Micrófono silenciado" text

### Controls
- **Button Press**: Toggle microphone mute/unmute
- **Automatic**: Voice assistant starts when wake word detected
- **Visual Feedback**: Display shows current state

### Audio Configuration
- **Sample Rate**: 16kHz (microphone and speaker)
- **Bit Depth**: 16-bit
- **Channels**: Mono
- **PDM**: Enabled for microphone
- **Buffer**: 100ms for speaker

### Memory Optimizations
- **Framework**: ESP-IDF for better performance
- **Flash Size**: 8MB
- **Fonts**: Google Fonts (Roboto) with reduced glyph set
- **Images**: None (text-only display to save memory)

## Integration Requirements

### Home Assistant Setup
1. ESPHome integration enabled
2. Voice assistant component configured
3. STT service available (Whisper, Google, etc.)
4. TTS service available (any compatible engine)
5. Network connectivity to device

### WiFi Configuration
Update `secrets.yaml`:
```yaml
wifi_ssid: "YourWiFiName"
wifi_password: "YourWiFiPassword"
```

### Security Keys
Generate new keys for production:
```bash
esphome wizard m5stack-assistant.yaml
```

## Testing Checklist

### Basic Functionality
- [ ] Device boots and connects to WiFi
- [ ] Display shows "Esperando..." in idle state
- [ ] Button toggles mute/unmute status
- [ ] Backlight control works

### Audio Pipeline
- [ ] Say "hey jarvis" → display changes to "Escuchando..."
- [ ] Speak command → display shows "Procesando..."
- [ ] Response audio plays → display shows "Respondiendo..."
- [ ] Returns to idle state after response

### Error Handling
- [ ] WiFi disconnect shows error state
- [ ] HA disconnect shows error state
- [ ] Recovery after network restore

### Performance
- [ ] Wake word detection latency < 1s
- [ ] Audio quality acceptable
- [ ] No audio dropouts or distortion
- [ ] Memory usage stable over time
