# = foldable.rb
#
# Autor::   Jean Alexander 12-10848 y Diego Pedroza 12-11281
#
# == Mixin de Foldable
#
# El objetivo de esta tarea es aplicar los conocimientos de Mixins al 
# implementar un comportamiento parecido a Data.Foldable de Haskell.

# === Module Foldable
#
# Mixin Foldable que requiere que la clase tenga implementado el método foldr.
# 
# Está compuesta por los siguientes métodos:
# * Método null
# * Método foldr1
# * Método length
# * Método all? 
# * Método any?
# * Método to_arr
# * Método elem?

module Foldable
	# Método null
	# 
	# Regresa true si la estructura de datos está vacía
	# o false, en caso contrario
	def null
		self.foldr(true) {|x,y| false}
	end
	
	# Método foldr1
	#
	# Parecido al método foldr pero usando el primer elemento como el elemento
	# neutro y hace el recorrido sobre el resto de la estructura
	#
	def foldr1 &block
		
		if self.is_a? Array then
			if self == [] then
				begin
					raise 'foldr1: empty structure'
				rescue => e
					puts e.message
				end
			else
				self[1..-1].foldr self[0], &block
			end
		else
			if self.is_a? Rose then
				result = self.elem
				self.children.reverse_each {|tree| result = tree.foldr result, &block}
				result
			end
		end
	end
	
	# Método length
	#
	# Indica el tamaño de la estructura de datos, o, mejor dicho, la
	# cantidad de elementos que contiene.
	#
	def length
		self.foldr(0) {|x,y| 1 + y}
	end
	
	# Método all?
	#
	# Indica si todos los elementos de una estructura cumplen con un predicado.
	#
	def all? &block
		self.foldr(true) {|x,y| block.call(x) && y}
	end
	
	# Método any?
	#
	# Indica si alguno (1 o más) de los elementos de una estructura 
	# cumplen con un predicado.
	#
	def any? &block
		self.foldr(false) {|x,y| block.call(x) || y}
	end
	
	# Método to_arr
	#
	# Construye una nueva instancia de la clase Array con todos los elementos 
	# contenidos, en orden de izquierda a derecha.
	#
	def to_arr
		self.foldr([]) {|x,y| [x] + y}
	end
	
	# Método elem?
	#
	# que indica si un elemento se encuentra en la estructura, comparando 
	# elementos con ==.
	#
	def elem? to_find
		self.any? {|x| x == to_find}
	end
end

# === Class Array
#
# Añadiendo a la clase Array, el comportamiento Foldable y la función foldr.
# 
class Array
include Foldable
	# Método foldr
	# 
	# Que recibe un caso base y un bloque que será utilizado para recorrer
	# la lista haciendo un pliegue de derecha a izquierda aplicando
	# el bloque recibido.
	#
	def foldr e, &b
		result = e
		self.reverse_each {|elem| result = b.call(elem,result)}
		result
	end
end

# === Class Rose
#
# Implementación de árboles multicamino (Rose Tree).
# Incluye el comportamiento Foldable.
# 
# Los métodos que lo componen son:
# * Método add
# * Método avg
class Rose
include Foldable
	# * elem -> elemento del árbol
	attr_accessor :elem
	# * children -> arreglo de árboles hijos
	attr_accessor :children
	
	# Método para inicializar
	def initialize elem, children = []
		@elem = elem
		@children = children
	end
	
	# Método add
	# 
	# Que añade un elemento.
	#
	def add elem
		@children.push elem
		self
	end
	
	# Método foldr
	# 
	# Que recibe un caso base y un bloque que será utilizado para recorrer
	# el árbol haciendo un pliegue de derecha a izquierda aplicando el bloque
	# recibido.
	#
	def foldr e, &b
		result = e
		self.children.reverse_each {|tree| result = tree.foldr result, &b}
		b.call(self.elem,result)
	end
	
	# Método avg
	#
	# Devuelve el promedio de los valores en un árbol multicamino
	#
	def avg
		size = 1.0
		average = self.foldr1 {|x,y| size+=1; x+y}
		average/size
	end
end
