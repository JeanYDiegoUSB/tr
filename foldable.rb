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
		result = b.call(self.elem,result)
		result
	end
end

tree = Rose.new(1, [Rose.new(2, [ Rose.new(4), Rose.new(5) ]),Rose.new(3, [ Rose.new(6) ])])
suma = tree.foldr(0) {|x,y| x + y}
producto = tree.foldr(1) {|x,y| x * y}
puts "La suma del árbol es #{suma} y su producto es #{producto}"