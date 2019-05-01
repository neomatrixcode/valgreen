
function conversion_a_python(codigo_intermedio)

	codigo_python = replace(codigo_intermedio, "println" => "print")

	io = open("programa.py", "w");
	write(io, codigo_python);
	close(io);
	println(" programa.py creado con exito")
end


function conversion_a_js(codigo_intermedio)

	codigo_js = replace(codigo_intermedio, "println" => "console.log")

	io = open("programa.js", "w");
	write(io, codigo_js);
	close(io);
	println(" programa.js creado con exito")
end


function conversion_a_ruby(codigo_intermedio)

	codigo_ruby = replace(codigo_intermedio, "println" => "puts")
	codigo_ruby = replace(codigo_ruby, "(" => " ")
	codigo_ruby = replace(codigo_ruby, ")" => " ")

	io = open("programa.rb", "w");
	write(io, codigo_ruby);
	close(io);
	println(" programa.rb creado con exito")
end