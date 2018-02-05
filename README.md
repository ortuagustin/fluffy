# Trabajo integrador TTPS-Ruby-2017
## Fluffy

Este proyecto consiste en una aplicacion web para gestionar cursos: se pueden administrar las distintas cursadas, los alumnos que se inscriben a las mismas, las instancias de evaluación del curso y las calificaciones obtenidas por los alumnos.


### Preparando el ambiente:
* Versión de Ruby: el proyecto se dessarrolló usando ruby 2.4.1p111 (2017-03-22 revision 58053), pero deberia ser compatible con cualquier ruby 2.4.x
* Dependencias: Como en la mayoria de los proyectos Rails, son gestionadas usando [Bundler](https://github.com/bundler/bundler). Las mas destacadas son:
  - [Rails 5.1.4](https://github.com/rails/rails/)
  - [Validates](https://github.com/kaize/validates/)
  - [Faker](https://github.com/stympy/faker)
  - [Contracts](https://github.com/egonSchiele/contracts.ruby)
  - [Devise](https://github.com/plataformatec/devise)
  - [FontAwesome](https://github.com/bokmann/font-awesome-rails)
  - [Kaminari](https://github.com/kaminari/kaminari)
  - [Bulma](https://bulma.io)
  - **PostgreSQL** para producción; **SQLite3** para desarrollo y tests

1. Clonar el repositorio:

```bash
  git clone https://github.com/ortuagustin/fluffy.git
  cd fluffy
```

2. Ejecutar bundler para instalar las dependencias:

```bash
  bundle
```

3. Es posible que se necesiten dependencias adicionales para las bases de datos; en sistemas linux, se debe
   - SQLite (desarrollo y tests):

    ```bash
      apt install sqlite3
      apt install libsqlite3-dev
    ```
   - PostgreSQL (producción):

    ```bash
      apt install libpq-dev
    ```

4. Configurar la base de datos:
  - Para crear la BD, ejecutar: `rails db:migrate`
  - Para inicializar la BD con los *seeds*, es decir, un set de datos inicial, ejecutar `rails db:seed`

5. Ejecución: Correr el servidor: `rails s` y acceder a la [aplicación](http://localhost:3000)

6. Para correr los tests: `rails t`

### Heroku

Ésta aplicación fue desplegada a la plataforma [Heroku](http://heroku.com), podés verla siguiendo [este link](https://fluffy-app.herokuapp.com/). Si no querés registrarte, podes ingresar con el usuario `admin`, `admin` :)
