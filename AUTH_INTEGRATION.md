# Guía de Integración de Autenticación Real

## Estado Actual
- ✅ Arquitectura desacoplada con `AuthRepository` (contrato)
- ✅ `MockAuthRepository` funcionando (default)
- ✅ `ApiAuthRepository` stub listo para implementación
- ✅ Errores tipados con `AuthFailure` y mapeo a mensajes UI
- ✅ Selector de repositorio via `dart-define`
- ✅ Persistencia local de sesión con `shared_preferences`
- ✅ Auto-login al iniciar app (pantalla splash)

## Cómo Conectar Backend Real

### Paso 1: Implementar `ApiAuthRepository`
Abre [lib/data/repositories/api_auth_repository.dart](lib/data/repositories/api_auth_repository.dart) y reemplaza los stubs:

```dart
// Ejemplo: Firebase Auth
@override
Future<AuthSessionModel> login({
  required String email,
  required String password,
}) async {
  try {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user!;
    return AuthSessionModel(
      role: UserRole.estudiante, // inferir del backend
      userId: user.uid,
      userName: user.displayName ?? email,
      userPhoto: user.photoURL,
    );
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found' || e.code == 'wrong-password') {
      throw const AuthFailure(AuthFailureCode.invalidCredentials);
    } else if (e.code == 'network-request-failed') {
      throw const AuthFailure(AuthFailureCode.network);
    }
    throw AuthFailure(AuthFailureCode.server, message: e.message);
  }
}
```

### Paso 2: Cambiar a API en `main.dart`
```bash
flutter run --dart-define=USE_MOCK_AUTH=false
```

O edita [lib/main.dart](lib/main.dart#L18):
```dart
const useMockAuth = bool.fromEnvironment('USE_MOCK_AUTH', defaultValue: false);
```

### Paso 3: Agregar Headers/Tokens (si es REST)
En `ApiAuthRepository` constructor:
```dart
class ApiAuthRepository implements AuthRepository {
  final http.Client client;
  final String baseUrl;

  const ApiAuthRepository({
    this.client = const http.Client(),
    this.baseUrl = 'https://api.studyhub.com',
  });
}
```

### Paso 4: Mapear Respuestas Backend → `AuthSessionModel`
El contrato espera:
- `role`: UserRole (administrador, tutor, estudiante)
- `userId`: String
- `userName`: String
- `userPhoto`: String? (nullable)
- `userLocation`, `userPhone`: Strings

La UI automáticamente usa estos valores en sesiones, pagos, chat, reseñas.

## Errores Tipados Disponibles
| Código | Mensaje Default | Uso |
|--------|---|---|
| `invalidCredentials` | "Correo o contrasena invalidos" | Login fallido |
| `userAlreadyExists` | "Ya existe una cuenta con ese correo" | Registro duplicado |
| `network` | "Sin conexion. Revisa tu internet" | Timeout/no internet |
| `server` | "No pudimos autenticarte. Intenta nuevamente" | Error backend 5xx |
| `notImplemented` | "Autenticacion API aun no implementada" | Stub usado |
| `unknown` | "Ocurrio un error inesperado" | Fallo no clasificado |

## Testing Recomendado
1. `test/providers/auth_provider_test.dart` - Mock AuthRepository
2. `integration_test/auth_flow_test.dart` - Login → Home → Logout
3. Archivo `.env` o `build.gradle.kts` para `dart-define` en CI/CD

## Archivos Relacionados
- **Contrato**: [lib/data/repositories/auth_repository.dart](lib/data/repositories/auth_repository.dart)
- **Provider**: [lib/core/providers/auth_provider.dart](lib/core/providers/auth_provider.dart)
- **Errores**: [lib/data/models/auth_failure.dart](lib/data/models/auth_failure.dart)
- **Mock** (actual): [lib/data/repositories/mock_auth_repository.dart](lib/data/repositories/mock_auth_repository.dart)
- **API** (stub): [lib/data/repositories/api_auth_repository.dart](lib/data/repositories/api_auth_repository.dart)
- **Pantallas**: 
  - [lib/features/auth/views/login_screen.dart](lib/features/auth/views/login_screen.dart)
  - [lib/features/auth/views/register_screen.dart](lib/features/auth/views/register_screen.dart)

## Próximos Pasos (Optional)
- [ ] Refresh token + sesión expirada
- [ ] OAuth (Google, GitHub)
- [ ] Two-factor authentication
- [ ] Recuperación de contraseña
- [ ] Validación de email
