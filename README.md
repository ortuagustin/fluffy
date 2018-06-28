# Trabajo integrador TTPS-Ruby-2017
## Fluffy

Este proyecto consiste en una aplicacion web para gestionar cursos: se pueden administrar las distintas cursadas, los alumnos que se inscriben a las mismas, las instancias de evaluación del curso y las calificaciones obtenidas por los alumnos. A su vez, cada curso cuenta con un foro el cual permite publicar temas, suscribirse y recibir notificaciones, marcar las mejores respuestas, dar like/dislike a los posts, entre otras cuestiones.


### Preparando el ambiente:

#### Requisitos previos:
  El proyecto utiliza [ElasticSearch](https://www.elastic.co/products/elasticsearch) para implementar la funcionalidad de búsqueda de los posts de los foros de cada curso

  >ElasticSearch requiere Java 8

  >Para instalar ElasticSearch, lo mejor es referirse a su [documentación](https://www.elastic.co/guide/en/elasticsearch/reference/current/_installation.html). Para sistemas basados en Debian, se puede [usar un paquete o instalarlo por APT](https://www.elastic.co/guide/en/elasticsearch/reference/current/deb.html)

  Tambien se requiere, para poder utilziar [Webpacker](https://github.com/rails/webpacker):
    - Node.js 6.0.0+
    - Yarn 0.25.2+

#### Ambiente Ruby

* Versión de Ruby: el proyecto se dessarrolló usando ruby 2.4.1p111 (2017-03-22 revision 58053), pero deberia ser compatible con cualquier ruby 2.4.x
* Dependencias: Como en la mayoria de los proyectos Rails, son gestionadas usando [Bundler](https://github.com/bundler/bundler). Las mas destacadas son:
  - [Rails 5.1.4](https://github.com/rails/rails/)
  - [Validates](https://github.com/kaize/validates/)
  - [Faker](https://github.com/stympy/faker)
  - [Contracts](https://github.com/egonSchiele/contracts.ruby)
  - [Devise](https://github.com/plataformatec/devise)
  - [Pundit](https://github.com/varvet/pundit)
  - [acts_as_votable](https://github.com/ryanto/acts_as_votable)
  - [FontAwesome](https://github.com/bokmann/font-awesome-rails)
  - [Kaminari](https://github.com/kaminari/kaminari)
  - [friendly_id](https://github.com/norman/friendly_id)
  - [Bulma](https://bulma.io)
  - [ElasticSearch-Rails](https://github.com/elastic/elasticsearch-rails)
  - [ElasticSearch-Model](https://github.com/elastic/elasticsearch-rails/tree/master/elasticsearch-model)
  - [Webpacker](https://github.com/rails/webpacker)
  - **PostgreSQL** para producción; **SQLite3** para desarrollo y tests

1. Clonar el repositorio:

```bash
  git clone https://github.com/ortuagustin/fluffy.git
  cd fluffy
```

2. Ejecutar bundler para instalar las dependencias de Ruby:

```bash
  bundle
```

> En desarrollo no es necesario instalar **postgres**: `bundle install --without production`

3. Ejecutar yarn para instalar las dependencias de JavaScript:

```bash
  yarn install
```

4. Es posible que se necesiten dependencias adicionales para las bases de datos; en sistemas linux, se debe
   - SQLite (desarrollo y tests):

    ```bash
      apt install sqlite3
      apt install libsqlite3-dev
    ```
   - PostgreSQL (producción):

    ```bash
      apt install libpq-dev
    ```

5. Configurar la base de datos:
  - Para crear la BD, ejecutar: `rails db:migrate`
  - Para inicializar la BD con los *seeds*, es decir, un set de datos inicial, ejecutar `rails db:seed`
  - Para indizar en ElasticSearch los posts creados en el seed, ejecutar `bundle exec rake environment elasticsearch:import:model CLASS='Post'`

6. Se utiliza [Webpacker](https://github.com/rails/webpacker) para los assets utilizados en el frontend; correr en el directorio raiz del proyecto:

    ```bash
      ./bin/webpack
    ```

5. Ejecución: Correr el servidor: `rails s` y acceder a la [aplicación](http://localhost:3000). Los usuarios que se crean con los seeds son:
  - user: admin, password: admin. Este usuario tiene el rol "ADMIN"
  - user: guest, password: guest. Este usuario tiene el rol "GUEST"

  - El rol ADMIN es el unico que puede poner los posts como "sticky" (destacado o anclado)
  - Solo los "dueños" de los post (es decir, los creadores), pueden elegir cual es la mejor respuesta del mismo
  - Los usuarios pueden suscribirse a las notificaciones de cualquier post (por defecto se suscribe automaticamente al creador de los posts)
  - Los usuarios que no crearon un post/respuesta pueden dar like/dislike a un post/respuesta

6. Para correr los tests: `rails t`

### Heroku

Ésta aplicación fue desplegada a la plataforma [Heroku](http://heroku.com), podés verla siguiendo [este link](https://fluffy-app.herokuapp.com/). Si no querés registrarte, podes ingresar con el usuario `admin`, `admin` :)

>La aplicacion no funciona en Heroku porque depende de ElasticSearch, y es un servicio que si bien se puede integrar de manera gratuita, Heroku exige que la cuenta tenga vinculada una tarjeta de credito para agregar este paquete. Por lo tanto, la aplicacion **no funciona en Heroku**
