
# reglas semanticas
# entero + entero
#   ==
# inicializados los identificadores

function unexpected(mensaje,token)
  return "Error semantico \n"*mensaje*" ["*token.lexema*"] CERCA DE  fila: "*string(token.fila)*" columna: "* string(token.columna)
end

function error_sematico(mensaje, token)
return throw(ErrorException(unexpected(mensaje,token)))
end

function verifica_suma(segmento)
  println(" es una suma ===========\n",segmento)
  println(tabla_simbolos)
end

function verifica_asignacion(segmento)
id= segmento.token.lexema
tipo = segmento.noterminal.expresion.tipo
valor = segmento.noterminal.expresion.lexema

	if tipo=="identificador"
	    try
	        push!(tabla_simbolos[id], "tipo"=>tabla_simbolos[valor]["tipo"],"valor"=>tabla_simbolos[valor]["valor"])
		catch e
	        error_sintactico(" la variable no se ha inicializado ", segmento.noterminal.expresion)
		end
	else
		push!(tabla_simbolos[id], "tipo"=>tipo,"valor"=>valor)
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
                end

            else

             	if string(typeof(elemento)) != "token"
                  recorre(elemento)
	            end

		    end

	    end

	end
 end

