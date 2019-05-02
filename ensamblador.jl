

function conversion_a_ensamblador(codigo_intermedio)
    indicemsg = 1
	codigo_ensamblador = ""

	segmento_de_datos= "segment .data\n"
	segmento_de_codigo= "segment .text\nglobal _start\n_start:\n"

    temporales_ensamblador = Dict()

     for  variable in values(tabla_simbolos)

            if haskey(variable, "temporal")
            	push!(temporales_ensamblador, variable["temporal"]=> variable["valor"])

				if variable["valor"] != "-"
                 segmento_de_datos = segmento_de_datos* "$(variable["temporal"])  db $(variable["valor"])\nlon$(variable["temporal"]) equ \$ -$(variable["temporal"])\n"
	             else
	             	segmento_de_datos = segmento_de_datos* "$(variable["temporal"])  db 0\nlon$(variable["temporal"]) equ \$ -$(variable["temporal"])\n"
	             end
            end
     end

    #println(temporales_ensamblador)

    lineas = split(codigo_intermedio, "\n")

	for instruccion in lineas
        m= match(r"(?<izquierdo>t[0-9]+)(\s*=\s*)(?<numero>\d+)", instruccion) # t4= 1
        if string(typeof(m)) != "Nothing"
	        if haskey(temporales_ensamblador,m[:izquierdo])
	        	segmento_de_codigo= segmento_de_codigo * "    mov eax,$(m[:numero]) \n    mov [$(m[:izquierdo])],eax\n"
	        else
	        	segmento_de_datos = segmento_de_datos* "$(m[:izquierdo])  db 0\nlon$(m[:izquierdo]) equ \$ -$(m[:izquierdo])\n"
	        	segmento_de_codigo= segmento_de_codigo * "    mov eax,$(m[:numero]) \n    mov [$(m[:izquierdo])],eax\n"
	        end
	    else
	        m= match(r"(?<izquierdo>t[0-9]+)(\s*=\s*)(?<derecho>t[0-9]+)(\s)*$", instruccion) # t4= t1
		    if string(typeof(m)) != "Nothing"
		    	if haskey(temporales_ensamblador,m[:izquierdo])
	        	segmento_de_codigo= segmento_de_codigo * "\n    mov eax,[$(m[:derecho])] \n    mov [$(m[:izquierdo])],eax\n\n"
		        else
		        	segmento_de_datos = segmento_de_datos* "$(m[:izquierdo])  db 0\nlon$(m[:izquierdo]) equ \$ -$(m[:izquierdo])\n"
		        	segmento_de_codigo= segmento_de_codigo * "\n    mov eax,[$(m[:derecho])] \n    mov [$(m[:izquierdo])],eax\n\n"
		        end


		    else
		      m= match(r"(?<izquierdo>t[0-9]+).*(?<derecho>t[0-9]+).*(?<numero>\d+)",instruccion) # t10 = t9 + 5
		      if string(typeof(m)) != "Nothing"

                  if haskey(temporales_ensamblador,m[:izquierdo])
		        	segmento_de_codigo= segmento_de_codigo * "  mov eax,[$(m[:derecho])] \n  add eax, $(m[:numero])  \n  mov [$(m[:izquierdo])],eax\n"
			        else
			        	segmento_de_datos = segmento_de_datos* "$(m[:izquierdo])  db 0\nlon$(m[:izquierdo]) equ \$ -$(m[:izquierdo])\n"

			        	segmento_de_codigo= segmento_de_codigo * "  mov eax,[$(m[:derecho])] \n  add eax, $(m[:numero])  \n  mov [$(m[:izquierdo])],eax\n"
			        end
		      else
		      	if occursin("println", instruccion)
					 m= match(r"(?<izquierdo>t[0-9]+)",instruccion)
					 if string(typeof(m)) != "Nothing"
					 	instruccion = replace(instruccion, "println(" => "")
					 	instruccion = replace(instruccion, ")" => "")

					 	segmento_de_codigo= segmento_de_codigo * "mov eax,[$(instruccion)]\nadd eax, 48\nmov [$(instruccion)],eax\nmov eax, 4\nmov ebx, 0\nmov ecx, $(instruccion)\nmov edx, lon$(instruccion)\nint 80h\n"
					 else
					 	instruccion = replace(instruccion, "println(" => "")
					 	instruccion = replace(instruccion, ")" => "")
					 	instruccion = replace(instruccion, "\"" => "")
					 	instruccion = replace(instruccion, "\"" => "")
                        instruccion = "\""*instruccion*"\""
					 	segmento_de_datos = segmento_de_datos* "dato$(indicemsg)  db $(instruccion) \nlondato$(indicemsg) equ \$ -dato$(indicemsg)\n"

					 	segmento_de_codigo= segmento_de_codigo * "\nmov eax, 4\nmov ebx, 0\nmov ecx, dato$(indicemsg)\nmov edx, londato$(indicemsg)\nint 80h\n"

					 	indicemsg = indicemsg+1
					 end
			    end
		      end
		    end
		end
	end

    segmento_de_codigo= segmento_de_codigo * "salir:\nmov eax, 1\nmov ebx, 0\nint 0x80"

    codigo_ensamblador= segmento_de_datos * segmento_de_codigo

	io = open("programa.asm", "w");
	write(io, codigo_ensamblador);
	close(io);
	println(" programa.asm creado con exito\n ensamble con el comando:\n  nasm -f elf programa.asm \n y ligue con: \n ld -m elf_i386 -s -o programa programa.o")
end