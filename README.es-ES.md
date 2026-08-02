

# L4N

[![CI check](https://github.com/Adrian-Hirt/l4n/actions/workflows/ci.yml/badge.svg)](https://github.com/Adrian-Hirt/l4n/actions/workflows/ci.yml)
[![Edge docker image](https://github.com/Adrian-Hirt/l4n/actions/workflows/build_edge_docker.yml/badge.svg)](https://github.com/Adrian-Hirt/l4n/actions/workflows/build_edge_docker.yml)
[![License: AGPL v3](https://img.shields.io/badge/License-AGPL_v3-blue.svg)](https://www.gnu.org/licenses/agpl-3.0)

**El README está en proceso de desarrollo, por favor contacta a los mantenedores si tienes alguna pregunta**

L4N es un CMS para gestionar fiestas LAN, que cuenta con un sistema de tickets, mapas de asientos, horarios, un sistema de torneos, una tienda, publicaciones de noticias,
eventos recurrentes y más!

## Características

* Sistema de tickets con escáner de códigos QR para el registro en el evento
* Tienda de propósito general para vender tickets, mercancía, comida, etc.
* Sistema de torneos que puede utilizarse de forma independiente a una fiesta LAN
* Sistema de noticias / blog con soporte para Markdown
* Eventos paralelos con múltiples fechas
* Páginas de contenido dinámico y redirecciones de URL
* Menú de navegación superior totalmente personalizable
* Logros
* Carga de archivos
* CSS personalizable en el panel de administración
* Página de inicio dinámica con bloques de contenido personalizables y banners de portada
* Barra lateral con infoboxes personalizables
* Banderas de características (feature flags) para desactivar funcionalidades innecesarias
* API JSON para obtener datos desde el CMS
* Proveedor OAuth2

## Requisitos

* [Docker Compose](https://docs.docker.com/compose/)

## Instalación

Recomendamos utilizar el archivo `docker-compose.yml` incluido para desplegar la aplicación con [docker compose](https://docs.docker.com/compose/).
A continuación se muestran los pasos necesarios para desplegar la aplicación de esta manera:

### Instalar Docker

Primero, deberás instalar `docker` y `docker-compose` en tu servidor. Sigue las [guías de instalación oficiales](https://docs.docker.com/get-docker/)
de tu sistema para hacerlo.

### Configurar Traefik

La configuración de docker compose proporcionada utiliza Traefik como proxy inverso y para configurar automáticamente tus certificados SSL.
Sugerimos utilizar [esta configuración](https://github.com/conscribtor/docker-traefik-letsencrypt) en tu servidor. Despliega
la configuración de Traefik en una carpeta separada en tu servidor, siguiendo las instrucciones detalladas en su repositorio.

### Configurar L4N

Primero, crea una nueva carpeta para la configuración de L4N en tu servidor.
Crea un archivo `.env` y añade las variables de entorno requeridas junto con sus valores. Consulta el archivo  `DEVELOPMENT.md` para obtener una lista completa de todas las variables de entorno.
Las variables necesarias pueden variar según tu configuración y necesidades.

Después, copia el archivo `docker-compose.yml` a tu servidor. Por defecto, utilizará la etiqueta `main` de la
imagen, que es la variante edge con los commits más recientes de la rama principal. Recomendamos utilizar una versión etiquetada,
y por lo tanto debes reemplazar `main` con la etiqueta de la última versión estable.

Posteriormente, puedes iniciar L4N usando `docker compose up -d`. Esto descargará la imagen, creará la base de datos,
ejecutará las migraciones y preparará otras configuraciones necesarias para L4N.

### Crear el primer usuario

L4N incluye un script útil para crear el primer usuario desde la CLI. Este usuario tiene permisos para editar
usuarios, y por lo tanto puedes utilizarlo para iniciar sesión en el panel de administración, otorgarle a ese usuario los demás
permisos requeridos y modificar la configuración de L4N.

Para ejecutar este script, simplemente ejecuta la tarea `rake setup:user` desde la línea de comandos, o si estás utilizando
la imagen de Docker, ejecuta lo siguiente:

```bash
docker exec -it <container_name> rake setup:user
```

donde `<container_name>` es el nombre del contenedor, usualmente `l4n-web-1`.

### Instalaciones personalizadas

L4N también puede utilizarse en una configuración personalizada, con tu propio archivo docker compose. Sin embargo, ten en cuenta que L4N requiere PostgreSQL como servidor de base de datos de la aplicación. Actualmente no es posible utilizar SQLite, MySQL ni ninguna otra base de datos como servidor para la aplicación.
Además, ten en cuenta que en modo de desarrollo, la aplicación requiere SSL, ya que
solo se aceptan conexiones a través de SSL, está habilitado Strict-Transport-Security y las cookies
están marcadas como seguras.

## Comandos útiles

A veces, puede resultar útil tener algunos comandos de CLI a mano. Aunque la mayoría de la configuración de L4N puede ajustarse en el panel de administración o en el archivo `.env` (o variables de entorno, si no usas el archivo docker-compose), en ocasiones podrías necesitar acceder a los archivos de registro, a la consola de Rails o a otra cosa, por lo que aquí tienes algunos comandos útiles:

| Tarea                             | Comando en el contenedor L4N      | Comando desde el host                                              |
| --------------------------------- | --------------------------------- | ------------------------------------------------------------------ |
| Reiniciar el servidor web (puma)  | `touch /app/tmp/restart.txt`      | `docker exec <container_name> touch /app/tmp/restart.txt`          |
| Acceder a la consola de Rails     | `rails c`                         | `docker exec -it <container_name> rails c`                         |
| Leer los registros en tiempo real | `tail -f /app/log/production.log` | `docker exec -it <container_name> tail -f /app/log/production.log` |

## Desarrollo

### Configuración

Para desarrollar características de L4N localmente, recomendamos instalar Ruby y Postgres de forma local:

1. Instala Ruby en tu máquina (recomendamos usar [RVM](https://rvm.io/) para gestionar tus instalaciones de Ruby). Consulta el archivo `.ruby-version` para conocer la versión exacta de Ruby (RVM te informará si te falta la versión requerida).
2. Instala Postgres en tu máquina y crea un usuario con nombre `rails` y una base de datos `l4n` para que la aplicación se conecte. Consulta `config/database.yml` para más información.
3. Instala yarn en tu máquina (https://yarnpkg.com/getting-started/install)
4. Clona el repositorio de L4N en tu máquina y accede a este directorio con `cd`.
5. Instala todas las dependencias:
   ```bash
   # Install Ruby gems
   bundle install

   # Install yarn packages
   yarn
   ```
6. Crea el archivo `config/application.yml` con las variables de entorno requeridas de la siguiente manera. Puedes establecer valores ficticios si no deseas usar la pasarela de pago de PayPal o reCAPTCHA localmente, reemplazando los marcadores de posición entre corchetes con valores aleatorios:
   ```yaml
   paypal_id: <your-paypal-id>
   paypal_secret: <your-paypal-secret>
   recaptcha_site_key: <your-recaptcha-site-key>
   recaptcha_site_secret: <your-recaptcha-site-key>
   ```
7. Para iniciar el servidor localmente, usa el comando `bin/dev`, que iniciará el servidor de Rails junto con un proceso de compilación de JS y CSS


### Estilo de código

Para garantizar un estilo de código consistente, utilizamos los siguientes analizadores/linters de código:

* [rubocop](https://github.com/rubocop/rubocop) para los archivos fuente de Ruby
* [haml-lint](https://github.com/sds/haml-lint) para los archivos de vista haml
* [eslint](https://eslint.org/) para los archivos fuente de JavaScript

Cuando quieras contribuir a este proyecto, asegúrate de que ninguna de estas 3 herramientas encuentre problemas en tu código (y si lo hacen, sigue las sugerencias indicadas para resolverlos).

## Usuarios

* [VSETH GECo](https://geco.ethz.ch)

¿Usas L4N? ¡Infórmanos y te añadiremos a esta lista!
