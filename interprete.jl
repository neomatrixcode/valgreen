

function interprete(codigori)
    lineas = split(codigori, "\n")

	for instruccion in lineas
		try
			println(instruccion)
		    println(eval(Meta.parse(instruccion)))
		catch
	    end
	end
end
