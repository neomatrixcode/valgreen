
# reglas semanticas
# entero + entero
#   ==
# inicializados los identificadores

function unexpectedsemantico(mensaje,token)
  return "Error semantico \n"*mensaje*" [ "*token.lexema*" ] CERCA DE  fila: "*string(token.fila)*" columna: "* string(token.columna)
end

function error_sematico(mensaje, token)
return throw(ErrorException(unexpectedsemantico(mensaje,token)))
end

function suma_recursiva(rama)
    z = typeof(rama)
	for e in fieldnames(z)
	    elemento = getfield(rama, e)

	    if elemento != nothing
	    	if string(typeof(elemento)) == "token"
	    		if elemento.tipo == "string"
	    			error_sematico(" no se puede sumar un string con un entero ", elemento)
	    	    end
	    	    if elemento.tipo == "identificador"
	    	    	try
			    		tabla_simbolos[elemento.lexema]["tipo"]
			    	catch e
			    		error_sematico(" la variable no se ha inicializado ", elemento)
			    	end

			    	if tabla_simbolos[elemento.lexema]["tipo"]=="string"
		                error_sematico(" no se puede sumar una variable tipo string con un entero ", elemento)
			        end
	    		end
	    	else
	    		suma_recursiva(elemento)
	    	end
	    end
	end
end

function verifica_suma(segmento)
  variable = segmento.token.lexema
  suma = segmento.noterminal
  suma_recursiva(suma)
  push!(tabla_simbolos[variable], "tipo"=>"numero_entero","valor"=>"-")
end

function verifica_asignacion(segmento)
id= segmento.token.lexema
tipo = segmento.noterminal.expresion.tipo
valor = segmento.noterminal.expresion.lexema

	if tipo=="identificador"
	    try
	        push!(tabla_simbolos[id], "tipo"=>tabla_simbolos[valor]["tipo"],"valor"=>tabla_simbolos[valor]["valor"])
		catch e
	        error_sematico(" la variable no se ha inicializado ", segmento.noterminal.expresion)
		end
	else
		push!(tabla_simbolos[id], "tipo"=>tipo,"valor"=>valor)
	end
end

function verifica_comparacion(segmento)
	variable = segmento.noterminal.comparacion.igualdad.token

	try
	  tabla_simbolos[variable.lexema]["tipo"]
	catch e
		error_sematico(" la variable no se ha inicializado ", variable)
	end

	if tabla_simbolos[variable.lexema]["tipo"] !="numero_entero"
		error_sematico(" la variable a comparar debe ser de tipo entero ", variable)
	end
end

 function recorre(arbol)

	t = typeof(arbol)
	for f in fieldnames(t)
	    elemento = getfield(arbol, f)

	    if elemento != nothing

		    if string(typeof(elemento)) == "objetoelemento"

		     	if string(typeof(elemento.noterminal)) == "asignacion"
	                if elemento.noterminal.suma != nothing
	                    verifica_suma(elemento)
	                else
	                    verifica_asignacion(elemento)
	                end
	            else string(typeof(elemento.noterminal)) == "ntif"
	            	 verifica_comparacion(elemento)
	            end

            else

             	if string(typeof(elemento)) != "token"
                  recorre(elemento)
	            end

		    end

	    end

	end
 end

