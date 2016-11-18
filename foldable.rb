class Array
	def foldr e, b
		self.reverse_each.inject(e,b)
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
		if self.children == [] then b.to_proc.call(self.elem,e)
		else b.to_proc.call(self.elem,(self.children.map {|tree| tree.foldr(e,b)}).foldr(e,b))
		end
	end
end