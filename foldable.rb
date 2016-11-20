module Foldable
	def null 
		
	end
end


class Array
	def foldr e, &b
		result = e
		self.reverse_each {|elem| result = b.call(elem,result)}
		result
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
	def foldr e, &b
		result = e
		self.children.reverse_each {|tree| result = tree.foldr result, &b}
		b.call(self.elem,result)
	end
end