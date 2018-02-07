# Este modulo me permite definir metodos para las relaciones 'tests' y 'students' que acepten
# un Hash con parametros para filtrar y ordenar los resultados
# Necesito mantener los metodos originales creados por ActiveRecord (sin parametros) porque son los encargados
# de precargar (ie, eager-loading) las relaciones y evitar problemas de N+1 queries
# La solucion "no tan hack" (es decir, no 'esta') seria tener todos metodos separados que llamen a los
# metodos de las relaciones, por ej:
#
# class Course < ApplicationRecord
#   has_many :students, dependent: :destroy
#   has_many :tests, dependent: :destroy
#
#   def students_with_options(options = {})
#     keyword = options[:keyword]
#     order = options[:order] || 'surname'
#     students.order(order).search(keyword)
#   end
# end
#
# Pero me parecio que lo mas intuitivo era seguir llamando los metodos "de toda la vida" y que sea transparente
# Intente con esta implementacion, que si bien funciona, me lleva al problema de los N+1 queries
#   def students_with_options(options = {})
#     keyword = options[:keyword]
#     order = options[:order] || 'surname'
#     super().order(order).search(keyword)
#   end

module CourseWithSearchableAssociations
  # la gema Contracts me permite definir lo que en otros lenguajes se llamarian "metodos sobrecargados",
  # es decir, mismo nombre, pero distintos parametros. De acuerdo a los parametros enviados al metodo
  # en tiempo de ejecucion, se determina que "sobrecarga" se invoca
  include Contracts

  # en este caso invocamos al metodo original definido por ActiveRecord
  Contract None => ActiveRecord::Relation
  def students
    super
  end

  # en este caso el metodo acepta "opciones" para personalizar el query
  # delega en el 'students' a secas, sin argumentos
  # el metodo search esta definido en el modulo Searchable: app/models/concerns/searchable.rb
  Contract Hash => ActiveRecord::Relation
  def students(options = {})
    keyword = options[:keyword]
    order = options[:order] || 'surname'
    students.order(order).search(keyword)
  end

  Contract None => ActiveRecord::Relation
  def tests
    super
  end

  Contract Hash => ActiveRecord::Relation
  def tests(options = {})
    keyword = options[:keyword]
    order = options[:order] || 'evaluated_at'
    tests.order(order).search(keyword)
  end
end

Course.include(CourseWithSearchableAssociations)