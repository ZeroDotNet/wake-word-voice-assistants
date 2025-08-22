# Notas de Compilación - M5Stack Assistant

## Errores Encontrados y Solucionados

### 1. Variable `wake_word` no definida (Línea 190)
**Error original:**
```
m5stack-assistant.yaml:190:14: error: 'wake_word' was not declared in this scope; did you mean 'on_wake_word'?
```

**Solución:**
Cambié el script `on_wake_word` que intentaba usar una variable no disponible por la configuración directa del callback en `micro_wake_word`:
```yaml
micro_wake_word:
  id: mww
  models:
    - model: hey_jarvis
  on_wake_word_detected:
    - voice_assistant.start:
        wake_word: !lambda return wake_word;
```

### 2. Constantes de Color No Definidas
**Errores originales:**
```
error: 'GREEN' is not a member of 'esphome::Color'
error: 'YELLOW' is not a member of 'esphome::Color'
error: 'BLUE' is not a member of 'esphome::Color'
error: 'RED' is not a member of 'esphome::Color'
```

**Solución:**
Reemplacé las constantes por constructores RGB explícitos:
```yaml
Color(0, 255, 0)    # Verde (GREEN)
Color(255, 255, 0)  # Amarillo (YELLOW)
Color(0, 0, 255)    # Azul (BLUE)
Color(255, 0, 0)    # Rojo (RED)
```

### 3. Archivo de Font Inexistente
**Error original:**
Referencia a `"./fonts/Freedom.ttf"` que no existía.

**Solución:**
Eliminé la referencia al archivo local y dejé solo la fuente de Google Fonts:
```yaml
font:
  - file:
      type: gfonts
      family: Roboto
      weight: 300
    id: font_medium
    size: 16
```

## Configuración Final

### Pinout Confirmado
- **Micrófono SPM1423**: DAT=GPIO46, CLK=GPIO43
- **Altavoz NS4168**: SDATA=GPIO42, BCLK=GPIO41, LRCLK=GPIO43
- **Display ST7789V**: CS=GPIO37, DC=GPIO34, RESET=GPIO33, CLK=GPIO36, MOSI=GPIO35
- **Botón**: GPIO0 (con pull-up interno)

### Componentes Principales
1. **I2S Audio Bus**: Compartido entre micrófono y altavoz
2. **Micro Wake Word**: Modelo `hey_jarvis` para detección local
3. **Voice Assistant**: Integración con Home Assistant
4. **Display**: 6 páginas diferentes para estados del asistente
5. **Button Control**: Alternar mute con botón físico

### Resultados de Compilación
- **RAM**: 11.5% utilizada (37,540 de 327,680 bytes)
- **Flash**: 29.6% utilizada (1,164,750 de 3,932,160 bytes)
- **Tiempo de compilación**: 82.89 segundos
- **Archivo generado**: `firmware.factory.bin` listo para flashear

## Próximos Pasos
1. Probar el firmware en hardware real
2. Verificar funcionamiento del micrófono PDM
3. Confirmar audio bidireccional
4. Ajustar sensibilidad y volúmenes
5. Personalizar wake words si es necesario
