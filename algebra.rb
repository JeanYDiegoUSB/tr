class Interval
	attr_reader :x, :y, :x_i, :y_i
end

class Literal < Interval
	def initialize x, y, x_i, y_i
		@x, @y, @x_i, @y_i = x, y, x_i, y_i
	end
	def to_s
		if x_i then
			if y_i then
				"["+x.to_s+","+y.to_s+"]"
			else
				"["+x.to_s+","+y.to_s+")"
			end
		else
			if y_i then
				"("+x.to_s+","+y.to_s+"]"
			else
				"("+x.to_s+","+y.to_s+")"
			end
		end
	end
	def intersection other
		other.intersection_literal self
	end
	def union other
		other.union_literal self
	end
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

class RightInfinite < Interval
	def initialize x, x_i
		@x, @x_i = x, x_i
	end
	def to_s
		if x_i then
			"["+x.to_s+",)"
		else
			"("+x.to_s+",)"
		end
	end
	def intersection other
		other.intersection_rinfinite self
	end
	def union other
		other.union_rinfinite self
	end
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
	def union_linfinite it
		if it.y > self.x || (self.x == it.y && (self.x_i || it.y_i))
			$reales
		else
			begin
				raise 'no existe el intervalo '+self.to_s+' | '+it.to_s
			rescue => e
				puts e.message
			end
		end
	end
end

class LeftInfinite < Interval
	def initialize y, y_i
		@y, @y_i = y, y_i
	end
	def to_s
		if y_i then
			"(,"+y.to_s+"]"
		else
			"(,"+y.to_s+")"
		end
	end
	def intersection other
		other.intersection_linfinite self
	end
	def union other
		other.union_linfinite self
	end
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
	def union_rinfinite it
		if it.x < self.y || (self.y == it.x && (self.y_i || it.x_i))
			$reales
		else
			begin
				raise 'no existe el intervalo '+self.to_s+' | '+it.to_s
			rescue => e
				puts e.message
			end
		end
	end
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

class AllReals < Interval
	def to_s
		"(,)"
	end
	def intersection other
		other
	end
	def union other
		self
	end
end

class Empty < Interval
	def to_s
		"empty"
	end
	def intersection other
		self
	end
	def union other
		other
	end
end

$reales = AllReals.new
$vacio = Empty.new