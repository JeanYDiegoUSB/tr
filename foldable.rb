module Foldable
	def null
		self.foldr(true) {|x,y| false}
	end
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
	def length
		self.foldr(0) {|x,y| 1 + y}
	end
	def all? &block
		self.foldr(true) {|x,y| block.call(x) && y}
	end
	def any? &block
		self.foldr(false) {|x,y| block.call(x) || y}
	end
	def to_arr
		self.foldr([]) {|x,y| [x] + y}
	end
	def elem? to_find
		self.any? {|x| x == to_find}
	end
end

class Array
include Foldable
	def foldr e, &b
		result = e
		self.reverse_each {|elem| result = b.call(elem,result)}
		result
	end
end

class Rose
include Foldable
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
	def avg
		average = self.foldr1 do |x,y|
			if y.is_a? Array
			then [x+y[0],1+y[1]]
			else [x+y,2.0]
			end
		end
		average[0]/average[1]
	end
end
