

mutable struct token
tipo
lexema
fila
columna
end

tabla_simbolos = Dict()

mutable struct tokens
    actual
    siguiente
    anterior
    function tokens(archivo)
        f = open(archivo)
		read(f,String)
		texto = String(take!(f))

		cantidad_caracteres = length(texto)
		indice=1

		fila=1
		columna=1

		tokeanterior= nothing
		tokenactual= nothing
		tokenfuturo= nothing
        bandera = 0
        siguiente()

        function anterior()
        	  tokenfuturo = tokenactual
              tokenactual = tokeanterior
              bandera = 2
        end

        function actual()
        	#println(" actual()  _ bandera: ", bandera)
        	#println(" tokenactual  : ", tokenactual)
        	if bandera== 2
        		bandera= 1
        	    return tokenactual
        	elseif bandera == 1
        		bandera = 0
        		return tokenfuturo
        	else
	            return tokenactual
            end
        end

        function siguiente()
        	#println( "siguiente()  ")
   if bandera== 0
    tokeanterior= tokenactual
try
		    try
			texto[indice]
			catch e
		        indice=indice+1
		    end
			#println("######## indice",indice)
			#println("######## texto ",texto[indice])

		if (texto[indice]== '\n')
		    fila=fila+1
		    columna= 1
		    indice=indice+1
		    siguiente()
		elseif texto[indice]== ' '
           columna=columna+1
           indice=indice+1
           siguiente()
        elseif texto[indice]== '\t'
           columna=columna+5
           indice=indice+1
           siguiente()
		elseif texto[indice]== '¿'
            columna = columna+1
            indice  = indice+1
			tokenactual= token("simbolo_de_¿","¿",fila,columna)
        elseif texto[indice]=='?'
        	columna = columna+1
        	indice = indice+2
            tokenactual= token("simbolo_de_?","?",fila,columna)
		elseif texto[indice]== '+'
            columna= columna+1
            indice=indice+1
			tokenactual= token("operador","+",fila,columna)
		elseif texto[indice]== '='
			if(texto[indice+1]== '=')
				indice= indice+2
				columna=columna+2
			    tokenactual= token("comparacion","==",fila,columna)
			else
				columna= columna+1
				indice=indice+1
				tokenactual= token("asignacion","=",fila,columna)
			end

		elseif('0'<= texto[indice] <= '9' )
			buffer= ""
			while('0'<= texto[indice]<='9')
				buffer = buffer*texto[indice]
				indice = indice+1
				columna= columna+1
			end
			tokenactual= token("numero_entero",buffer,fila,columna)

		elseif texto[indice]=='#'
			columna=columna+1
			indice = indice+1
			while(texto[indice]!='\n')
				indice = indice+1
				columna=columna+1
			end
            siguiente()
        elseif texto[indice]=='"'
        	buffer=""
        	buffer = buffer*texto[indice]
			indice = indice+1
			columna= columna+1
			while(texto[indice]!='"')
				buffer = buffer*texto[indice]
				indice = indice+1
				columna=columna+1
			end
			tokenactual= token("string",buffer*"\"",fila,columna)
		elseif 'a'<= texto[indice]<='z'
			buffer = ""
			while('a'<= texto[indice]<='z' || '0'<= texto[indice]<='9')
				#println("texto[indice] -> ",texto[indice])
				buffer = buffer*texto[indice]
				indice = indice+1
				columna= columna+1
			end

			if buffer== "origen"
				tokenactual= token("palabra reservada",buffer,fila,columna)
		    elseif buffer== "inicio"
				tokenactual= token("palabra reservada",buffer,fila,columna)
			elseif buffer== "fin"
				tokenactual= token("palabra reservada",buffer,fila,columna)
			elseif buffer== "si"
				tokenactual= token("palabra reservada",buffer,fila,columna)
			elseif buffer== "imprimir"
				tokenactual= token("palabra reservada",buffer,fila,columna)
			elseif (match(Regex("[a-z]+[0-9]*[a-z]*"),buffer) != nothing)
				tokenactual= token("identificador",buffer,fila,columna)
				if !haskey(tabla_simbolos,buffer)
		          push!(tabla_simbolos, buffer => Dict())
			    end
		    else
		    	error("ERROR LEXICO, PALABRA NO RECONOCIDA "* buffer)
			end
	    else

	       error("ERROR LEXICO, SIMBOLO NO RECONOCIDO "* texto[indice])
		end
catch e
    if isa(e, BoundsError)

	end
end


   end
end
        new(actual,siguiente,anterior)
    end
end