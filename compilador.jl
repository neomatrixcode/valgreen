f = open("holamundo.val")
read(f,String)
texto = String(take!(f))

cantidad_caracteres = length(texto)
indice=1

mutable struct token
tipo
lexema
end

arreglo_tokens=[]

while(indice<= cantidad_caracteres)
	global indice
	global arreglo_tokens
	try
		if (texto[indice]== ' ' || texto[indice]== '\t' || texto[indice]== '\n')
           indice=indice

		elseif texto[indice]== '?'
			#println("\tsimbolo_de_?\t?")
			push!(arreglo_tokens,token("simbolo_de_?","?"))

		elseif texto[indice]== '¿'
			#println("\tsimbolo_de_¿\t¿")
			push!(arreglo_tokens,token("simbolo_de_¿","¿"))


		elseif texto[indice]== '+'
			#println("\t  operador     +")
			push!(arreglo_tokens,token("operador","+"))

		elseif texto[indice]== '='
			if(texto[indice+1]== '=')
				#println("\tcomparacion     ==")
			    push!(arreglo_tokens,token("comparacion","=="))
				indice=indice+1
			else
				#println("\t asignacion    =")
				push!(arreglo_tokens,token("asignacion","="))
			end

		elseif('0'<= texto[indice] <= '9' )
			buffer= ""
			while('0'<= texto[indice]<='9')
				buffer = buffer*texto[indice]
				indice = indice+1
			end
			indice = indice-1
			#println("\tnumero entero   "*buffer)
			push!(arreglo_tokens,token("numero_entero",buffer))

		elseif texto[indice]=='#'
			while(texto[indice]!='\n')
				indice = indice+1
			end
        elseif texto[indice]=='"'
        	buffer=""
        	buffer = buffer*texto[indice]
			indice = indice+1
			while(texto[indice]!='"')
				buffer = buffer*texto[indice]
				indice = indice+1
			end
            #println("\tstring   "*buffer*"\"")
			push!(arreglo_tokens,token("string",buffer))

		elseif 'a'<= texto[indice]<='z'
			buffer = ""
			while('a'<= texto[indice]<='z' || '0'<= texto[indice]<='9')
				buffer = buffer*texto[indice]
				indice = indice+1
			end

			if buffer== "origen"
			    #println("   palabra reservada   "*buffer)
				push!(arreglo_tokens,token("palabra reservada",buffer))
		    elseif buffer== "inicio"
			    #println("   palabra reservada   "*buffer)
				push!(arreglo_tokens,token("palabra reservada",buffer))
			elseif buffer== "fin"
			    #println("   palabra reservada   "*buffer)
				push!(arreglo_tokens,token("palabra reservada",buffer))
			elseif buffer== "si"
			    #println("   palabra reservada   "*buffer)
				push!(arreglo_tokens,token("palabra reservada",buffer))
			elseif buffer== "imprimir"
			    #println("   palabra reservada   "*buffer)
				push!(arreglo_tokens,token("palabra reservada",buffer))
			elseif (match(Regex("[a-z]+[0-9]*[a-z]*"),buffer) != nothing)
				#println("  identificador   "*buffer)
				push!(arreglo_tokens,token("identificador",buffer))
		    else
		    	error("ERROR LEXICO, PALABRA NO RECONOCIDA "* buffer)
			end
			indice= indice-1
	    else
	       error("ERROR LEXICO, SIMBOLO NO RECONOCIDO "* texto[indice])
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

#impresion de los tokens en pantalla (tipo y lexema)
for token in arreglo_tokens
    println(token.tipo *"\t"*token.lexema)
end
