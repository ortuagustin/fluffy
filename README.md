# Trabajo integrador TTPS-Ruby-2017
## Fluffy Server

Este proyecto consiste en una API REST que sirve como backend para un sistema de gestión de cursos. Permite administrar diferentes cursadas, los alumnos que se inscriben, las distintas instancias de evaluación y las calificaciones obtenidas

Para el proyecto que implementa un frontend consumiendo esta API, ver [Fluffy Client](https://github.com/ortuagustin/fluffy-client)

### Preparando el ambiente:
* Versión de Ruby: el proyecto se dessarrolló usando ruby 2.4.1p111 (2017-03-22 revision 58053), pero deberia ser compatible con cualquier ruby 2.4.x
* Dependencias: Como en la mayoria de los proyectos Rails, son gestionadas usando [Bundler](https://github.com/bundler/bundler). Las mas destacadas son:
  - [Rails 5.1.4](https://github.com/rails/rails/)
  - [Validates](https://github.com/kaize/validates/)
  - [Faker](https://github.com/stympy/faker)
  - [Contracts](https://github.com/egonSchiele/contracts.ruby)
  - PostgreSQL para producción; SQLite3 para desarrollo y tests

1. Clonar el repositorio:

```bash
  git clone https://github.com/ortuagustin/fluffy-server.git
  cd fluffy-server
```

2. Ejecutar bundler para instalar las dependencias:

```bash
  bundle
```

3. En producciòn, la aplicación utiliza variables de entorno:
   - `DATABASE_URL`: se utiliza para conectar a la BD PostgreSQL

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

6. Ejecución: Correr el servidor: `rails s` y acceder a la [aplicación](http://localhost:3000)

7. Correr los tests:
  - `rails test` ejecutará todos los tests de unidad (modelos) y de funcionales (controladores)
  - `rails test test/models` ejecutará sólo los test de unidad (modelos)
  - `rails test test/controllers` ejecutará sólo los test funcionales (controladores)

### Heroku

Ésta aplicación fue desplegada a la plataforma [Heroku](http://heroku.com), podés verla siguiendo [este link](https://fluffy-app-server.herokuapp.com/)
