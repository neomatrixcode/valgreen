

function interprete(codigori)
    lineas = split(codigori, "\n")

	for instruccion in lineas
		if instruccion != ""
		println(instruccion)
	    println(eval(Meta.parse(instruccion)))
		end
	end
end
