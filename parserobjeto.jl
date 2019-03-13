abstract type Node end
struct programa <:Node
  token
  parametro
  cuerpo_programa
end

struct parametro <:Node
  token
  valor
  token2
end

struct cuerpo_programa <:Node
  token
  elementos
  token2
end

struct valor <:Node
  token
end

struct objetoelementos <:Node
  token
  noterminal
  elementos
end

struct asignacion <:Node
  token
  cosa
end

struct cosa <:Node
  token
end

struct objetosuma <:Node
  dato
  token
  suma
end

struct dato <:Node
  token
end

struct ntif <:Node
  comparacion
  cuerpo_programa
end

struct comparacion <:Node
  token
  igualdad
  token2
end

struct igualdad <:Node
  token
  token2
  token3
end


function unexpected(tokenesperado,token)
  return "error sintactico se esperaba el token "*tokenesperado*", pero se encontro  ' "*token.lexema*" ' "
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
        tokens.siguiente()
        parametro=parser_parametro(tokens)
        tokens.siguiente()
        cuerpoprograma=parser_cuerpoprograma(tokens)
        return programa(token, parametro, cuerpoprograma)
    end
    return error_sintactico("origen", token)
end

function parser_cuerpoprograma(tokens)
    token = tokens.actual()
    if token.lexema == "inicio"
        tokens.siguiente()
        elementos = parser_elementos(tokens)
        tokens.siguiente()
        token2 = tokens.actual()
        if token2.lexema == "fin"
            return cuerpo_programa(token,elementos,token2)
        else
            return error_sintactico("fin", token2)
        end
    else
       return error_sintactico("inicio", token)
    end
end
function parser_parametro(tokens)
    token = tokens.actual()
    if token.lexema == "¿"
        tokens.siguiente()
        valor = parser_valor(tokens)
        tokens.siguiente()
        token2 = tokens.actual()
        if token2.lexema == "?"
            return parametro(token,valor,token2)
        else
            return error_sintactico("?", token2)
        end
    else
        return error_sintactico("¿", token)
    end
end
function parser_valor(tokens)
    token = tokens.actual()
    if token.tipo == "string"
        return valor(token)
    end
    if token.tipo == "identificador"
        return valor(token)
    end
    if token.tipo == "numero_entero"
        return valor(token)
    end
    if token.lexema == "?"
        tokens.anterior()
        return nothing
    end

    return error_sintactico(" string, identificador o numero_entero", token)
end

function parser_elementos(tokens)

    token = tokens.actual()
    if token.lexema == "imprimir"
        tokens.siguiente()
        parametro = parser_parametro(tokens)
        tokens.siguiente()
        elementos = parser_elementos(tokens)
        return objetoelementos(token, parametro, elementos)
    elseif token.lexema == "si"
        tokens.siguiente()
        ntif = parser_if(tokens)
        tokens.siguiente()
        elementos = parser_elementos(tokens)
        return objetoelementos(token, ntif, elementos)
    elseif token.tipo == "identificador"
        tokens.siguiente()
        asignacion = parser_asignacion(tokens)
        tokens.siguiente()
        elementos = parser_elementos(tokens)
        return objetoelementos(token, asignacion, elementos)
    else
        return nothing
    end

end

function parser_asignacion(tokens)
    token = tokens.actual()
        if token.lexema == "="
            tokens.siguiente()
            cosa = parser_cosa(tokens)
            return asignacion(token, cosa)
        end
    return error_sintactico("=", token)
end

function parser_cosa(tokens)
    token = tokens.actual()
    if token.tipo == "string"
       return token
    else
       return parser_suma(tokens)
    end
end
function parser_suma(tokens)
    dato = parser_dato(tokens)
    tokens.siguiente()
    token = tokens.actual()
    if token.lexema == "+"
        tokens.siguiente()
        suma = parser_suma(tokens)
        return objetosuma(dato, token, suma)
    else
        tokens.anterior()
        return dato
    end

end

function parser_dato(tokens)
    token = tokens.actual()
    if token.tipo == "identificador"
        return dato(token)
    end
    if  token.tipo == "numero_entero"
        return dato(token)
    end

return error_sintactico(" identificador o un numero_entero ", token)
end

function parser_if(tokens)
compracion = parser_comparacion(tokens)
tokens.siguiente()
cuerpo_programa = parser_cuerpoprograma(tokens)
return ntif(compracion, cuerpo_programa)
end

function parser_comparacion(tokens)
    token = tokens.actual()
    if token.lexema == "¿"
        tokens.siguiente()
        igualdad = parser_igualdad(tokens)
        tokens.siguiente()
        token2 = tokens.actual()
        if token2.lexema == "?"
            return comparacion(token, igualdad, token2)
        else
            return error_sintactico(" ? ", token)
        end
    else
        return error_sintactico(" ¿ ", token)
    end
end

function parser_igualdad(tokens)
    token = tokens.actual()
    if token.tipo == "identificador"
        tokens.siguiente()
        token2 = tokens.actual()
        if token2.lexema == "=="
            tokens.siguiente()
            token3 = tokens.actual()
            if token3.tipo == "numero_entero"
                return igualdad(token,token2,token3)
            else
                return error_sintactico(" numero_entero ", token3)
            end
        else
            return error_sintactico(" == ", token2)
        end
    else
        return error_sintactico(" identificador ", token)
    end
end


#=function Base.show(io::IO, x::Node)
  t = typeof(x)
  print(io, "\n\e[33m < \e[37m")
    for f in fieldnames(t)
      elemento = getfield(x, f)
      v= true
      try
        v = length(elemento)>0
      catch
        v=true
      end
      if (elemento!=nothing && v)
          print(io,"Node :: ",elemento)

      end
    end

  print(io,"\e[33m > \e[37m")
end=#