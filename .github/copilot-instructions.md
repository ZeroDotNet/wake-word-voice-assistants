# Copilot Instructions for Wake Word Voice Assistants Repository

## Project Overview
This repository provides ESPHome YAML configurations for building wake-word enabled voice assistants on ESP32-based hardware like M5Stack Cardputer, ESP32-S3-Box, and others. It integrates with Home Assistant for voice processing, supporting on-device or HA-based wake word detection. Key goals: Optimize for low memory, provide display feedback, handle timers, and manage audio pipelines.

## Architecture
- **Hardware-Specific Folders**: Each device (e.g., `m5stack-cardputer/`) contains YAML files like `*.factory.yaml` for initial setups and customized versions (e.g., `m5stack-cardputer.demo.yaml`).
- **Data Flow**: Microphone captures audio → Wake word detection (micro_wake_word or HA) → Voice assistant processes STT/TTS → Speaker outputs response. Display updates via scripts based on phases (idle, listening, etc.).
- **Major Components**:
  - ESP32 board config with optimizations (e.g., sdkconfig_options for size reduction).
  - Audio: I2S for mic/speaker, resamplers/mixers for pipelines.
  - Display: ST7789V with pages for different states, using external images.
  - Voice Assistant: Handles phases, timers, errors; scripts manage state transitions.
- **Why Structured This Way**: Modular YAML allows easy customization per device; substitutions reuse common values like illustration URLs and colors.

## Key Files and Patterns
- **Substitutions**: Defined at top of YAML (e.g., `name`, `illustration_files`) for easy overrides. Example: `${loading_illustration_file}` pulls from GitHub.
- **Scripts**: Used for complex logic, e.g., `draw_display` switches pages based on `voice_assistant_phase` global.
- **Globals**: Track state like `init_in_progress` (bool) or `voice_assistant_phase` (int) with predefined IDs (e.g., `voice_assist_listening_phase_id: "2"`).
- **Voice Assistant Config**: `on_*` handlers update display/text sensors; supports switching wake word engines via select.
- **Optimizations**: sdkconfig_options reduce stack sizes, buffers; framework often uses ESP-IDF for better performance.

## Developer Workflows
- **Build and Flash**: Use ESPHome CLI in device folders, e.g., `esphome run --device /dev/ttyACM0 m5stack-cardputer.demo.yaml`. Secrets in `secrets.yaml`.
- **Testing**: Flash to device, monitor logs via ESPHome dashboard or HA integration. Test wake words, display updates, timer functionality.
- **Customization**: Copy base YAML, modify substitutions/scripts for new features (e.g., add new display pages in `display:` section).
- **Debugging**: Check `logger:` output; use `on_error` handlers for phase-specific issues. For audio, verify I2S pins match hardware.

## Conventions
- **Secrets Management**: WiFi/API/OTA passwords in `secrets.yaml`, referenced via `!secret`.
- **Phase Management**: Use integer globals for states; scripts like `start_wake_word`/`stop_wake_word` handle engine switching.
- **Display Patterns**: Pages use lambdas for dynamic content (e.g., drawing timer timelines with calculated pixels).
- **Dependencies**: Relies on ESPHome (ESP-IDF/Arduino), HA API, external GitHub assets for images/sounds. Install requirements from `m5stack-cardputer-requirements.txt` if needed.
- **Differences from Standard ESPHome**: Heavy use of custom scripts/globals for UI/VA integration; optimized for low-RAM devices via config tweaks.

Focus edits on maintaining modularity and optimization when adding features.
