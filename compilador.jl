f = open("holamundo.val")
read(f,String)
texto = String(take!(f))

cantidad_caracteres = length(texto)
indice=1

while(indice<= cantidad_caracteres)
	global indice
	try
		if (texto[indice]== ' ' || texto[indice]== '\t' || texto[indice]== '\n')
           indice=indice

		elseif texto[indice]== '?'
			println("\tsimbolo_de_?\t?")

		elseif texto[indice]== '¿'
			println("\tsimbolo_de_¿\t¿")

		elseif texto[indice]== '+'
			println("\t  operador     +")

		elseif texto[indice]== '='
			if(texto[indice+1]== '=')
				println("\tcomparacion     ==")
				indice=indice+1
			else
				println("\t asignacion    =")
			end

		elseif('0'<= texto[indice] <= '9' )
			buffer= ""
			while('0'<= texto[indice]<='9')
				buffer = buffer*texto[indice]
				indice = indice+1
			end
			indice = indice-1
			println("\tnumero entero   "*buffer)

		elseif 'a'<= texto[indice]<='z'
			buffer = ""
			while('a'<= texto[indice]<='z' || '0'<= texto[indice]<='9')
				buffer = buffer*texto[indice]
				indice = indice+1
			end

			if buffer== "origen"
				println("   palabra reservada   "*buffer)
		    elseif buffer== "inicio"
				println("   palabra reservada   "*buffer)
			elseif buffer== "fin"
				println("   palabra reservada   "*buffer)
			elseif buffer== "si"
				println("   palabra reservada   "*buffer)
			elseif buffer== "imprimir"
				println("   palabra reservada   "*buffer)
			elseif (match(Regex("[a-z]+[0-9]*[a-z]*"),buffer) != nothing)
				println("  nombre_de_variable   "*buffer)
		    else
		    	error("asco tu programa amiga, PALABRA NO RECONOCIDA "* buffer)
			end
			indice= indice-1
	    else
	       error("asco tu programa amiga, SIMBOLO NO RECONOCIDO "* texto[indice])
		end
		indice= indice+1
	catch e
	   if e isa ErrorException
	   	 rethrow(e)
	   else
		indice= indice+1
       end
    end
end