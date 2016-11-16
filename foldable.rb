class Array
	def foldr e, b
		self.reverse_each.reduce(e,b)
	end
end
class Rose
	attr_accessor :elem, :children
	def initialize elem, children = []
		@elem = elem
		@children = children
	end
	def add elem
		@children.push elem
		self
	end
	def foldr e, b
		
	end
end
