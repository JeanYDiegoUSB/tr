# = algebra.rb
#
# Autor:: Jean Alexander 12-10848 y Diego Pedroza 12-11281 
#
# == Calculadora de Intervalos
#
# El objetivo de esta tarea es aplicar los conocimientos de doble despacho al 
# implementar una calculadora de Intervalos.

require 'singleton'

# === Class Interval
# Representa los intervalos abiertos (x,y) y cerrados [x,y] 
#
class Interval
	# Valores de los extremos de un intervalo 
	attr_reader :x, :y
	# Representación de la inclusión de los extremos
	attr_reader :x_i, :y_i
end

# === Class Literal
#
# Representa los intervalos entre dos puntos finitos
#
class Literal < Interval
	# Constructor
	def initialize x, y, x_i, y_i
		@x, @y, @x_i, @y_i = x, y, x_i, y_i
	end
	
	# Método to_s
	#
	# Muestra el invocante como un String, usando paréntesis ()
	# para extremos excluyentes y corchetes [] para extremos incluyentes
	#
	def to_s
		if @x_i then
			if @y_i then
				"["+@x.to_s+","+@y.to_s+"]"
			else
				"["+@x.to_s+","+@y.to_s+")"
			end
		else
			if @y_i then
				"("+@x.to_s+","+@y.to_s+"]"
			else
				"("+@x.to_s+","+@y.to_s+")"
			end
		end
	end
	
	# Método intersection
	#
	# Método de Doble Despacho, donde al objeto +other+, le pide que haga
	# la intersección_literal con el.
	def intersection other
		other.intersection_literal self
	end
	
	# Método intersection_literal
	#
	# Retorna un nuevo intervalo que representa la intersección del intervalo
	# invocante y el argumento +it+ (resulta en un Literal o en Empty)
	#
	def intersection_literal it
		if self.y > it.x && it.y > self.x
			if self.x > it.x
				if self.y > it.y
					Literal.new(self.x,it.y,self.x_i,it.y_i)
				elsif self.y < it.y
					Literal.new(self.x,self.y,self.x_i,self.y_i)
				else
					if self.y_i
						Literal.new(self.x,it.y,self.x_i,it.y_i)
					else
						Literal.new(self.x,self.y,self.x_i,self.y_i)
					end
				end
			elsif self.x < it.x
				if self.y > it.y
					Literal.new(it.x,it.y,it.x_i,it.y_i)
				elsif self.y < it.y
					Literal.new(it.x,self.y,it.x_i,self.y_i)
				else
					if self.y_i
						Literal.new(it.x,it.y,it.x_i,it.y_i)
					else
						Literal.new(it.x,self.y,it.x_i,self.y_i)
					end
				end
			else
				if self.x_i
					if self.y > it.y
						Literal.new(it.x,it.y,it.x_i,it.y_i)
					elsif self.y < it.y
						Literal.new(it.x,self.y,it.x_i,self.y_i)
					else
						if self.y_i
							Literal.new(it.x,it.y,it.x_i,it.y_i)
						else
							Literal.new(it.x,self.y,it.x_i,self.y_i)
						end
					end
				else
					if self.y > it.y
						Literal.new(self.x,it.y,self.x_i,it.y_i)
					elsif self.y < it.y
						Literal.new(self.x,self.y,self.x_i,self.y_i)
					else
						if self.y_i
							Literal.new(self.x,it.y,self.x_i,it.y_i)
						else
							Literal.new(self.x,self.y,self.x_i,self.y_i)
						end
					end
				end
			end
		elsif self.x == it.y && self.x_i && it.y_i
			Literal.new(self.x,self.x,self.x_i,self.x_i)
		elsif self.y == it.x && self.y_i && it.x_i
			Literal.new(self.y,self.y,self.y_i,self.y_i)
		else
			Empty.instance
		end
	end
	
	# Método intersection_rinfinite
	#
	# Retorna un nuevo intervalo que representa la intersección del intervalo
	# invocante y el argumento +it+ (resulta en un Literal o en Empty)
	#
	def intersection_rinfinite it
		if self.y > it.x
			if self.x > it.x
				Literal.new(self.x,self.y,self.x_i,self.y_i)
			elsif self.x < it.x
				Literal.new(it.x,self.y,it.x_i,self.y_i)
			else
				if self.x_i
					Literal.new(it.x,self.y,it.x_i,self.y_i)
				else
					Literal.new(self.x,self.y,self.x_i,self.y_i)
				end
			end
		else
			Empty.instance
		end
	end
	
	# Método intersection_linfinite
	#
	# Retorna un nuevo intervalo que representa la intersección del intervalo
	# invocante y el argumento +it+ (resulta en un Literal o en Empty)
	#
	def intersection_linfinite it
		if self.x < it.y
			if self.y > it.y
				Literal.new(self.x,it.y,self.x_i,it.y_i)
			elsif self.y < it.y
				Literal.new(self.x,self.y,self.x_i,self.y_i)
			else
				if self.y_i
					Literal.new(self.x,it.y,self.x_i,it.y_i)
				else
					Literal.new(self.x,self.y,self.x_i,self.y_i)
				end
			end
		else
			Empty.instance
		end
	end
	
	# Método union
	#
	# Método de Doble Despacho, que ejecuta el método union_literal de
	# +other+, tomando como argumento self. 
	#
	def union other
		other.union_literal self
	end
	
	# Método union_literal
	#
	# Retorna un nuevo intervalo que representa la unión del
	# intervalo invocante y el argumento +it+
	# (resulta en un Literal o en un error de intervalo no existente)
	#
	def union_literal it
		if it.x < self.y || (self.y == it.x && (self.y_i || it.x_i))
			if self.x > it.x
				if self.y > it.y
					Literal.new(it.x,self.y,it.x_i,self.y_i)
				elsif self.y < it.y
					Literal.new(it.x,it.y,it.x_i,it.y_i)
				else
					if self.y_i
						Literal.new(it.x,it.y,it.x_i,self.y_i)
					else
						Literal.new(it.x,it.y,it.x_i,it.y_i)
					end
				end
			elsif self.x < it.x
				if self.y > it.y
					Literal.new(self.x,self.y,self.x_i,self.y_i)
				elsif self.y < it.y
					Literal.new(self.x,it.y,self.x_i,it.y_i)
				else
					if self.y_i
						Literal.new(self.x,it.y,self.x_i,self.y_i)
					else
						Literal.new(self.x,it.y,self.x_i,it.y_i)
					end
				end
			else
				if self.x_i
					if self.y > it.y
						Literal.new(self.x,self.y,self.x_i,self.y_i)
					elsif self.y < it.y
						Literal.new(self.x,it.y,self.x_i,it.y_i)
					else
						if self.y_i
							Literal.new(it.x,it.y,self.x_i,self.y_i)
						else
							Literal.new(it.x,it.y,self.x_i,it.y_i)
						end
					end
				else
					if self.y > it.y
						Literal.new(self.x,self.y,it.x_i,self.y_i)
					elsif self.y < it.y
						Literal.new(self.x,it.y,it.x_i,it.y_i)
					else
						if self.y_i
							Literal.new(it.x,it.y,it.x_i,self.y_i)
						else
							Literal.new(it.x,it.y,it.x_i,it.y_i)
						end
					end
				end
			end
		else
			begin
				raise 'no existe el intervalo '+self.to_s+' | '+it.to_s
			rescue => e
				puts e.message
			end
		end
	end
	
	# Método union_rinfinite
	#
	# Retorna un nuevo intervalo que representa la unión del
	# intervalo invocante y el argumento +it+
	# (resulta en un RightInfinite o en un error de intervalo no existente)
	#
	def union_rinfinite it
		if it.x < self.y || (self.y == it.x && (self.y_i || it.x_i))
			if self.x > it.x
				RightInfinite.new(it.x,it.x_i)
			elsif self.x < it.x
				RightInfinite.new(self.x,self.x_i)
			else
				if self.x_i
					RightInfinite.new(self.x,self.x_i)
				else
					RightInfinite.new(it.x,it.x_i)
				end
			end
		else
			begin
				raise 'no existe el intervalo '+self.to_s+' | '+it.to_s
			rescue => e
				puts e.message
			end
		end
	end
	
	# Método union_linfinite
	#
	# Retorna un nuevo intervalo que representa la unión del
	# intervalo invocante y el argumento +it+
	# (resulta en un LeftInfinite o en un error de intervalo no existente)
	#
	def union_linfinite it
		if it.y > self.x || (self.x == it.y && (self.x_i || it.y_i))
			if self.y < it.y
				LeftInfinite.new(it.y,it.y_i)
			elsif self.y > it.y
				LeftInfinite.new(self.y,self.y_i)
			else
				if self.y_i
					LeftInfinite.new(self.y,self.y_i)
				else
					LeftInfinite.new(it.y,it.y_i)
				end
			end
		else
			begin
				raise 'no existe el intervalo '+self.to_s+' | '+it.to_s
			rescue => e
				puts e.message
			end
		end
	end
end

# === Class RightInfinite
#
# Representa los intervalos desde un punto
#
class RightInfinite < Interval
	# Constructor
	def initialize x, x_i
		@x, @x_i = x, x_i
	end
	
	# Método to_s
	#
	# Muestra el invocante como un String, usando paréntesis ()
	# para extremos excluyentes y corchetes [] para extremos incluyentes
	#
	def to_s
		if @x_i then
			"["+@x.to_s+",)"
		else
			"("+@x.to_s+",)"
		end
	end
	
	# Método intersection
	#
	# Método de Doble Despacho que le ejecuta el método
	# intersection_rinfinite de +other+ pasando el objeto como argumento
	#
	def intersection other
		other.intersection_rinfinite self
	end
	
	# Método intersection_literal
	#
	# Retorna un nuevo intervalo que representa la intersección del intervalo
	# invocante y el argumento +it+ (resulta en un Literal o en Empty)
	#
	def intersection_literal it
		if self.x < it.y
			if self.x > it.x
				Literal.new(self.x,it.y,self.x_i,it.y_i)
			elsif self.x < it.x
				Literal.new(it.x,it.y,it.x_i,it.y_i)
			else
				if self.x_i
					Literal.new(it.x,it.y,it.x_i,it.y_i)
				else
					Literal.new(self.x,it.y,self.x_i,it.y_i)
				end
			end
		else
			Empty.instance
		end
	end
	
	# Método intersection_rinfinite
	#
	# Retorna un nuevo intervalo que representa la intersección del intervalo
	# invocante y el argumento +it+ (resulta en un RightInfinite)
	#
	def intersection_rinfinite it
		if self.x > it.x
			self
		elsif self.x < it.x
			it
		else
			if self.x_i
				it
			else
				self
			end
		end
	end
		
	# Método intersection_linfinite
	#
	# Retorna un nuevo intervalo que representa la intersección del intervalo
	# invocante y el argumento +it+ (resulta en un Literal o en Empty)
	#
	def intersection_linfinite it
		if self.x < it.y || (self.x == it.y && self.x_i && it.y_i)
			Literal.new(self.x,it.y,self.x_i,it.y_i)
		else
			Empty.instance
		end
	end
	
	# Método union
	#
	# Método de Doble Despacho, que ejecuta el método union_rinfinite de
	# +other+, tomando como argumento self. 
	#
	def union other
		other.union_rinfinite self
	end
	
	# Método union_literal
	#
	# Retorna un nuevo intervalo que representa la unión del
	# intervalo invocante y el argumento +it+
	# (resulta en un RightInfinite o en un error de intervalo no existente)
	#
	def union_literal it
		if it.y > self.x || (self.x == it.y && (self.x_i || it.y_i))
			if self.x > it.x
				RightInfinite.new(it.x,it.x_i)
			elsif self.x < it.x
				RightInfinite.new(self.x,self.x_i)
			else
				if self.x_i
					RightInfinite.new(self.x,self.x_i)
				else
					RightInfinite.new(it.x,it.x_i)
				end
			end
		else
			begin
				raise 'no existe el intervalo '+self.to_s+' | '+it.to_s
			rescue => e
				puts e.message
			end
		end
	end
	
	# Método union_rinfinite
	#
	# Retorna un nuevo intervalo que representa la unión del
	# intervalo invocante y el argumento +it+
	# (resulta en un RightInfinite)
	#
	def union_rinfinite it
		if self.x > it.x
			RightInfinite.new(it.x,it.x_i)
		elsif self.x < it.x
			RightInfinite.new(self.x,self.x_i)
		else
			if self.x_i
				RightInfinite.new(self.x,self.x_i)
			else
				RightInfinite.new(it.x,it.x_i)
			end
		end
	end
	
	# Método union_linfinite
	#
	# Retorna un nuevo intervalo que representa la unión del
	# intervalo invocante y el argumento +it+
	# (resulta en AllReals o en un error de intervalo no existente)
	#
	def union_linfinite it
		if it.y > self.x || (self.x == it.y && (self.x_i || it.y_i))
			AllReals.instance
		else
			begin
				raise 'no existe el intervalo '+self.to_s+' | '+it.to_s
			rescue => e
				puts e.message
			end
		end
	end
end

# === Class LeftInfite
#
# Representa los intervalos hasta un punto
#
class LeftInfinite < Interval
	# Constructor
	def initialize y, y_i
		@y, @y_i = y, y_i
	end
	
	# Método to_s
	#
	# Muestra el invocante como un String, usando paréntesis ()
	# para extremos excluyentes y corchetes [] para extremos incluyentes
	#
	def to_s
		if @y_i then
			"(,"+@y.to_s+"]"
		else
			"(,"+@y.to_s+")"
		end
	end
	
	# Método intersection
	#
	# Método de Doble Despacho, que le pide a +other+
	# que haga intersection_linfinite con él.
	def intersection other
		other.intersection_linfinite self
	end
	
	# Método intersection_literal
	#
	# Retorna un nuevo intervalo que representa la intersección del intervalo
	# invocante y el argumento +it+ (resulta en un Literal o en Empty)
	#
	def intersection_literal it
		if self.y > it.x
			if self.y > it.y
				Literal.new(it.x,it.y,it.x_i,it.y_i)
			elsif self.y < it.y
				Literal.new(it.x,self.y,it.x_i,self.y_i)
			else
				if self.y_i
					Literal.new(it.x,it.y,it.x_i,it.y_i)
				else
					Literal.new(it.x,self.y,it.x_i,self.y_i)
				end
			end
		else
			Empty.instance
		end
	end
	
	# Método intersection_rinfinite
	#
	# Retorna un nuevo intervalo que representa la intersección del intervalo
	# invocante y el argumento +it+ (resulta en un Literal o en Empty)
	#
	def intersection_rinfinite it
		if self.y > it.x || (self.y == it.x && self.y_i && it.x_i)
			Literal.new(it.x,self.y,it.x_i,self.y_i)
		else
			Empty.instance
		end
	end
	
	# Método intersection_linfinite
	#
	# Retorna un nuevo intervalo que representa la intersección del intervalo
	# invocante y el argumento +it+ (resulta en un LeftInfinite)
	#
	def intersection_linfinite it
		if self.y < it.y
			self
		elsif self.y > it.y
			it
		else
			if self.y_i
				it
			else
				self
			end
		end
	end
	
	# Método union
	#
	# Método de Doble Despacho, que ejecuta el método union_linfinite de
	# +other+, tomando como argumento self. 
	#
	def union other
		other.union_linfinite self
	end
	
	# Método union_literal
	#
	# Retorna un nuevo intervalo que representa la unión del
	# intervalo invocante y el argumento +it+
	# (resulta en un LeftInfinite o en un error de intervalo no existente)
	#
	def union_literal it
		if it.x < self.y || (self.y == it.x && (self.y_i || it.x_i))
			if self.y < it.y
				LeftInfinite.new(it.y,it.y_i)
			elsif self.y > it.y
				LeftInfinite.new(self.y,self.y_i)
			else
				if self.y_i
					LeftInfinite.new(self.y,self.y_i)
				else
					LeftInfinite.new(it.y,it.y_i)
				end
			end
		else
			begin
				raise 'no existe el intervalo '+self.to_s+' | '+it.to_s
			rescue => e
				puts e.message
			end
		end
	end
	
	# Método union_rinfinite
	#
	# Retorna un nuevo intervalo que representa la unión del
	# intervalo invocante y el argumento +it+
	# (resulta en AllReals o en un error de intervalo no existente)
	#
	def union_rinfinite it
		if it.x < self.y || (self.y == it.x && (self.y_i || it.x_i))
			AllReals.instance
		else
			begin
				raise 'no existe el intervalo '+self.to_s+' | '+it.to_s
			rescue => e
				puts e.message
			end
		end
	end
	
	# Método union_linfinite
	#
	# Retorna un nuevo intervalo que representa la unión del
	# intervalo invocante y el argumento +it+ (resulta en un LeftInfinite)
	#
	def union_linfinite it
		if self.y < it.y
			LeftInfinite.new(it.y,it.y_i)
		elsif self.y > it.y
			LeftInfinite.new(self.y,self.y_i)
		else
			if self.y_i
				LeftInfinite.new(self.y,self.y_i)
			else
				LeftInfinite.new(it.y,it.y_i)
			end
		end
	end
end

# === Class AllReals
#
# Representa el intervalo de todos los números reales
#
class AllReals < Interval
	include Singleton
	
	# Método to_s
	#
	# Muestra el invocante como un String, usando paréntesis ()
	# para extremos excluyentes y corchetes [] para extremos incluyentes
	#
	def to_s
		"(,)"
	end
	
	# Método intersection
	#
	# Retorna un nuevo intervalo que representa la intersección del intervalo
	# invocante y el argumento +other+
	#
	def intersection other
		other
	end
	
	# Método intersection_literal
	#
	# Retorna un nuevo intervalo que representa la intersección del intervalo
	# invocante y el argumento +other+
	#
	def intersection_literal other
		other
	end
	
	# Método intersection_rinfinite
	#
	# Retorna un nuevo intervalo que representa la intersección del intervalo
	# invocante y el argumento +other+
	#
	def intersection_rinfinite other
		other
	end
	
	# Método intersection_linfinite
	#
	# Retorna un nuevo intervalo que representa la intersección del intervalo
	# invocante y el argumento +other+
	#
	def intersection_linfinite other
		other
	end
	
	# Método union
	#
	# Retorna un nuevo intervalo que representa la unión del
	# intervalo invocante y el argumento +other+
	#
	def union other
		self
	end
	
	# Método union_literal
	#
	# Retorna un nuevo intervalo que representa la unión del
	# intervalo invocante y el argumento +other+
	#
	def union_literal other
		self
	end

	# Método union_rinfinite
	#
	# Retorna un nuevo intervalo que representa la unión del
	# intervalo invocante y el argumento +other+
	#
	def union_rinfinite other
		self
	end

	# Método union_linfinite
	#
	# Retorna un nuevo intervalo que representa la unión del
	# intervalo invocante y el argumento +other+
	#	
	def union_linfinite other
		self
	end
end

# === Class Empty
#
# Representa el intervalo vacío
#
class Empty < Interval
	include Singleton
	# Método to_s
	#
	# Muestra el invocante como un String, usando paréntesis ()
	# para extremos excluyentes y corchetes [] para extremos incluyentes
	#
	def to_s
		"empty"
	end
	
	# Método intersection
	#
	# Retorna un nuevo intervalo que representa la intersección del intervalo
	# invocante y el argumento +other+
	#
	def intersection other
		self
	end
	
	# Método intersection_literal
	#
	# Retorna un nuevo intervalo que representa la intersección del intervalo
	# invocante y el argumento +other+
	#
	def intersection_literal other
		self
	end
	
	# Método intersection_rinfinite
	#
	# Retorna un nuevo intervalo que representa la intersección del intervalo
	# invocante y el argumento +other+
	#
	def intersection_rinfinite other
		self
	end
	
	# Método intersection_linfinite
	#
	# Retorna un nuevo intervalo que representa la intersección del intervalo
	# invocante y el argumento +other+
	#
	def intersection_linfinite other
		self
	end
	
	# Método union
	#
	# Retorna un nuevo intervalo que representa la unión del
	# intervalo invocante y el argumento +other+
	#
	def union other
		other
	end
	
	# Método union_literal
	#
	# Retorna un nuevo intervalo que representa la unión del
	# intervalo invocante y el argumento +other+
	#
	def union_literal other
		other
	end

	# Método union_rinfinite
	#
	# Retorna un nuevo intervalo que representa la unión del
	# intervalo invocante y el argumento +other+
	#
	def union_rinfinite other
		other
	end

	# Método union_linfinite
	#
	# Retorna un nuevo intervalo que representa la unión del
	# intervalo invocante y el argumento +other+
	#	
	def union_linfinite other
		other
	end
end

# Método que crea un intervalo dado un String
def crear_intervalo string
	aux = string.split(" ")
	if aux[1].eql? "<"
		LeftInfinite.new(aux[2].to_i,false)
	elsif aux[1].eql? "<="
		LeftInfinite.new(aux[2].to_i,true)
	elsif aux[1].eql? ">"
		RightInfinite.new(aux[2].to_i,false)
	elsif aux[1].eql? ">="
		RightInfinite.new(aux[2].to_i,true)
	end
end

# Programa Principal

# Instancia de AllReals
$reales = AllReals.instance

# Un Hash para guardar las variables y sus intervalos
el_hash = Hash.new($reales)

# Lectura de las variables
print "Ingrese el nombre del archivo a cargar: "
archivo = gets.chomp
IO.foreach(archivo) do |line|
	# Se separa cada linea por los '|', luego se separa cada separación
	# anterior por '&'
	arr = line.chomp.split(" | ").map {|elem| elem.split(" & ")}
	
	# Se crean todos los intervalos y se operan las
	# intersecciones primero 
	i = 0
	arr.each do |elem|
		if elem.length == 1
			arr[i] = crear_intervalo elem[0]
		else
			e = crear_intervalo elem[0]
			elem[1..-1].each do |x|
				e = e.intersection crear_intervalo x
			end
			arr[i] = e
		end
		i += 1
	end
	
	# Luego se unen todos los intervalos obtenidos
	aux = arr[0]
	arr[1..-1].each {|elem| aux = aux.union elem}
	
	# Si la variable ya esta en el Hash
	if el_hash.has_key? line[0]
		# Se une al intervalo que ya existía en el Hash
		el_hash[line[0]] = el_hash[line[0]].union aux
	else
		# Si no esta se intersecta con el valor por defecto
		# del Hash ($reales)
		el_hash[line[0]] = el_hash[line[0]].intersection aux
	end
end

# La Calculadora
while true
	# Se muestran las variables disponibles
	puts "Las variables disponibles son:"
	el_hash.each {|key,value| puts "  #{key} in #{value}"}
	puts
	# Prompt para la calculadora
	puts "\tIngrese «variable» «operador» «variable», donde"
	puts "\t«operador» puede ser & ó |, y «variable» es alguna"
	puts "\tde las variables mostradas anteriormente"
	
	# Entrada del usuario
	linea = gets.chomp.lines(" ").each {|x| x.rstrip!}
	
	# Si ingresa exit se sale del programa
	if linea[0] == "exit"
		puts "\tLa calculadora termino su ejecucion"; break
	end
	# Si no, presenta el resultado de la operación
	print "El resultado es: "
	if linea[1] == "&"
		puts el_hash[linea[0]].intersection el_hash[linea[2]]
	elsif linea[1] == "|"
		puts el_hash[linea[0]].union el_hash[linea[2]]
	end
	puts
end
