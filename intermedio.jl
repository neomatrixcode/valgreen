primer_elemento = 0
indice_temporales = 1
codigo_intermedio=""
function ri_suma_recursiva(rama)

	global indice_temporales
	global primer_elemento
	global codigo_intermedio

    z = typeof(rama)
	for e in fieldnames(z)
	    elemento = getfield(rama, e)

	    if elemento != nothing
	    	if string(typeof(elemento)) == "token"
	    	    if elemento.tipo == "identificador"

	    	    	if primer_elemento == 0
	    	    	    #println("t$(indice_temporales) = ", tabla_simbolos[elemento.lexema]["temporal"])
	    	    	    codigo_intermedio = codigo_intermedio* "t$(indice_temporales) = $(tabla_simbolos[elemento.lexema]["temporal"])\n"
                    indice_temporales= indice_temporales+1
	    	    	else
                    #println("t$(indice_temporales) = t$(indice_temporales-1) +", tabla_simbolos[elemento.lexema]["temporal"])
                    codigo_intermedio = codigo_intermedio* "t$(indice_temporales) = t$(indice_temporales-1) + $(tabla_simbolos[elemento.lexema]["temporal"]))\n"
                    indice_temporales= indice_temporales+1

                    end
	    		end

	    		if elemento.tipo == "numero_entero"
	    			if primer_elemento == 0
	    	    	    #println("t$(indice_temporales) = ", elemento.lexema)
	    	    	    codigo_intermedio = codigo_intermedio * "t$(indice_temporales) = $(elemento.lexema)\n"
                    indice_temporales= indice_temporales+1
	    	    	else
	                    #println("t$(indice_temporales) = t$(indice_temporales-1) +", elemento.lexema)
	                    codigo_intermedio = codigo_intermedio * "t$(indice_temporales) = t$(indice_temporales-1) + $(elemento.lexema)\n"
	                    indice_temporales= indice_temporales+1
                	end
	    		end

	    	else
	    		primer_elemento=1
	    		ri_suma_recursiva(elemento)
	    	end
	    end
	end
end

function ri_suma(segmento)
  global indice_temporales
  global primer_elemento
  global codigo_intermedio

  variable = segmento.token.lexema
  suma = segmento.noterminal
  primer_elemento = 0
  ri_suma_recursiva(suma)

  	try
  		codigo_intermedio = codigo_intermedio * "$(tabla_simbolos[variable]["temporal"]) =  t$(indice_temporales-1)\n"
  	catch
	  	push!(tabla_simbolos[variable], "temporal"=>"t$(indice_temporales)")
		codigo_intermedio = codigo_intermedio * "t$(indice_temporales) =  t$(indice_temporales-1)\n"
		indice_temporales= indice_temporales+1
    end

end

function ri_asignacion(segmento)
global indice_temporales
global codigo_intermedio
id= segmento.token.lexema
tipo = segmento.noterminal.expresion.tipo
valor = segmento.noterminal.expresion.lexema

    try

	    if tipo=="identificador"
		    #println(tabla_simbolos[id]["temporal"], " =", tabla_simbolos[valor]["temporal"])
		    codigo_intermedio = codigo_intermedio * "$(tabla_simbolos[id]["temporal"]) = $(tabla_simbolos[valor]["temporal"])\n"
	    else
	    	#println(tabla_simbolos[id]["temporal"] , " =", valor)
	    	codigo_intermedio = codigo_intermedio * "$(tabla_simbolos[id]["temporal"]) = $(valor)\n"
	    end

    catch e
        if tipo=="identificador"
			#println(" t$(indice_temporales) =", tabla_simbolos[valor]["temporal"])
			codigo_intermedio = codigo_intermedio *  "t$(indice_temporales) = $(tabla_simbolos[valor]["temporal"])\n"
	    else
	    	#println(" t$(indice_temporales) =", valor)
	    	codigo_intermedio = codigo_intermedio * "t$(indice_temporales) = $(valor)\n"
	    end

	  push!(tabla_simbolos[id], "temporal"=>"t$(indice_temporales)")
	  indice_temporales= indice_temporales+1
    end


end

function traslada_impresion(segmento)
	global codigo_intermedio

	dato_a_imprimir = segmento.noterminal.valor.token
	if dato_a_imprimir.tipo=="identificador"
		codigo_intermedio = codigo_intermedio * "println($(tabla_simbolos[dato_a_imprimir.lexema]["temporal"]))\n"
	else
		codigo_intermedio = codigo_intermedio * "println($(dato_a_imprimir.lexema))\n"
	end

end

#=function verifica_comparacion(segmento)
	variable = segmento.noterminal.comparacion.igualdad.token

	try
	  tabla_simbolos[variable.lexema]["tipo"]
	catch e
		error_sematico(" la variable no se ha inicializado ", variable)
	end

	if tabla_simbolos[variable.lexema]["tipo"] !="numero_entero"
		error_sematico(" la variable a comparar debe ser de tipo entero ", variable)
	end
end=#

 function ri(arbol)

	t = typeof(arbol)
	for f in fieldnames(t)
	    elemento = getfield(arbol, f)

	    if elemento != nothing

		    if string(typeof(elemento)) == "objetoelemento"

		     	if string(typeof(elemento.noterminal)) == "asignacion"
	                if elemento.noterminal.suma != nothing
	                    ri_suma(elemento)
	                else
	                    ri_asignacion(elemento)
	                end
	            else string(typeof(elemento.noterminal)) == "ntif"
	            	#=if (elemento.token.lexema == "si")
	            	 verifica_comparacion(elemento)
	            	end=#
	            	if (elemento.token.lexema == "imprimir")
	            	 traslada_impresion(elemento)
	            	end

	            end

            else

             	if string(typeof(elemento)) != "token"
                  ri(elemento)
	            end

		    end

	    end

	end

 end

function generador_codigointermedio(arbol)
    #global codigo_intermedio
     ri(arbol)
    return codigo_intermedio
end