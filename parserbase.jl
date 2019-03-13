
function unexpected(tokenesperado,token)
  return "error sintactico se esperaba el token "*tokenesperado*", pero se encontro"*token.lexema
end
function error_sintactico(esperado, token)
return throw(ErrorException(unexpected(esperado,token)))
end

function Parser(tokens)
return parser_programa(tokens)
end

function parser_programa(tokens)
    token = tokens.actual()
    if token.lexema == "origen"
    	println(token.lexema)
    	tokens.siguiente()
    	parser_parametro(tokens)
    	tokens.siguiente()
    	parser_cuerpoprograma(tokens)
        #return programa(token, objetoparametro, objeto_cuerpoprograma)
    end
    #return error_sintactico("origen", token)
end

function parser_cuerpoprograma(tokens)
	token = tokens.actual()
    if token.lexema == "inicio"
    	println(token.lexema)
    	tokens.siguiente()
    	parser_elementos(tokens)
    	tokens.siguiente()
    	token2 = tokens.actual()
        if token2.lexema == "fin"
        	println(token2.lexema)
        end
    end
end
function parser_parametro(tokens)
    token = tokens.actual()
    if token.lexema == "¿"
    	println(token.lexema)
    	tokens.siguiente()
    	parser_valor(tokens)
    	tokens.siguiente()
    	token2 = tokens.actual()
        if token2.lexema == "?"
        	println(token2.lexema)
        end
    end
end
function parser_valor(tokens)
	token = tokens.actual()
    if token.tipo == "string"
        println(token.lexema)
    end
    if token.tipo == "identificador"
    	println(token.lexema)
    end
    if token.tipo == "numero_entero"
    	println(token.lexema)
    end
    if token.lexema == "?"
        tokens.anterior()
    end
end

function parser_elementos(tokens)

    token = tokens.actual()
    if token.lexema == "imprimir"
        println(token.lexema)
        tokens.siguiente()
        parser_parametro(tokens)
    	parser_elementos(tokens)
    end
    if token.lexema == "si"
        println(token.lexema)
        tokens.siguiente()
        parser_if(tokens)
        tokens.siguiente()
    	parser_elementos(tokens)
    end
    if token.tipo == "identificador"
        println(token.lexema)
        tokens.siguiente()
	    parser_asignacion(tokens)
	    tokens.siguiente()
	    parser_elementos(tokens)
    end

end

function parser_asignacion(tokens)
	token = tokens.actual()
    	if token.lexema == "="
	    	println(token.lexema)
	    	tokens.siguiente()
	    	parser_cosa(tokens)
        end
end

function parser_cosa(tokens)
	token = tokens.actual()
    if token.tipo == "string"
        println(token.lexema)
    else
    	parser_suma(tokens)
    end
end
function parser_suma(tokens)
	parser_dato(tokens)
    tokens.siguiente()
    token = tokens.actual()
    if token.lexema == "+"
        println(token.lexema)
        tokens.siguiente()
        parser_suma(tokens)
    else
        tokens.anterior()
    end

end

function parser_dato(tokens)
    token = tokens.actual()
    if token.tipo == "identificador"
        println(token.lexema)
    end
    if  token.tipo == "numero_entero"
        println(token.lexema)
    end
end

function parser_if(tokens)
parser_comparacion(tokens)
tokens.siguiente()
parser_cuerpoprograma(tokens)
end

function parser_comparacion(tokens)
    token = tokens.actual()
    if token.lexema == "¿"
    	println(token.lexema)
    	tokens.siguiente()
    	parser_igualdad(tokens)
    	tokens.siguiente()
    	token2 = tokens.actual()
        if token2.lexema == "?"
        	println(token2.lexema)
        end
    end
end

function parser_igualdad(tokens)
 	token = tokens.actual()
    if token.tipo == "identificador"
    	println(token.lexema)
    	tokens.siguiente()
    	token2 = tokens.actual()
    	if token2.lexema == "=="
	    	println(token2.lexema)
	    	tokens.siguiente()
	    	token3 = tokens.actual()
	    	if token3.tipo == "numero_entero"
	    	    println(token3.lexema)
	    	end
        end
    end
end