
texto = "origen inicio\n#comentario\nvariable1= 200000000\nvariable2= 3\nvariable5= variable1+5\n\nsi variable1==1 inicio\n imprimir\"ola\"\nfin\n\nfin      "


cantidad_caracteres = length(texto)
indice=1

while(indice<= cantidad_caracteres)
global indice

#println("carecter leido:  "* texto[indice])

if texto[indice]== '+'
println("   operador     +")
end

if texto[indice]== '='

if(texto[indice+1]== '=')
println("   comparacion     ==")
indice=indice+1
else
println("    asignacion    =")
end

end


#if texto[indice] != " "

#println("cosaaaa   "*texto[indice])

if('0'<= texto[indice] <= '9' )
buffer= ""

 while('0'<= texto[indice]<='9')
 buffer = buffer*texto[indice]
 indice = indice+1
 end

  println("   numero entero   "*buffer)

end

#end



if 'a'<= texto[indice]<='z'
 buffer = ""

 while('a'<= texto[indice]<='z' || '0'<= texto[indice]<='9')
 buffer = buffer*texto[indice]
 indice = indice+1
 end

 #println("la palabra encontrada es: "* buffer)

 if buffer== "origen"
println("   palabra reservada   "*buffer)
end


if buffer== "inicio"
println("   palabra reservada   "*buffer)
end

if buffer== "fin"
println("   palabra reservada   "*buffer)
end

if buffer== "si"
println("   palabra reservada   "*buffer)
end

if buffer== "imprimir"
println("   palabra reservada   "*buffer)
end


if (match(Regex("[a-z]+[0-9]*[a-z]*"),buffer)== nothing)
 println("asco tu programa amiga")
 else
 println("  nombre_de_variable   "*buffer)
 end

 indice= indice-1
end




indice= indice+1
end