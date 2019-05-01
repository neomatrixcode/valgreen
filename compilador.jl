include("parserobjeto.jl")
include("semantico.jl")
include("intermedio.jl")
include("interprete.jl")

f = open("holamundo.val")
read(f,String)
texto = String(take!(f))
texto= texto*" \n"
cantidad_caracteres = length(texto)
indice=1

mutable struct token
tipo
lexema
fila
columna
end
tabla_simbolos = Dict()
arreglo_tokens=[]
fila=1
columna=1

while(indice<= cantidad_caracteres)
	global indice
	global arreglo_tokens
	global fila
	global columna
	try
		if (texto[indice]== '\n')
		    fila=fila+1
		    columna= 1
		elseif texto[indice]== ' '
           columna=columna+1
        elseif texto[indice]== '\t'
           columna=columna+5
		elseif texto[indice]== '?'
			#println("\tsimbolo_de_?\t?")
            columna=columna+1
			push!(arreglo_tokens,token("simbolo_de_?","?",fila,columna))
		elseif texto[indice]== '¿'
			#println("\tsimbolo_de_¿\t¿")
            columna=columna+1
			push!(arreglo_tokens,token("simbolo_de_¿","¿",fila,columna))

		elseif texto[indice]== '+'
			#println("\t  operador     +")
            columna= columna+1
			push!(arreglo_tokens,token("operador","+",fila,columna))
		elseif texto[indice]== '='
			if(texto[indice+1]== '=')
				#println("\tcomparacion     ==")
				indice= indice+1
				columna=columna+2
			    push!(arreglo_tokens,token("comparacion","==",fila,columna))
			else
				#println("\t asignacion    =")
				columna= columna+1
				push!(arreglo_tokens,token("asignacion","=",fila,columna))
			end

		elseif('0'<= texto[indice] <= '9' )
			buffer= ""
			while('0'<= texto[indice]<='9')
				buffer = buffer*texto[indice]
				indice = indice+1
				columna=columna+1
			end
			indice = indice-1

			push!(arreglo_tokens,token("numero_entero",buffer,fila,columna))

		elseif texto[indice]=='#'
			columna=columna+1
			while(texto[indice]!='\n')
				indice = indice+1
				columna=columna+1
			end
			fila=fila+1
			columna=1
        elseif texto[indice]=='"'
        	buffer=""
        	buffer = buffer*texto[indice]
			indice = indice+1
			columna=columna+1
			while(texto[indice]!='"')
				buffer = buffer*texto[indice]
				indice = indice+1
				columna=columna+1
			end
            #println("\tstring   "*buffer*"\"")
			push!(arreglo_tokens,token("string",buffer*"\"",fila,columna))

		elseif 'a'<= texto[indice]<='z'
			buffer = ""
			while('a'<= texto[indice]<='z' || '0'<= texto[indice]<='9')
				buffer = buffer*texto[indice]
				indice = indice+1
				columna=columna+1
			end

			if buffer== "origen"
			    #println("   palabra reservada   "*buffer)
				push!(arreglo_tokens,token("palabra reservada",buffer,fila,columna))
		    elseif buffer== "inicio"
			    #println("   palabra reservada   "*buffer)
				push!(arreglo_tokens,token("palabra reservada",buffer,fila,columna))
			elseif buffer== "fin"
			    #println("   palabra reservada   "*buffer)
				push!(arreglo_tokens,token("palabra reservada",buffer,fila,columna))
			elseif buffer== "si"
			    #println("   palabra reservada   "*buffer)
				push!(arreglo_tokens,token("palabra reservada",buffer,fila,columna))
			elseif buffer== "imprimir"
			    #println("   palabra reservada   "*buffer)
				push!(arreglo_tokens,token("palabra reservada",buffer,fila,columna))
			elseif (match(Regex("[a-z]+[0-9]*[a-z]*"),buffer) != nothing)
				#println("  identificador   "*buffer)
				push!(arreglo_tokens,token("identificador",buffer,fila,columna))
				if !haskey(tabla_simbolos,buffer)
		          push!(tabla_simbolos, buffer => Dict())
		          #println("ingresado")
			    end
		    else
		    	error("ERROR LEXICO, PALABRA NO RECONOCIDA "* buffer)
			end
			indice= indice-1
	    else
	       error("ERROR LEXICO, SIMBOLO NO RECONOCIDO "* texto[indice])
		end
		indice= indice+1
		#columna=columna+1
	catch e
	   if e isa ErrorException
	   	 rethrow(e)
	   else
		indice= indice+1
		#columna=columna+1
       end
    end
end

#impresion de los tokens en pantalla (tipo y lexema)
for token in arreglo_tokens
    println(token.tipo *"\t"*token.lexema*"\t("*string(token.fila)*","*string(token.columna)*")")
end

mutable struct tokens
    actual
    siguiente
    anterior
    function tokens(datos)
        arreglotokens =datos
        indice = 1
        fin =  length(arreglotokens)

        function siguiente()
            if indice<fin
                indice = indice+1
            end
        end

        function anterior()
            if indice>1
                indice = indice-1
            end
        end

        function actual()
        	return arreglotokens[indice]
        end
        new(actual,siguiente,anterior)
    end
end


todoslostokens = tokens(arreglo_tokens)


println("parser-----------------")
arbol= Parser(todoslostokens)
#println(arbol)


println("analisis semantico ---------------")

recorre(arbol)

#println(tabla_simbolos)
#println(tabla_simbolos["variable1"])
println("representacion intermedia ---------------")
codigogen= generador_codigointermedio(arbol)

println("interprete ---------------")
interprete(codigogen)

