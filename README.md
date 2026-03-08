# StudyHub - TutoríasApp

Aplicación móvil en Flutter que conecta estudiantes con tutores para agendar clases particulares.

## Comenzar

### Requisitos

- Flutter SDK instalado
- Un emulador Android o dispositivo físico

### Instalación

```bash
flutter pub get
flutter run
```

## Credenciales de prueba

La app usa datos mock (ficticios). Para iniciar sesión y explorar las interfaces, usa las siguientes credenciales en la pantalla de login. La contraseña puede ser cualquier texto.

### Iniciar como Estudiante

| Campo    | Valor              |
|----------|--------------------|
| Correo   | `juan@email.com`   |
| Contraseña | cualquier texto  |

Esto te lleva al panel de **Estudiante**, donde puedes:
- Ver tutores destacados
- Buscar tutores por materia
- Ver historial de clases
- Acceder al chat
- Editar tu perfil

### Iniciar como Tutor

Usa cualquiera de estos correos:

| Correo               | Tutor               |
|----------------------|----------------------|
| `maria@email.com`   | María García López   |
| `carlos@email.com`  | Carlos Rodríguez     |
| `ana@email.com`     | Ana Martínez         |
| `diego@email.com`   | Diego López          |
| `laura@email.com`   | Laura Sánchez        |

Esto te lleva al panel de **Tutor**, donde puedes:
- Ver tu dashboard con estadísticas
- Gestionar horarios disponibles
- Ver historial de sesiones
- Acceder al chat con estudiantes
- Editar tu perfil profesional

### Cerrar sesión

En ambos roles, ve a la pestaña **Perfil** y presiona el botón **Cerrar Sesión** para volver al login.
